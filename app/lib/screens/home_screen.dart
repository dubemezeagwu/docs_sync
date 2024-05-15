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
    final documents = ref.watch(documentsNotifier);
    return Scaffold(
      appBar: MainAppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            AppAssets.note,
            height: 15,
            width: 15,
          ),
        ),
        title: userData?.name.toString() ?? "USER",
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => signOut(ref),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: kPrimary,
                  child: ClipOval(
                    child: Image.network(
                      userData!.profilePicture,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kBlack, width: 1),
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          20.kW,
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: documents.when(
              data: ((documents) {
                if (documents != null && documents.isNotEmpty) {
                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      return DocumentListWidget(
                        title: document.title,
                        // widgetKey: index,
                        key: ValueKey<int>(index),
                        // subtitle: (document.content[0]["insert"]
                        //             .toString()
                        //             .length >= 3
                        //         )
                        //     ? "${document.content[0]["insert"].toString().substring(0, 10)}..."
                        //     : "No Content",
                        subtitle: "Tap to View!",
                        onSlide: (_) =>
                            deleteDocument(document.id, ref, context),
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
            height: 200,
            width: 200,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Transform.translate(
                  offset: Offset.fromDirection(
                      195.0.rad, degOneTranslationAnimation.value * 100),
                  child: Transform(
                    transform: Matrix4.rotationZ(
                        (rotationAnimation.value as double).rad)
                      ..scale(degOneTranslationAnimation.value),
                    alignment: Alignment.center,
                    child: PopUpButton(
                      width: 50,
                      height: 50,
                      color: kDarkGrey,
                      icon: const Icon(
                        Icons.lock,
                        color: kWhite,
                      ),
                      onPressed: () {
                        animationController.reverse();
                        return createDocument(context, ref);
                      },
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset.fromDirection(
                      255.0.rad, degOneTranslationAnimation.value * 100),
                  child: Transform(
                    transform: Matrix4.rotationZ(
                        (rotationAnimation.value as double).rad)
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
                      onPressed: () {},
                    ),
                  ),
                ),
                Transform(
                  transform: Matrix4.rotationZ(
                      (rotationAnimation.value as double).rad),
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
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void signOut(WidgetRef ref) async {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    final doc = await ref.read(documentsNotifier.notifier).createDocument();
    if (!context.mounted) return;
    FloatingSnackBar(
        message: AppStrings.documentCreated,
        backgroundColor: kPrimary,
        duration: const Duration(seconds: 1),
        textColor: kBlack,
        context: context);
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
