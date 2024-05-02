import 'package:docs_sync/core/app_core.dart';
import 'package:docs_sync/screens/app_screens.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: kBlack,
        ),
      ),
    );
  }
}