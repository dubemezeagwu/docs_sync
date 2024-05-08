import 'package:docs_sync/screens/app_screens.dart';


class DocumentListWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const DocumentListWidget(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ShadowCard(
      contentPadding: 0,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
