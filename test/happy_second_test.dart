import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_aranton/main.dart' as app;

void main() {
// Define a test
  testWidgets('Second Happy Test', (tester) async {
// Create the widget by telling the tester to build it along with the provider the widget requires
    app.main(); //it will lead to the log in page
    final userNameField = find.byKey(const Key("email")); //email field
    final passwordField = find.byKey(const Key("pwField")); //password field
    final loginButton = find.byKey(const Key("loginButton")); //log in button

    await tester.enterText(
        userNameField, 'druaranton123@gmail.com'); //enter email
    await tester.enterText(passwordField, 'Qwerty1!'); //enter password

    final homePageBar =
        find.byKey(const Key('appbar')); //appbar of the homepage
    await tester.tap(loginButton); //tap the log in button
    await tester.pumpAndSettle(); //wait for change screen
    expect(homePageBar, findsOneWidget); //find the addtodo icon/button
  });
}
