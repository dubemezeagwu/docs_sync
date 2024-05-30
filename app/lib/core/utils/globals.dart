import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';

Font? globalFont;

void loadGlobalFont() async {
  final font = await rootBundle.load("assets/fonts/open-sans.ttf");
  globalFont = Font.ttf(font);
}