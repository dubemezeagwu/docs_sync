import "package:docs_sync/repository/auth_repository.dart";
import "package:docs_sync/services/network_connection_checker.dart";
import "package:internet_connection_checker_plus/internet_connection_checker_plus.dart";
import 'package:overlay_support/overlay_support.dart';
import "screens/app_screens.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NetworkConnectionChecker().initialize();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserData(ref);
    });
  }

  void getUserData(WidgetRef ref) async {
    ref.read(appStatusProvider.notifier).update((state) => AppState.busy);
    final data = await ref.read(authRepositoryProvider).getUserData();
    if (data.data != null) {
      ref.read(userProvider.notifier).update((state) => data.data);
    }
    ref.read(appStatusProvider.notifier).update((state) => AppState.idle);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(AppNavigator.goRouterProvider);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AppLifeCycleManager(
        child: OverlaySupport.global(
          child: MaterialApp.router(
            title: 'Docs Sync',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: goRouter,
          ),
        ),
      ),
    );
  }
}
