import 'package:flutter/material.dart';
import 'package:frontend/UI/onboard.dart';
import 'package:frontend/constants/constants.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoard()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: MyColors.colorC,
      body: Center(
        child: FlutterLogo(
          size: 100,
        ),
      )
    );
  }
}
