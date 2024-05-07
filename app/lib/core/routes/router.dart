import 'package:docs_sync/core/routes/app_routes.dart';
import 'package:docs_sync/core/routes/navigator_observer.dart';
import 'package:docs_sync/repository/auth_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';
import 'package:docs_sync/screens/widgets/loading_screen.dart';
import 'package:go_router/go_router.dart';

class AppNavigator {
  AppNavigator._();

  // Go Router Configuration
  static final goRouterProvider = Provider<GoRouter>((ref) {
    final appStatus = ref.watch(appStatusProvider);
    final isAuthenticated = ref.watch(userProvider);
    return GoRouter(
      observers: [CustomNavigatorObserver(ref: ref)],
      initialLocation: (appStatus == true)
          ? "/loading"
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
          path: "/loading",
          name: AppRoutes.loading,
          builder: (context, state) {
            return const LoadingScreen();
          },
        ),
      ],
    );
  });
}
