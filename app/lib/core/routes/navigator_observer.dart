import 'package:docs_sync/core/routes/app_routes.dart';
import 'package:docs_sync/screens/app_screens.dart';
import 'package:docs_sync/repository/app_repository.dart';


class CustomNavigatorObserver extends NavigatorObserver {
  final ProviderRef ref;

  CustomNavigatorObserver({required this.ref});

  @override
  void didPop(Route route, Route? previousRoute) async{
    super.didPop(route, previousRoute);
    print('GoRouterObserver didPop: $route');
    // Check if the popped route was the document editing screen
    if (route.settings.name == AppRoutes.document) {
      // Call getUserDocuments() when the document editing screen is popped
        String? token = await ref.read(localStorageProvider).getToken();
        ref.read(documentRepositoryProvider).getUserDocuments(token ?? "");
    }
  }
}
