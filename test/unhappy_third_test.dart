import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_aranton/main.dart' as app;

void main() {
// Define a test
  testWidgets('Third Unhappy Test', (tester) async {
    app.main();
    final userNameField = find.byKey(const Key("email")); //email field
    final passwordField = find.byKey(const Key("pwField")); //password field
    final loginButton = find.byKey(const Key("loginButton")); //login button

    await tester.enterText(
        userNameField, 'andreauaranton@gmail.com'); //enter invalid email
    await tester.enterText(passwordField, 'cmsc23123'); //enter password

    await tester.tap(loginButton); //tap the log in button
    await tester.pumpAndSettle(); //wait

    final passErrorFinder = find.text(
        'Password must be at least 8 characters long with at least a number, a special \ncharacter, and both uppercase and lowercase letters'); //error text to find
    expect(passErrorFinder, findsOneWidget);
  });
}
