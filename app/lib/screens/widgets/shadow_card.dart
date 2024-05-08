import 'package:docs_sync/screens/app_screens.dart';

class ShadowCard extends StatefulWidget {
  final Widget child;
  final Border? borderStyle;
  final Color? boxShadowColor;
  final Color? boxMainColor;
  final double? contentPadding;

  const ShadowCard(
      {super.key,
      required this.child,
      this.boxShadowColor,
      this.borderStyle,
      this.boxMainColor, 
      this.contentPadding = 20.0});

  @override
  _ShadowCardState createState() => _ShadowCardState();
}

class _ShadowCardState extends State<ShadowCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 5,
          margin: const EdgeInsets.all(20.0),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(widget.contentPadding!),
            decoration: BoxDecoration(
                color: kPrimary,
                border: widget.borderStyle ??
                    Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: widget.boxShadowColor ?? Colors.black,
                      offset: const Offset(10.0, 10.0))
                ]),
            child: widget.child,
          ),
        )
      ],
    );
  }
}