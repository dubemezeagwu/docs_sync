import "package:docs_sync/core/constants/color_constants.dart";
import "package:docs_sync/core/routes/router.dart";
import "package:docs_sync/core/utils/app_life_cycle_manager.dart";
import "package:docs_sync/domain/user_state.dart";
import "package:docs_sync/repository/auth_repository.dart";

import "screens/app_screens.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
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
    ref.read(appStatusProvider.notifier).update((state) => true);
    final data = await ref.read(authRepositoryProvider).getUserData();
    if (data.data != null) {
      ref.read(userProvider.notifier).update((state) => data.data);
    }
    ref.read(appStatusProvider.notifier).update((state) => false);

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(AppNavigator.goRouterProvider);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AppLifeCycleManager(
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
    );
  }
}
