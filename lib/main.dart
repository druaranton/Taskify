/*
  Author: Andreau O. Aranton
  Section: D-1L
  Date created: 11/15/22
  Project
  Program Description: A Flutter mobile application composed of a sign in, sign-up and a shared todo list features with a user’s friends
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/todo_provider.dart';
import '/providers/auth_provider.dart';
import '/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '/screens/home_page.dart';
import 'providers/friends_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => TodoListProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => FriendsListProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleTodo',
      initialRoute: '/',
      routes: {'/': (context) => AuthWrapper()},
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isAuthenticated) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
