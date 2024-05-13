import 'package:docs_sync/repository/app_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';
import 'package:docs_sync/screens/widgets/popup_button.dart';
import 'package:docs_sync/view_models/document_view_model.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation degOneTranslationAnimation;
  late Animation rotationAnimation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    degOneTranslationAnimation =
        Tween(begin: 0.0, end: 1.0).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

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
      body: Stack(children: [
        Center(
          child: documents.when(
            data: ((documents) {
              if (documents != null && documents.isNotEmpty) {
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    return InkWell(
                      onLongPress: () =>
                          deleteDocument(document.id, ref, context),
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
        Positioned(
          right: 30,
          bottom: 30,
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset.fromDirection(
                    195.0.rad, degOneTranslationAnimation.value * 100),
                child: Transform(
                  transform:
                      Matrix4.rotationZ((rotationAnimation.value as double).rad)
                        ..scale(degOneTranslationAnimation.value),
                  alignment: Alignment.center,
                  child: InkWell(
                    // onTap: () => createDocument(context, ref),
                    child: PopUpButton(
                      width: 50,
                      height: 50,
                      color: kDarkGrey,
                      icon: const Icon(
                        Icons.lock,
                        color: kWhite,
                      ),
                      onPressed: () {
                        print("Button tapped!");
                        // return createDocument(context, ref);
                      },
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset.fromDirection(
                    255.0.rad, degOneTranslationAnimation.value * 100),
                child: Transform(
                  transform:
                      Matrix4.rotationZ((rotationAnimation.value as double).rad)
                        ..scale(degOneTranslationAnimation.value),
                  alignment: Alignment.center,
                  child: PopUpButton(
                      width: 50,
                      height: 50,
                      color: kDarkGrey,
                      icon: const Icon(
                        CupertinoIcons.globe,
                        color: kWhite,
                      ),
                      onPressed: () {}),
                ),
              ),
              Transform(
                transform:
                    Matrix4.rotationZ((rotationAnimation.value as double).rad),
                alignment: Alignment.center,
                child: PopUpButton(
                    width: 50,
                    height: 50,
                    color: kPrimary,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (animationController.isCompleted) {
                        animationController.reverse();
                      } else {
                        animationController.forward();
                      }
                    }),
              )
            ],
          ),
        )
      ]),
      // floatingActionButton: FloatingActionButton.small(
      //   onPressed: () => createDocument(context, ref),
      //   backgroundColor: kPrimary,
      //   elevation: 3,
      //   child: const Icon(Icons.add),
      // ),
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
        message: AppStrings.documentCreated,
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

  void deleteDocument(String docId, WidgetRef ref, BuildContext context) async {
    await ref.read(documentsNotifier.notifier).deleteDocument(docId);
    FloatingSnackBar(
        message: AppStrings.documentDeleted,
        backgroundColor: kPrimary,
        duration: const Duration(seconds: 1),
        textColor: kBlack,
        context: context);
  }
}
