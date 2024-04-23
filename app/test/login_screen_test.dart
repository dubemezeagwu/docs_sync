import 'package:docs_sync/screens/app_screens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Login Screen has a 'Sign In with Google!' button",
      (WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(const ProviderScope(
        child: MaterialApp(
      home: LoginScreen(),
    )));

    // Allow all animations to complete
    await widgetTester.pumpAndSettle(const Duration(seconds: 1));

    // Find the ElevatedButton in the widget tree.
    final textFinder = widgetWithText<ElevatedButton>("Sign In with Google!");
    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(textFinder, findsOneWidget);
    expect(find.text("Sign In with Google!"), findsOneWidget);
  });
}

Finder widgetWithText<T>(String text) {
  return find.ancestor(
      of: find.text(text),
      matching: find.byWidgetPredicate((widget) => widget is T));
}
