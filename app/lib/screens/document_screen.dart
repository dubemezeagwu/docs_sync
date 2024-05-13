import 'dart:async';

import 'package:docs_sync/domain/app_domain.dart';
import 'package:docs_sync/repository/app_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';
import 'package:docs_sync/view_models/document_view_model.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;

  const DocumentScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  final TextEditingController _titleController =
      TextEditingController(text: "");
  quill.QuillController? _quillController;
  Document? document;
  SocketRepository socketRepository = SocketRepository();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData(ref);

    socketRepository.onChangedListener((data) {
      _quillController?.compose(
          quill.Delta.fromJson(data["delta"]),
          _quillController?.selection ??
              const TextSelection.collapsed(offset: 0),
          quill.ChangeSource.remote);
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        "delta": _quillController?.document.toDelta(),
        "room": widget.id
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timer?.cancel();
    _quillController?.dispose();
    super.dispose();
  }

  void updateTitle(WidgetRef ref,
      {required String docId, required String title}) async {
    ref
        .read(documentsNotifier.notifier)
        .updateDocumentTitle(id: docId, title: title);
  }

  void fetchDocumentData(WidgetRef ref) async {
    final data =
        await ref.read(documentsNotifier.notifier).getDocumentById(widget.id);

    if (data != null) {
      _titleController.text = (data).title;
      _quillController = quill.QuillController(
          document: data.content.isEmpty
              ? quill.Document()
              : quill.Document.fromDelta(quill.Delta.fromJson(data.content)),
          selection: const TextSelection.collapsed(offset: 0));
      setState(() {});
    }

    _quillController?.document.changes.listen((event) {
      if (event.source == quill.ChangeSource.local) {
        Map<String, dynamic> map = {
          "delta": event.change,
          "room": widget.id,
        };
        socketRepository.typing(map);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quillController == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              AppAssets.note,
              height: 25,
              width: 10,
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimary)),
                  contentPadding: EdgeInsets.only(left: 10),
                ),
                onSubmitted: (value) =>
                    updateTitle(ref, docId: widget.id, title: value),
              ),
            )
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                          text:
                              "http://localhost:3000/#/document/${widget.id}"))
                      .then((value) => FloatingSnackBar(
                          message: AppStrings.linkCopied,
                          backgroundColor: kPrimary,
                          duration: const Duration(seconds: 1),
                          textColor: kBlack,
                          context: context));
                },
                icon: const Icon(Icons.lock),
                label: const Text(AppStrings.share)),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: kDarkGrey, width: 0.1)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: quill.QuillProvider(
          configurations: quill.QuillConfigurations(
            controller: _quillController!,
            sharedConfigurations: const quill.QuillSharedConfigurations(
              locale: Locale('en'),
            ),
          ),
          child: Column(
            children: [
              const quill.QuillToolbar(),
              Expanded(
                child: Card(
                  child: quill.QuillEditor.basic(
                    configurations: const quill.QuillEditorConfigurations(
                      readOnly: false,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
