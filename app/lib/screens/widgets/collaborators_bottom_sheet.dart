import "package:docs_sync/screens/app_screens.dart";

class CollaboratorsBottomSheet extends ConsumerStatefulWidget {
  const CollaboratorsBottomSheet({super.key});

  @override
  ConsumerState<CollaboratorsBottomSheet> createState() =>
      _CollaboratorsBottomSheetState();
}

class _CollaboratorsBottomSheetState
    extends ConsumerState<CollaboratorsBottomSheet> {
  final TextEditingController _controller = TextEditingController(text: "");
  CollaboratorType _type = CollaboratorType.viewer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          32.kH,
          const Text(
            "Your collaborators",
            style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
          ),
          8.kH,
          // do a circle avatar wrapped
          Wrap(
            children: [
              ...List.generate(5, (index) => Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
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
                          child: Icon(Icons.cancel),
                        ),
                      ],
                    ),
                  ),
                  4.kH,
                  SizedBox(
                    width: 75,
                    child: const Text("Dubem Ezeagwu You", softWrap: true,))
                ],
              ),)
            ],
          ),
          8.kH,
          const Text(
            "Add a collaborator",
            style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Expanded(
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
                  flex: 2,
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
