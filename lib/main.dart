import 'package:flutter/material.dart';
import 'package:frontend/Auth/siginin.dart';
import 'package:frontend/Auth/signup.dart';
import 'package:frontend/UI/dashboard.dart';
import 'package:frontend/UI/main_page.dart';
import 'package:frontend/UI/services/transfer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const Signup(),
        '/signin': (context) =>  const Siginin(),
        // '/dashboard': (context) => const MainPage(),
        '/transfer': (context) => const Transfer(),
      },
    );
  }
}

