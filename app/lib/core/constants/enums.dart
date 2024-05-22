import 'package:docs_sync/screens/app_screens.dart';

enum AppState { idle, busy }

enum CollaboratorType {
  viewer("viewer", Icon(Icons.visibility)),
  editor("editor", Icon(Icons.edit));

  final String title;
  final Icon icon;

  const CollaboratorType(this.title, this.icon);
}
