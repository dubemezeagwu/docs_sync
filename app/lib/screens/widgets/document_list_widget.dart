import 'package:docs_sync/screens/app_screens.dart';
import 'package:flutter/cupertino.dart';

class DocumentListWidget extends StatelessWidget {
  // final int widgetKey;
  final String title;
  final String subtitle;
  final bool? isPublic;
  final String? created;
  final void Function(DismissDirection)? onSlide;
  const DocumentListWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      this.created,
      this.isPublic,
      required this.onSlide});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      onDismissed: onSlide,
      direction: DismissDirection.endToStart,
      background: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          color: kAlert,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Delete",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      child: ShadowCard(
        contentPadding: 0,
        child: ListTile(
          title: Text(title),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subtitle),
              Text(created ?? "A few seconds ago"),
            ],
          ),
          trailing: isPublic == false
              ? SvgPicture.asset(
                  AppAssets.lock,
                  height: 25,
                  width: 25,
                  color: kDarkGrey,
                )
              : SvgPicture.asset(
                  AppAssets.globe,
                  height: 25,
                  width: 25,
                  color: kDarkGrey,
                ),
        ),
      ),
    );
  }
}
