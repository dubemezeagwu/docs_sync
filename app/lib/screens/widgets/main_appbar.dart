import 'package:docs_sync/screens/app_screens.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String title;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const MainAppBar(
      {super.key,
      required this.title,
      this.leading,
      this.bottom,
      required this.automaticallyImplyLeading,
      this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      bottom: bottom,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: false,
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 28, maxWidth: 300),
        child: Text(
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600
          ),
          title,
        ),
      ),
      actions: actions,
    );
  }
}
