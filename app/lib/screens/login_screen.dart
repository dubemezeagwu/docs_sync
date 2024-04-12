import 'package:docs_sync/core/app_core.dart';
import 'package:docs_sync/repository/auth_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref,context),
          icon: SvgPicture.asset(
            "svg/google.svg",
            height: 20,
            width: 20,
          ),
          label: const Text("Sign In with Google!"),
          style: ElevatedButton.styleFrom(
              backgroundColor: kWhite, minimumSize: const Size(150, 50)),
        ),
      ),
    );
  }

  // TODO: Fix navigation bug. Not navigating to next screen after signup
  
  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final data = await ref.read(authRepositoryProvider).signInWithGoogle();
    if (data.errorMessage == null) {
      ref.read(userProvider.notifier).update((state) => data.data);
      navigator.push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text(data.errorMessage!)));
    }
  }
}
