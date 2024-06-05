import "package:docs_sync/screens/app_screens.dart";

class CollaboratorsDialog extends ConsumerStatefulWidget {
  const CollaboratorsDialog({super.key});

  @override
  ConsumerState<CollaboratorsDialog> createState() =>
      _CollaboratorsDialogState();
}

class _CollaboratorsDialogState extends ConsumerState<CollaboratorsDialog> {
  final TextEditingController _controller = TextEditingController(text: "");
  CollaboratorType _type = CollaboratorType.viewer;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                "Your collaborators",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () => context.pop(),
                child: Icon(
                  Icons.cancel_outlined,
                ),
              )
            ],
          ),
          8.kH,
          Wrap(
            children: [
              ...List.generate(
                6,
                (index) => const ViewCollaboratorWidget(),
              )
            ],
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
            onPressed: () {},
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
  final Function()? onPressed;

  const ViewCollaboratorWidget({
    super.key,
    this.onPressed,
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
                  onTap: onPressed,
                  child: const Icon(Icons.cancel),
                ),
              ),
            ],
          ),
        ),
        4.kH,
        const SizedBox(
            width: 75,
            child: Text(
              "Dubem Ezeagwu You",
              softWrap: true,
            ))
      ],
    );
  }
}
