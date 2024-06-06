import 'package:docs_sync/screens/app_screens.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

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
