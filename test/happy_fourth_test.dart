import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_aranton/main.dart' as app;

void main() {
// Define a test
  testWidgets('Fourth Happy Test', (tester) async {
// Create the widget by telling the tester to build it along with the provider the widget requires
    app.main(); //it will lead to the log in page
    final userNameField = find.byKey(const Key("email")); //email field
    final passwordField = find.byKey(const Key("pwField")); //password field
    final loginButton = find.byKey(const Key("loginButton")); //log in button
    final signUpButton =
        find.byKey(const Key("signUpButton")); //sign up button of log in page

    expect(userNameField, findsOneWidget); //find the field
    expect(passwordField, findsOneWidget); //find the field
    expect(loginButton, findsOneWidget); //find the button
    expect(signUpButton, findsOneWidget); //find widget
  });
}
