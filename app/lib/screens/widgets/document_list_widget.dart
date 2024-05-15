import 'package:docs_sync/screens/app_screens.dart';
import 'package:flutter/cupertino.dart';

class DocumentListWidget extends StatelessWidget {
  // final int widgetKey;
  final String title;
  final String subtitle;
  final bool? isPublic;
  final void Function(DismissDirection)? onSlide;
  const DocumentListWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      // required this.widgetKey,
      this.isPublic = false,
      required this.onSlide});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // key: ValueKey<int>(widgetKey),
      key: key!,
      onDismissed: onSlide,
      child: ShadowCard(
        contentPadding: 0,
        child: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: isPublic == false
              ? const Icon(Icons.lock)
              : const Icon(CupertinoIcons.globe),
        ),
      ),
    );
  }
}
