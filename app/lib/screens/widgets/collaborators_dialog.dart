import "package:docs_sync/domain/models/document_model.dart";
import "package:docs_sync/screens/app_screens.dart";
import "package:docs_sync/view_models/document_view_model.dart";
import "package:flutter/material.dart";

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
        .addCollaborators(docId: docId, data: data)
        .then((_) => _controller.clear());
  }

  void removeCollaborator(
      {required String docId, required String collaboratorEmail}) {
    ref.read(documentsNotifier.notifier).removeCollaborators(
        docId: docId, collaboratorEmail: collaboratorEmail);
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
          (doc != null &&
                  doc.collaborators != null &&
                  doc.collaborators!.isNotEmpty)
              ? Wrap(
                  children: [
                    ...(doc.collaborators ?? []).map(
                      (e) => ViewCollaboratorWidget(
                        title: e["user"]["name"],
                        image: e["user"]["profilePicture"],
                        onCancel: () {
                          removeCollaborator(
                              docId: doc.id,
                              collaboratorEmail: e["user"]["email"]);
                        },
                      ),
                    ),
                  ],
                )
              : const SizedBox(
                  child: Text("No collaborators currently"),
                ),
          8.kH,
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter a collaborator",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kBlack, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kPrimary, width: 1),
                      ),
                      contentPadding: const EdgeInsets.only(left: 10),
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
                "email": _controller.text.toString().trim(),
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
  final String? image;
  final String title;
  final Function()? onCancel;

  const ViewCollaboratorWidget({
    super.key,
    this.onCancel,
    this.image,
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
                child: ClipOval(
                  child: CachedNetworkImage(
                      imageUrl: image ?? "",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: InkWell(
                  focusColor: kAlert,
                  onTap: onCancel,
                  child: Container(
                    height: 20,
                    width: 20,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: kAlert.withOpacity(0.7)),
                    child: SvgPicture.asset(
                      AppAssets.cancel,
                      height: 20,
                      width: 20,
                      color: kBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        4.kH,
        SizedBox(
          width: 50,
          child: Text(
            title,
            softWrap: true,
            style: TextStyle(fontSize: 10),
          ),
        )
      ],
    );
  }
}
