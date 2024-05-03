import "package:docs_sync/core/routes/app_routes.dart";
import "package:docs_sync/repository/auth_repository.dart";
import "package:docs_sync/repository/document_repository.dart";
import "package:docs_sync/repository/local_storage_repository.dart";
import "package:go_router/go_router.dart";
import "app_screens.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider);
    return Scaffold(
      appBar: MainAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            "assets/svg/note.svg",
            height: 10,
            width: 10,
          ),
        ),
        title: userData?.name.toString() ?? "USER",
        automaticallyImplyLeading: false,
        actions: [
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color.fromARGB(255, 231, 176, 194),
            child: Image.network(userData!.profilePicture),
          ),
          IconButton(
              onPressed: () => createDocument(context, ref),
              icon: const Icon(Icons.add)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text(userData?.email.toString() ?? "Docs Sync"),
      ),
    );
  }

  void signOut(WidgetRef ref) async {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String? token = await ref.read(localStorageProvider).getToken();

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final doc =
        await ref.read(documentRepositoryProvider).createDocument(token ?? "");
    if (doc.data != null) {
      if (!context.mounted) return;
      context.push("/document/${doc.data?.id}");
    } else {
      scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(doc.errorMessage ?? "Unexpected Error")));
    }
  }
}
