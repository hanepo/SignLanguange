// Basic Flutter widget test for SIGNLINK app

import 'package:flutter_test/flutter_test.dart';

import 'package:signlink_app/main.dart';

void main() {
  testWidgets('App launches with home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SignLinkApp());

    // Verify that the home screen has the app title
    expect(find.text('SIGNLINK'), findsOneWidget);

    // Verify that the two main buttons are present
    expect(find.text('Translate (BIM → Text)'), findsOneWidget);
    expect(find.text('Learn BIM'), findsOneWidget);
  });
}
