import 'package:docs_sync/screens/app_screens.dart';

class PopUpButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget icon;
  final VoidCallback onPressed;

  const PopUpButton(
      {super.key,
      required this.width,
      required this.height,
      required this.color,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      // borderRadius: BorderRadius.circular(26),
      shape: const CircleBorder(
        side: BorderSide(color: kBlack),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        width: width,
        height: height,
        child: IconButton(
          icon: icon,
          onPressed: onPressed,
          enableFeedback: true,
        ),
      ),
    );
  }
}
