import 'package:docs_sync/repository/app_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';
import 'package:docs_sync/view_models/document_view_model.dart';
import 'package:floating_snackbar/floating_snackbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    // final documents = ref.watch(documentsFutureProvider);
    final documents = ref.watch(documentsNotifier);
    return Scaffold(
      appBar: MainAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            AppAssets.note,
            height: 10,
            width: 10,
          ),
        ),
        title: userData?.name.toString() ?? "USER",
        automaticallyImplyLeading: false,
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: kPrimary,
            child: ClipOval(
              child: Image.network(
                userData!.profilePicture,
                fit: BoxFit.cover,
              ),
            ),
          ),
          10.kW,
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: documents.when(
          data: ((documents) {
            if (documents != null && documents.isNotEmpty) {
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index];
                  return InkWell(
                    onTap: () => navigateToDocument(context, document.id),
                    child: DocumentListWidget(
                        title: document.title, subtitle: "Hello World"),
                  );
                },
              );
            } else {
              return const Text(AppStrings.noDocs);
            }
          }),
          error: ((error, stackTrace) {
            return const Center(
              child: Text(AppStrings.error),
            );
          }),
          loading: (() {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => createDocument(context, ref),
        backgroundColor: kPrimary,
        elevation: 3,
        child: const Icon(Icons.add),
      ),
    );
  }

  void signOut(WidgetRef ref) async {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final doc = await ref.read(documentsNotifier.notifier).createDocument();
    if (!context.mounted) return;
    FloatingSnackBar(
      message: "Document Created",
      backgroundColor: kPrimary,
      duration: const Duration(seconds: 1),
      textColor: kBlack,
      context: context);
    // scaffoldMessenger.showSnackBar(
    //   const SnackBar(
    //     content: Text("Document Created"),
    //     backgroundColor: kPrimary,
    //     margin: EdgeInsets.all(25),
    //     duration: Duration(seconds: 1),
    //   ),
    // );
    context.push("/document/${doc.id}");
  }

  void navigateToDocument(
    BuildContext context,
    String documentId,
  ) {
    context.push("/document/$documentId");
  }
}
