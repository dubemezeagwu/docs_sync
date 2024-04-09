import 'package:docs_sync/core/app_core.dart';
import 'package:docs_sync/screens/app_screens.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: (){}, 
          icon: SvgPicture.asset("svg/google.svg", height: 20, width: 20,), 
          label: Text("Sign In with Google!"),
          style: ElevatedButton.styleFrom(
            backgroundColor: kWhite,
            minimumSize: const Size(150, 50)
          ),
          ),
      ),
    );
  }
}