import 'package:docs_sync/core/constants/color_constants.dart';
import 'package:docs_sync/domain/models/document_model.dart';
import 'package:docs_sync/repository/document_repository.dart';
import 'package:docs_sync/repository/local_storage_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';

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
  final quill.QuillController _quillController = quill.QuillController.basic();
  Document? document;

  @override
  void initState() {
    super.initState();
    fetchDocumentData(ref);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void updateTitle(WidgetRef ref,
      {required String docId, required String title}) async {
    String? token = await ref.read(localStorageProvider).getToken();
    ref
        .read(documentRepositoryProvider)
        .updateDocumentTitle(token: token ?? "", id: docId, title: title);
  }

  void fetchDocumentData(WidgetRef ref) async {
    String? token = await ref.read(localStorageProvider).getToken();
    final data = await ref
        .read(documentRepositoryProvider)
        .getDocumentById(token ?? "", widget.id);

    if (data.data != null) {
      _titleController.text = (data.data as Document).title;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              "assets/svg/note.svg",
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
                onPressed: () {},
                icon: const Icon(Icons.lock),
                label: const Text("Share")),
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
            controller: _quillController,
            sharedConfigurations: const quill.QuillSharedConfigurations(
              locale: Locale('de'),
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
