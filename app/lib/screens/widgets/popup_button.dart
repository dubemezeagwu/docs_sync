import 'package:docs_sync/screens/app_screens.dart';

class PopUpButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
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
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: width,
      height: height,
      child: IconButton(icon: icon,onPressed: onPressed, enableFeedback: true,),
    );
  }
}
