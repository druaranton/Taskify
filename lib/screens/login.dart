import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/auth_provider.dart';
import '/screens/signup.dart';
import 'package:page_transition/page_transition.dart';
import 'package:alert_dialog/alert_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _logInFormKey = GlobalKey<FormState>();
  Map<String, dynamic> formValues = {
    'email': "",
    'password': "",
  };
  @override
  Widget build(BuildContext context) {
    //username
    final email = TextFormField(
      key: const Key("email"),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value) ==
                false) {
          //if the email doesn't follow the correct format
          return 'Email must be a valid email address';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Email",
      ),
      onChanged: ((String? value) {
        formValues['email'] = value;
      }),
    );

    //password
    final password = TextFormField(
      key: const Key("pwField"),
      obscureText: true, //so that passwords would not be exposed
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            RegExp("^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@\$%^&*-]).{8,}")
                    .hasMatch(value) ==
                false) {
          //if the length of password is weak/length is les than six
          return 'Password must be at least 8 characters long with at least a number, a special \ncharacter, and both uppercase and lowercase letters';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Password",
      ),
      onChanged: ((String? value) {
        formValues['password'] = value; //store in the map
      }),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        key: const Key('loginButton'),
        onPressed: () {
          //validates the form first
          if (_logInFormKey.currentState!.validate()) {
            _logInFormKey.currentState?.save();
            context
                .read<AuthProvider>()
                .signIn(formValues['email'], formValues['password'])
                .then((value) {
              if (value == 'No user found for that email' ||
                  value == 'Wrong password provided for that user.') {
                alert(context, title: Text(value));
              }
            });
          }
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final logoutButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        key: const Key("signUpButton"),
        onPressed: () {
          Navigator.of(context).push(PageTransition(
              opaque: true,
              type: PageTransitionType.fade,
              child: const SignupPage()));
        },
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 197, 171),
      body: Center(
        child: Form(
            key: _logInFormKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              children: <Widget>[
                const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                email,
                password,
                loginButton,
                logoutButton,
              ],
            )),
      ),
    );
  }
}
