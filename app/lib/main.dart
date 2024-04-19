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
    return MaterialApp(
        title: 'Docs Sync',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen());
  }
}
