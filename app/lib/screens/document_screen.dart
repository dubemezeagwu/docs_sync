import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:docs_sync/domain/app_domain.dart';
import 'package:docs_sync/repository/app_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';
import 'package:docs_sync/screens/widgets/bottom_sheet_options_widget.dart';
import 'package:docs_sync/screens/widgets/lottie_animation_view.dart';
import 'package:docs_sync/view_models/document_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:pdf/widgets.dart' as pw;
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _micText = "Press the button and start speaking";
  double _confidence = 1.0;

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
      {required String docId, required String title}) {
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
                      icon: SvgPicture.asset(
                        AppAssets.sent,
                        height: 25,
                        width: 25,
                        color: kDarkGrey,
                      ),
                      onPressed: () {},
                      title: "Send Document"),
                  BottomSheetOptionsWidget(
                      icon: SvgPicture.asset(
                        AppAssets.noteEdit,
                        height: 25,
                        width: 25,
                        color: kDarkGrey,
                      ),
                      onPressed: () {
                        context.pop();
                        convertDocToPDF(context);
                      },
                      title: "Create PDF"),
                  Visibility(
                    visible: document!.isPublic ?? true,
                    child: BottomSheetOptionsWidget(
                        icon: SvgPicture.asset(
                          AppAssets.userAdd,
                          height: 25,
                          width: 25,
                          color: kDarkGrey,
                        ),
                        onPressed: () {
                          context.pop();
                          addCollaborators(context);
                        },
                        title: "Add collaborators"),
                  ),
                  BottomSheetOptionsWidget(
                      icon: SvgPicture.asset(
                        AppAssets.link,
                        height: 25,
                        width: 25,
                        color: kDarkGrey,
                      ),
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
    try {
      final pdf = pw.Document();
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        // theme: pw.ThemeData.withFont(
        //   fontFallback: [globalFont!],
        // ),
        build: (context) {
          var delta = _quillController?.document.toDelta();
          pw.Widget dpdf = DeltaToPDF.toPDFWidget(delta!);
          return dpdf;
        },
      ));
      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/${document?.title ?? "document"}.pdf");
      // final file = File("${output.path}/$document.pdf");
      await file.writeAsBytes(await pdf.save());

      if (!context.mounted) return;
      OpenAppFile.open("${output.path}/${document?.title ?? "document"}.pdf");
    } catch (e) {
      if (!context.mounted) return;
      FloatingSnackBar(
          message: "Failed to open PDF",
          backgroundColor: kPrimary,
          duration: const Duration(seconds: 1),
          textColor: kBlack,
          context: context);
    }
  }

  void addCollaborators(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: CollaboratorsDialog(
              document: document,
            ),
          );
        });
  }

  

  void listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onError: (val) => print("onError: ${val.errorMsg}"),
        onStatus: (status) => print("onStatus: $status"),
      );
      if (available) {
        setState(() => _isListening = true);
        await _speech.listen(
          onResult: (val) => setState(() {
            _micText = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            print("onResult: ${val.recognizedWords}");
          }),
        );
        
      }
    } else {
      setState(() => _isListening = false);
      await _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_quillController == null) {
      return const Scaffold(
        body: Center(
          child: SizedBox(
              height: 100, width: 100, child: LoadingContentsAnimationView()),
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
              AppAssets.noteEdit,
              height: 25,
              width: 25,
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
              icon: SvgPicture.asset(
                AppAssets.share,
                height: 25,
                width: 25,
              ),
              label: const Text(
                AppStrings.share,
                style: TextStyle(color: kBlack),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(kPrimary)),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: kDarkGrey, width: 0.7)),
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
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: kBlack,
        child: FloatingActionButton(
          onPressed: () {
            listen();
          },
          // onPressed: listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
}

// white overlay on the bottom sheet when visible
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
