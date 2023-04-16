import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_aranton/main.dart' as app;

void main() {
// Define a test
  testWidgets('Third Happy Test', (tester) async {
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
        find.byKey(const Key('fName')), 'Andreau'); //enter first name
    await tester.enterText(
        find.byKey(const Key('lName')), 'Aranton'); //enter lastname
    await tester.enterText(
        find.byKey(const Key('bdate')), '2001-11-30'); //enter bdate
    await tester.enterText(
        find.byKey(const Key('location')), 'Pila'); //enter location
    await tester.enterText(find.byKey(const Key('semail')),
        'andruaranton@gmail.com'); //enter email
    await tester.enterText(
        find.byKey(const Key('username')), 'xdrux'); //enter email
    await tester.enterText(
        find.byKey(const Key('password')), 'cmsc23123A!'); //enter password

    final homePageBar =
        find.byKey(const Key('appbar')); //appbar of the homepage
    await tester.tap(secondSignUpButton); //tap the sign up button
    await tester.pumpAndSettle(); //wait
    expect(homePageBar, findsOneWidget); //find te appbar
  });
}
