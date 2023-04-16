import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_aranton/main.dart' as app;

void main() {
// Define a test
  testWidgets('First Unhappy Test', (tester) async {
// Create the widget by telling the tester to build it along with the provider the widget requires
    app.main();
    final signUpButton =
        find.byKey(const Key("signUpButton")); //sign up button of log in page
    expect(signUpButton, findsOneWidget); //find widget
    await tester.tap(signUpButton); //tap the sign up
    await tester.pumpAndSettle(); //wait for change screen

    final secondSignUpButton = find
        .byKey(const Key("finalSignUp")); //sign up button of the sign up page
    expect(secondSignUpButton, findsOneWidget); //find widget

    await tester.enterText(
        find.byKey(const Key('lName')), 'Aranton'); //enter lastname
    await tester.enterText(find.byKey(const Key('semail')),
        'andruaranton@gmail.com'); //enter email
    await tester.enterText(
        find.byKey(const Key('password')), 'Qwerty1!'); //enter password

    final fNameErrorFinder = find.text('First Name is required'); //error text
    final birthdateErrorFinder = find.text('Enter a valid birthdate');
    final locErrorFinder = find.text('Location is required');
    final unameErrorFinder = find.text('Username is required');

    await tester.tap(secondSignUpButton); //tap the sign up button
    await tester.pumpAndSettle(); //wait
    expect(fNameErrorFinder, findsOneWidget); //find the error text
    expect(birthdateErrorFinder, findsOneWidget); //find the error text
    expect(locErrorFinder, findsOneWidget); //find the error text
    expect(unameErrorFinder, findsOneWidget); //find the error text
  });
}
