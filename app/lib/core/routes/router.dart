import 'package:docs_sync/core/routes/app_routes.dart';
import 'package:docs_sync/repository/auth_repository.dart';
import 'package:docs_sync/screens/app_screens.dart';
import 'package:go_router/go_router.dart';

class AppNavigator {
  AppNavigator._();

  // Go Router Configuration
  static final goRouterProvider = Provider<GoRouter>((ref) {
    return GoRouter(
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
        ],
        redirect: (context, state) {
          final isAuthenticated = ref.read(userProvider);
          return (isAuthenticated == null) ? "/" : "/home";
        });
  });
}
