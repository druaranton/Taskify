import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_aranton/main.dart' as app;

void main() {
// Define a test
  testWidgets('First Happy Test', (tester) async {
// Create the widget by telling the tester to build it along with the provider the widget requires
    app.main();
    final signUpButton =
        find.byKey(const Key("signUpButton")); //sign up button of log in page
    expect(signUpButton, findsOneWidget); //find widget
    await tester.tap(signUpButton); //tap the sign up
    await tester.pumpAndSettle(); //wait for change screen

    final backButton =
        find.byKey(const Key("back")); //back button of the sign up page
    expect(backButton, findsOneWidget); //find widget

    await tester.tap(backButton); //tap the back button
    await tester.pumpAndSettle(); //wait

    expect(signUpButton, findsOneWidget); //find widget
  });
}
