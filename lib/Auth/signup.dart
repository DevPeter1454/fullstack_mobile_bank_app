import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/Auth/api.dart';
import 'package:frontend/Models/user_model.dart';
import 'package:frontend/UI/main_page.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/constants/loading.dart';
import 'package:file_picker/file_picker.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool loading = false;
  Uint8List? imageFile;
  var base64 = '';
  var imgUrl = '';
  bool imgUploaded = false;
  bool imgDone = false;

  pickFile() async {
    setState(() {
      imgUploaded = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
      // allowedExtensions: ['jpg', 'png'],
    );
    // var file = result.files.first.bytes;
    if (result != null) {
      setState(() {
        imageFile = result.files.first.bytes;
        base64 = base64Encode(imageFile!.toList());
        // print(base64.toString().substring(0, 100));
      });
      var data = await Auth().uploadImage(base64);
      if (data.containsKey('image')) {
        imgUploaded = false;
        imgUrl = data['image'];
        setState(() {
          imgDone = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: MyColors.colorB,
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.9,
                      decoration: const BoxDecoration(
                        color: MyColors.colorD,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: textField(
                                _firstname,
                                'First Name',
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: textField(
                                _lastname,
                                'Last Name',
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: textField(
                                _email,
                                'Email',
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: 70,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: _password,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: MyColors.colorA,
                                    fontSize: 15,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a text';
                                  } else if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                              onTap: () async {
                                await pickFile();
                              },
                              child: SizedBox(
                                  height: 100,
                                  width: 250,
                                  child: imgDone
                                      ? Image.memory(imageFile!)
                                      : const Text('Click to upload'))),
                          ElevatedButton(
                            onPressed: () async {
                              if (_email.text.isEmpty ||
                                  _password.text.isEmpty ||
                                  _firstname.text.isEmpty ||
                                  _lastname.text.isEmpty || imgUrl.isEmpty) {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Please fill in all fields'),
                                      actions: <Widget>[
                                        OutlinedButton(
                                          child: const Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                if (_formKey.currentState!.validate() &&
                                    imgDone) {
                                  var user = User(
                                    firstname: _firstname.text,
                                    lastname: _lastname.text,
                                    email: _email.text,
                                    password: _password.text,
                                    accountNo:
                                        (Random().nextInt(1000000000) * 10)
                                            .toString(),
                                    balance: (0).toString(),
                                    imgUrl: imgUrl,
                                  ).toMap();
                                  setState(() {
                                    loading = true;
                                  });
                                  print(user);
                                  await Auth().signUp(user).then((value) {
                                    if (value != null) {
                                      var data = value as Map;
                                      setState(() {
                                        loading = false;
                                      });
                                      if (data.containsKey('error')) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(data['message']),
                                              content: Text(data['error']),
                                              actions: <Widget>[
                                                OutlinedButton(
                                                  child: const Text('Close'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        imgDone = false;
                                        imgUrl = '';
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Account created successfully'),
                                          duration: Duration(seconds: 2),
                                        ));
                                        Navigator.of(context)
                                            .pushReplacementNamed('/signin');
                                        
                                      }
                                    } else {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Error'),
                                            content: const Text(
                                                'Something went wrong'),
                                            actions: <Widget>[
                                              OutlinedButton(
                                                child: const Text('Close'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  });
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(MyColors.colorA),
                              minimumSize: MaterialStateProperty.all(Size(
                                  MediaQuery.of(context).size.width * 0.6, 50)),
                            ),
                            child: imgUploaded
                                ? const CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )
                                : imgDone
                                    ? const Text('Complete Sign Up process')
                                    : const Text(' Start Sign Up process'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  color: MyColors.colorA,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signin');
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: MyColors.colorB,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      ))
                ],
              ),
            ),
          );
  }
}
