import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_aranton/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:alert_dialog/alert_dialog.dart';

//https://www.w3resource.com/javascript/form/email-validation.php#:~:text=To%20get%20a%20valid%20email,%5D%2B)*%24%2F.

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _signUpFormKey = GlobalKey<FormState>(); //key of the signup form
  final TextEditingController _date = TextEditingController();
  //map to know the inputs of the user
  Map<String, dynamic> formValues = {
    'fname': "",
    'lname': "",
    'birthdate': "",
    'location': "",
    'email': "",
    'username': "",
    'password': ""
  };

  @override
  Widget build(BuildContext context) {
    //Name
    final fname = TextFormField(
      key: const Key("fName"),
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().isEmpty) {
          //if there is no first name given, display a prompt
          return 'First Name is required';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "First Name",
      ),
      onChanged: ((String? value) {
        formValues['fname'] = value; //store in the map
      }),
    );

    final lname = TextFormField(
      key: const Key("lName"),
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().isEmpty) {
          //if there is no last name given, display a prompt
          return 'Last Name is required';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Last Name",
      ),
      onChanged: ((String? value) {
        formValues['lname'] = value; //store in the map
      }),
    );

    final location = TextFormField(
      key: const Key("location"),
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().isEmpty) {
          //if there is no last name given, display a prompt
          return 'Location is required';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Location",
      ),
      onChanged: ((String? value) {
        formValues['location'] = value; //store in the map
      }),
    );

    final email = TextFormField(
      key: const Key("semail"),
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
    //username
    final username = TextFormField(
      key: const Key("username"),
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().isEmpty) {
          //if there is no last name given, display a prompt
          return 'Username is required';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Username",
      ),
      onChanged: ((String? value) {
        formValues['username'] = value; //store in the map
      }),
    );

    //password
    final password = TextFormField(
      key: const Key("password"),
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

    final birthdate = TextFormField(
      key: const Key("bdate"),
      controller: _date,
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            value.trim().isEmpty ||
            RegExp("^[0-9]{4}-((0[0-9])|(1[0-2]))-((0[1-9])|(1[0-9])|(2[0-9])|(3[0-1]))\$")
                    .hasMatch(value) ==
                false) {
          return 'Enter a valid birthdate';
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Birthdate",
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now());
        if (pickedDate != null) {
          setState(() {
            _date.text = DateFormat('yyyy-MM-dd').format(pickedDate);
            formValues['birthdate'] =
                DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
    );

    final SignupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        key: const Key("finalSignUp"),
        onPressed: () async {
          //validates the form first
          if (_signUpFormKey.currentState!.validate()) {
            _signUpFormKey.currentState?.save();
            context
                .read<AuthProvider>()
                .signUp(
                    formValues['fname'],
                    formValues['lname'],
                    formValues['birthdate'],
                    formValues['location'],
                    formValues['email'],
                    formValues['username'],
                    formValues['password'])
                .then((value) {
              if (value == 'The account already exists for that username.') {
                alert(context, title: Text(value));
              } else {
                Navigator.pop(context);
              }
            });
          }
          //call the auth provider here
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        key: const Key("back"),
        onPressed: () async {
          Navigator.pop(context);
          //call the auth provider here
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 197, 171),
      body: Center(
          child: Form(
        //form widget
        key: _signUpFormKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            fname,
            lname,
            birthdate,
            location,
            email,
            username,
            password,
            SignupButton,
            backButton
          ],
        ),
      )),
    );
  }
}
