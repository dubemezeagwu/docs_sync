import "package:docs_sync/repository/auth_repository.dart";
import "app_screens.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text(ref.watch(userProvider)?.email.toString() ?? "Docs Sync"),
      ),
    );
  }
}
