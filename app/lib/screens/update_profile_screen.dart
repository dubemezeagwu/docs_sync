import 'package:docs_sync/screens/app_screens.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: "Update Profile",
      ),
      body: Center(child: Text("Data"),),
    );
  }
}
