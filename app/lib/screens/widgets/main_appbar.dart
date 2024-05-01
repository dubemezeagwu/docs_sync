import 'package:docs_sync/screens/app_screens.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;
  final String title;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  PreferredSizeWidget? bottom;

  MainAppBar(
      {super.key,
      required this.title,
      required this.leading,
      required this.automaticallyImplyLeading,
      this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      bottom: bottom,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: true,
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 28, maxWidth: 300),
        child: Text(
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400
          ),
          title,
        ),
      ),
      actions: actions,
    );
  }
}
