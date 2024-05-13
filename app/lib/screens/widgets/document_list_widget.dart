import 'package:docs_sync/screens/app_screens.dart';
import 'package:flutter/cupertino.dart';

class DocumentListWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool? isPublic;
  const DocumentListWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      this.isPublic = false});

  @override
  Widget build(BuildContext context) {
    return ShadowCard(
      contentPadding: 0,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: isPublic == false
            ? const Icon(Icons.lock)
            : const Icon(CupertinoIcons.globe),
      ),
    );
  }
}
