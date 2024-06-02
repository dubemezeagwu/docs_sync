import 'dart:async';

import 'package:docs_sync/domain/app_domain.dart';
import 'package:docs_sync/repository/app_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';
import 'package:docs_sync/screens/widgets/bottom_sheet_options_widget.dart';
import 'package:docs_sync/view_models/document_view_model.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:pdf/widgets.dart' as pw;

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

    // socketRepository.onChangedListener((data) {
    //   _quillController?.compose(
    //       quill.Document.fromJson(data["delta"]).toDelta(),
    //       _quillController?.selection ??
    //           const TextSelection.collapsed(offset: 0),
    //       quill.ChangeSource.remote);
    // });

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
    _quillController?.dispose();
    _timer?.cancel();
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
    document = data;
    _titleController.text = (data).title;
    _quillController = quill.QuillController(
        document: (data.content != null && data.content!.isEmpty)
            ? quill.Document()
            : quill.Document.fromDelta(quill.Delta.fromJson(data.content!)),
        selection: const TextSelection.collapsed(offset: 0),
        keepStyleOnNewLine: true);
    setState(() {});

    // _titleController.text = (data).title;
    // _quillController = quill.QuillController(
    //     configurations: const quill.QuillControllerConfigurations(),
    //     document: data.content.isEmpty
    //         ? quill.Document()
    //         : quill.Document.fromJson(data.content),
    //     keepStyleOnNewLine: true,
    //     selection: const TextSelection.collapsed(offset: 0));
    // setState(() {});

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

  void shareDocument(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Stack(
          alignment: AlignmentDirectional.topCenter,
          clipBehavior: Clip.none,
          children: [
            const WhiteDragger(),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  BottomSheetOptionsWidget(
                      icon: Icon(Icons.send),
                      onPressed: () {},
                      title: "Send Document"),
                  BottomSheetOptionsWidget(
                      icon: Icon(Icons.file_copy),
                      onPressed: () {
                        context.pop();
                        convertDocToPDF(context);
                      },
                      title: "Create PDF"),
                  BottomSheetOptionsWidget(
                      icon: Icon(Icons.person_add),
                      onPressed: () {
                        context.pop();
                        addCollaborators(context);
                      },
                      title: "Add collaborators"),
                  BottomSheetOptionsWidget(
                      icon: Icon(Icons.link),
                      onPressed: () {
                        context.pop();
                        copyLink();
                      },
                      title: "Copy Link"),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void copyLink() {
    Clipboard.setData(ClipboardData(
            text: "http://localhost:3000/#/document/${widget.id}"))
        .then((value) => FloatingSnackBar(
            message: AppStrings.linkCopied,
            backgroundColor: kPrimary,
            duration: const Duration(seconds: 1),
            textColor: kBlack,
            context: context));
  }

  void convertDocToPDF(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible:
          true, // Prevent dismissing the dialog with a tap outside
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(), // Show a loading spinner
              Text(
                  "Converting document..."), // Optional: Add a text description
            ],
          ),
        );
      },
    );

    // try {
    //   final pdf = pw.Document();
    //   pdf.addPage(pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     margin: pw.EdgeInsets.zero,
    //     // theme: pw.ThemeData.withFont(
    //     //   fontFallback: [globalFont!],
    //     // ),
    //     build: (context) {
    //       var delta = _quillController?.document.toDelta();
    //       pw.Widget dpdf = DeltaToPDF.toPDFWidget(delta!);
    //       return dpdf;
    //     },
    //   ));
    //   final output = await getApplicationDocumentsDirectory();
    //   final file = File("${output.path}/${document?.title ?? "document"}.pdf");
    //   // final file = File("${output.path}/$document.pdf");
    //   await file.writeAsBytes(await pdf.save());

    //   if (!mounted) return;
    //   context.pop();
    //   OpenAppFile.open("${output.path}/${document?.title ?? "document"}.pdf");
    // } catch (e) {
    //   context.pop();
    //   FloatingSnackBar(
    //       message: "Failed to open PDF",
    //       backgroundColor: kPrimary,
    //       duration: const Duration(seconds: 1),
    //       textColor: kBlack,
    //       context: context);
    // }
  }

  void addCollaborators(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: CollaboratorsDialog(),
          );
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
                  shareDocument(context);
                },
                icon: const Icon(Icons.share),
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
              8.kH,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: kBackground,
                      border: Border.all(color: kBlack, width: 2.0),
                      borderRadius: BorderRadius.circular(32)),
                  child: quill.QuillEditor.basic(
                    configurations: const quill.QuillEditorConfigurations(
                        readOnly: false,
                        padding: EdgeInsets.all(16),
                        showCursor: true),
                  ),
                ),
              ),
              8.kH,
            ],
          ),
        ),
      ),
    );
  }
}

class WhiteDragger extends StatelessWidget {
  const WhiteDragger({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -15,
      child: Container(
        width: 60,
        height: 7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: kWhite,
        ),
      ),
    );
  }
}
