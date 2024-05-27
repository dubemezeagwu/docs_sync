import 'package:docs_sync/screens/app_screens.dart';
import 'package:docs_sync/screens/widgets/popup_button.dart';
import 'package:flutter/material.dart';

class BottomSheetOptionsWidget extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final String title;

  const BottomSheetOptionsWidget(
      {super.key, required this.icon, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PopUpButton(
              width: 50,
              height: 50,
              color: kPrimary,
              icon: icon,
              onPressed: onPressed),
              8.kH,
          Text(title, overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }
}
