// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Auth/api.dart';
import 'package:frontend/Models/user_model.dart';
import 'package:frontend/constants/clip.dart';
import 'package:frontend/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

class Transfer extends StatefulWidget {
  const Transfer({Key? key}) : super(key: key);

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final _scroller = ScrollController();
  final _amount = TextEditingController();
  final _receiver = TextEditingController();
  final _password = TextEditingController();
  dynamic received;
  User? user;
  bool start = false;
  bool receiverRetrieved = false;
  String receiver = '';

  @override
  void initState() {
    super.initState();
    _receiver.addListener(() {
      if (_receiver.text.isNotEmpty && _receiver.text.length <= 9) {
        setState(() {
          start = true;
        });
      } else {
        setState(() {
          start = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    received = ModalRoute.of(context)!.settings.arguments as Map;
    user = received['user'];
    return Scaffold(
        backgroundColor: MyColors.colorD,
        appBar: AppBar(
          // title: const Text('Transfer'),

          backgroundColor: MyColors.colorB,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            controller: _scroller,
            child: Column(children: <Widget>[
              ClipPath(
                clipper: ClipPathClass(),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0XFFEC4420),
                        Color(0XFFED4D23),
                        Color(0XFFEA251F),

                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Transfer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  maxLength: 10,
                  controller: _receiver,
                  inputFormatters: [
                    // ignore: deprecated_member_use
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Enter an Account Number',
                    label: Text('Enter an Account Number'),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  onEditingComplete: () async {
                    var result = await Auth()
                        .getTransferRecipient(_receiver.text.toString());
                    if (result != null) {
                      if (result['message'] ==
                          'Transfer recipients retrieved successfully') {
                        setState(() {
                          start = false;
                          receiver = result['user']['firstname'] +
                              ' ' +
                              result['user']['lastname'];
                        });
                      }
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _amount,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Enter Amount',
                    label: Text('Enter Amount'),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              start
                  ? SizedBox(
                      width: 350.0,
                      height: 25.0,
                      child: Shimmer.fromColors(
                        baseColor: const Color.fromRGBO(224, 224, 224, 1),
                        highlightColor: const Color.fromRGBO(245, 245, 245, 1),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          color: Colors.white,
                        ),
                      ))
                  : Text(receiver.toUpperCase()),
              ElevatedButton(
                onPressed: () {
                  if (_amount.text.isNotEmpty && _receiver.text.isNotEmpty) {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            title: const Text('Confirm Transfer'),
                            content: TextField(
                              controller: _password,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Enter Password',
                                label: Text('Enter Password to Continue'),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_password.text.isNotEmpty &&
                                        _password.text == user!.password) {
                                      var result = await Auth().transfer(
                                          user!.accountNo.toString(),
                                          _receiver.text,
                                          _amount.text.toString());
                                      if (result['message'] ==
                                          'Transfer successful') {
                                        Navigator.pop(context);
                                        _amount.clear();
                                        _receiver.clear();
                                        _password.clear();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(result['message']),
                                          duration: const Duration(seconds: 2),
                                        ));
                                      } else {
                                        Navigator.pop(context);
                                        _amount.clear();
                                        _receiver.clear();
                                        _password.clear();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(result['message']),
                                          duration: const Duration(seconds: 2),
                                        ));
                                      }
                                    } else {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Password Incorrect'),
                                        duration: Duration(seconds: 2),
                                      ));
                                    }
                                  },
                                  child: const Text('Confirm')),
                            ],
                          );
                        }));
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: MyColors.colorB,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Transfer'),
              ),
            ])));
  }
}
