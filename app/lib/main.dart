import "package:docs_sync/core/utils/app_life_cycle_manager.dart";

import "screens/app_screens.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( 
    const ProviderScope(
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppLifeCycleManager(
      child: MaterialApp(
          title: 'Docs Sync',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const LoginScreen()),
    );
  }
}
