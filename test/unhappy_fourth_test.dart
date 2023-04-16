import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_aranton/main.dart' as app;

void main() {
// Define a test
  testWidgets('Fourth Unhappy Test', (tester) async {
    app.main();
    final userNameField = find.byKey(const Key("email")); //email field
    final passwordField = find.byKey(const Key("pwField")); //password field
    final loginButton = find.byKey(const Key("loginButton")); //login button

    await tester.enterText(
        userNameField, 'andreauaranton'); //enter invalid email
    await tester.enterText(passwordField, 'cmsc23123A!'); //enter password

    await tester.tap(loginButton); //tap the log in button
    await tester.pumpAndSettle(); //wait

    final emailErrorFinder =
        find.text('Email must be a valid email address'); //error text to find
    expect(emailErrorFinder, findsOneWidget); //find the error message
  });
}
