import 'package:docs_sync/screens/app_screens.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          AppAssets.noteEdit,
          width: 80,
          height: 80,
        ),
      ),
    );
  }
}
