import 'package:docs_sync/repository/app_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    final documents = ref.watch(documentsFutureProvider);
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
              child: Image.network(userData!.profilePicture, fit: BoxFit.cover,),
              ),
          ),
          10.kW,
          IconButton(
              onPressed: () => signOut(ref), icon: const Icon(Icons.logout))
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
              return Text(AppStrings.noDocs);
            }
          }),
          error: ((error, stackTrace) {
            return Center(child: Text(AppStrings.error));
          }),
          loading: (() {
            return const Expanded(
              child: Center(child: CircularProgressIndicator()),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => createDocument(context, ref),
        backgroundColor: kPrimary,
        elevation: 3,
        child: const Icon(Icons.add),),
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
