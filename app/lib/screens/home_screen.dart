import 'package:docs_sync/repository/app_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';
import 'package:docs_sync/screens/widgets/popup_button.dart';
import 'package:docs_sync/services/network_connection_checker.dart';
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
  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
    final timeOfDay = DateTime.now().timeOfDay;
    final isConnected = ref.watch(internetStatusProvider).value ?? false;
    return Scaffold(
      key: _key,
      appBar: MainAppBar(
        title: "Good $timeOfDay!",
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _key.currentState?.openEndDrawer();
                },
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
                    // color: Colors.green
                    color: isConnected ? Colors.green : Colors.red,
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
                      final document = documents.reversed.toList()[index];
                      return InkWell(
                        onTap: () => navigateToDocument(context, document.id),
                        child: DocumentListWidget(
                          title: document.title,
                          key: ValueKey<int>(index),
                          // subtitle: (document.content[0]["insert"]
                          //             .toString()
                          //             .length >= 3
                          //         )
                          //     ? "${document.content[0]["insert"].toString().substring(0, 10)}..."
                          //     : "No Content",
                          subtitle: "Tap to View!",
                          isPublic: document.isPublic,
                          created: document.createdAt.timeAgo,
                          onSlide: (_) =>
                              deleteDocument(document.id, ref, context),
                        ),
                      );
                    },
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: SvgPicture.asset(AppAssets.noteEdit),
                      ),
                      14.kH,
                      const Text(AppStrings.noDocs)
                    ],
                  );
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
                      icon: SvgPicture.asset(
                        AppAssets.lock,
                        height: 25,
                        width: 25,
                        color: kWhite,
                      ),
                      onPressed: () {
                        animationController.reverse();
                        return createDocument(context, ref, false);
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
                      icon: SvgPicture.asset(
                        AppAssets.globe,
                        height: 25,
                        width: 25,
                        color: kWhite,
                      ),
                      onPressed: () {
                        animationController.reverse();
                        return createDocument(context, ref, true);
                      },
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
                      color: kPrimary.withOpacity(0.9),
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
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userData.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: kGreyBlack),
              ),
              accountEmail: Text(
                userData.email,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: kGreyBlack),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 40,
                child: ClipOval(
                  child: Image.network(
                    userData!.profilePicture,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: const BoxDecoration(color: kPrimary),
            ),
            ListTile(
              leading: SvgPicture.asset(
                AppAssets.profile,
                height: 25,
                width: 25,
                color: kDarkGrey,
              ),
              title: const Text("Update Profile"),
              onTap: () {},
            ),
            ListTile(
              leading: SvgPicture.asset(
                AppAssets.document,
                height: 25,
                width: 25,
                color: kDarkGrey,
              ),
              title: const Text('My Documents'),
              onTap: () {},
            ),
            AboutListTile(
              icon: SvgPicture.asset(
                AppAssets.info,
                height: 25,
                width: 25,
                color: kDarkGrey,
              ),
              applicationIcon: SvgPicture.asset(
                AppAssets.noteEdit,
                width: 50,
                height: 50,

              ),
              applicationName: 'Docs Sync',
              applicationVersion: 'v1.0.0',
              applicationLegalese: '© 2024 Company',
              aboutBoxChildren: const [Text("Built by Dubem Ezeagwu with 🖤")],
              child: const Text('About app'),
            ),
            const Spacer(),
            ListTile(
              leading: SvgPicture.asset(
                AppAssets.logout,
                height: 25,
                width: 25,
                color: kAlert,
              ),
              title: const Text('Sign Out'),
              iconColor: kAlert,
              textColor: kAlert,
              onTap: () {
                signOut(ref);
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                AppAssets.delete,
                height: 25,
                width: 25,
                color: kAlert,
              ),
              iconColor: kAlert,
              textColor: kAlert,
              title: const Text('Delete Account'),
              onTap: () {
                context.pop();
              },
            ),
            16.kH
          ],
        ),
      ),
    );
  }

  void signOut(WidgetRef ref) async {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(
      BuildContext context, WidgetRef ref, bool isPublic) async {
    final doc =
        await ref.read(documentsNotifier.notifier).createDocument(isPublic);
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
    if (!context.mounted) return;
    FloatingSnackBar(
        message: AppStrings.documentDeleted,
        backgroundColor: kPrimary,
        duration: const Duration(seconds: 1),
        textColor: kBlack,
        context: context);
  }
}
