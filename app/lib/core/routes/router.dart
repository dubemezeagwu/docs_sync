import 'package:docs_sync/repository/app_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';
import 'package:docs_sync/screens/update_profile_screen.dart';

class AppNavigator {
  AppNavigator._();

  // Go Router Configuration
  static final goRouterProvider = Provider<GoRouter>((ref) {
    final appStatus = ref.watch(appStatusProvider);
    final isAuthenticated = ref.watch(userProvider);
    return GoRouter(
      initialLocation: (appStatus == AppState.busy)
          ? "/splash"
          : (isAuthenticated == null)
              ? "/"
              : "/home",
      routes: <GoRoute>[
        GoRoute(
          path: "/",
          name: AppRoutes.login,
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: "/home",
          name: AppRoutes.home,
          builder: (context, state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: "/document/:id",
          name: AppRoutes.document,
          builder: ((context, state) {
            final id = state.pathParameters["id"];
            return DocumentScreen(id: id!);
          }),
        ),
        GoRoute(
          path: "/splash",
          name: AppRoutes.splash,
          builder: (context, state) {
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: "/updateProfile",
          name: AppRoutes.updateProfile,
          builder: (context, state) {
            return const UpdateProfileScreen();
          },
        ),
      ],
    );
  });
}
