import 'package:docs_sync/repository/app_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with RouteAware {
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final documents = ref.watch(documentsFutureProvider);
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
        child: documents.when(
          data: ((documents) {
            if (documents.data != null && documents.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: documents.data!.length,
                itemBuilder: (context, index) {
                  final document = documents.data?[index];
                  return InkWell(
                    onTap: () =>
                        navigateToDocument(context, document?.id ?? "0"),
                    child: DocumentListWidget(
                        title: document?.title ?? "Document One",
                        subtitle: "Hello World"),
                  );
                },
              );
            } else {
              return const Text("No documents available");
            }
          }),
          error: ((error, stackTrace) {
            return const Center(child: Text("Error Occurred!"));
          }),
          loading: (() {
            return const Expanded(
              child: Center(child: CircularProgressIndicator()),
            );
          }),
        ),
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

  void navigateToDocument(
    BuildContext context,
    String documentId,
  ) {
    context.push("/document/$documentId");
  }
}
