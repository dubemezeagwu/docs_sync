import 'package:docs_sync/repository/app_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          // onPressed: () => context.goNamed(AppRoutes.home),
          onPressed: () => signInWithGoogle(ref, context),
          icon: SvgPicture.asset(
            AppAssets.google,
            height: 20,
            width: 20,
          ),
          label: Text(AppStrings.signInWithGoogle),
          style: ElevatedButton.styleFrom(
              backgroundColor: kWhite, minimumSize: const Size(150, 50)),
        ),
      ),
    );
  }

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final data = await ref.read(authRepositoryProvider).signInWithGoogle();
    if (data.errorMessage == null) {
      ref
          .read(userProvider.notifier)
          .update((state) => data.data);
      if (!context.mounted) return;
      context.goNamed(AppRoutes.home);
    } else {
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text(data.errorMessage!)));
    }
  }
}
