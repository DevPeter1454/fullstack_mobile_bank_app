import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/constants/constants.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    backgroundColor: MyColors.colorC,
    body: Center(
      child: SpinKitSquareCircle(
        color: MyColors.colorB,
        size: 50.0,
      )
    ),
    );
  }
}
