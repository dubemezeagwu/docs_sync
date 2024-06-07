import "package:docs_sync/domain/models/document_model.dart";
import "package:docs_sync/screens/app_screens.dart";
import "package:docs_sync/view_models/document_view_model.dart";

class CollaboratorsDialog extends ConsumerStatefulWidget {
  final Document? document;
  const CollaboratorsDialog({super.key, this.document});

  @override
  ConsumerState<CollaboratorsDialog> createState() =>
      _CollaboratorsDialogState();
}

class _CollaboratorsDialogState extends ConsumerState<CollaboratorsDialog> {
  final TextEditingController _controller = TextEditingController(text: "");
  CollaboratorType _type = CollaboratorType.viewer;

  void addCollaborator(
      {required String docId, required Map<String, dynamic> data}) {
    ref
        .read(documentsNotifier.notifier)
        .addCollaborators(docId: docId, data: data);
  }

  void removeCollaborator(
      {required String docId, required String collaboratorId}) {
    ref
        .read(documentsNotifier.notifier)
        .removeCollaborators(docId: docId, collaboratorId: collaboratorId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doc = ref.watch(documentsNotifier.select((value) =>
        value.value?.firstWhere((doc) => doc.id == widget.document?.id)));
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          16.kH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your collaborators",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () => context.pop(),
                child: SvgPicture.asset(
                  AppAssets.cancelRounded,
                  height: 25,
                  width: 25,
                ),
              )
            ],
          ),
          8.kH,
          // Wrap(
          //   children: <Widget>[
          //     ...(doc!.collaborators ?? []).map((collaborator) =>
          //         ViewCollaboratorWidget(title: collaborator["uid"]))
          //   ],
          // ),
          (doc != null &&
                  doc.collaborators != null &&
                  doc.collaborators!.isNotEmpty)
              ? Wrap(
                  children: [
                    ...(doc.collaborators ?? [])
                        .map((e) => ViewCollaboratorWidget(
                              title: e["uid"],
                              onCancel: () {
                                removeCollaborator(
                                    docId: doc.id, collaboratorId: e["uid"]);
                              },
                            ))
                  ],
                )
              : const SizedBox(
                  child: Text("No collaborators currently"),
                ),
          8.kH,
          const Text(
            "Add a collaborator",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: kBlack)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimary)),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _controller.text = value;
                      });
                    },
                  ),
                ),
                8.kW,
                Flexible(
                  flex: 3,
                  child: DropdownButtonFormField(
                      isExpanded: true,
                      alignment: Alignment.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      value: _type,
                      items: CollaboratorType.values.map((CollaboratorType e) {
                        return DropdownMenuItem<CollaboratorType>(
                          value: e,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              e.icon,
                              Text(e.title),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _type = newValue!;
                        });
                      }),
                )
              ],
            ),
          ),
          16.kH,
          ElevatedButton(
            onPressed: () {
              addCollaborator(docId: doc?.id ?? "", data: {
                "uid": _controller.text.toString(),
                "role": _type.title,
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                minimumSize: const Size(150, 50),
                side: const BorderSide(color: kBlack, width: 1.0)),
            child: const Text("Add"),
          ),
          16.kH,
        ],
      ),
    );
  }
}

class ViewCollaboratorWidget extends StatelessWidget {
  final String title;
  final Function()? onCancel;

  const ViewCollaboratorWidget({
    super.key,
    this.onCancel,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: kPrimary,
                child: ClipOval(),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  onTap: onCancel,
                  child: SvgPicture.asset(
                    AppAssets.cancel,
                    height: 20,
                    width: 20,
                    color: kAlert,
                  ),
                ),
              ),
            ],
          ),
        ),
        4.kH,
        SizedBox(
          width: 75,
          child: Text(
            title,
            softWrap: true,
          ),
        )
      ],
    );
  }
}
