import 'package:docs_sync/screens/app_screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DocumentListWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool? isPublic;
  final void Function(BuildContext)? onSlide;
  const DocumentListWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      this.isPublic = false, required this.onSlide});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: onSlide,
            backgroundColor: kPrimary,
            foregroundColor: kBlack,
            icon: Icons.star,
            label: 'Delete',
          ),
        ],
      ),
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
