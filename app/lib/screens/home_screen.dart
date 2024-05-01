import "package:docs_sync/repository/auth_repository.dart";
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
            height: 5,
            width: 5,
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
            IconButton(onPressed: (){}, icon: const Icon(Icons.add)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.logout))
          ],
          ),
      body: Center(
        child: Text(userData?.email.toString() ?? "Docs Sync"),
      ),
    );
  }
}
