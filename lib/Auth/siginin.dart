import 'package:flutter/material.dart';
import 'package:frontend/Auth/api.dart';
import 'package:frontend/Models/user_model.dart';
import 'package:frontend/UI/main_page.dart';
import 'package:frontend/constants/constants.dart';
import 'package:frontend/constants/loading.dart';

class Siginin extends StatefulWidget {
  const Siginin({Key? key}) : super(key: key);

  @override
  _SigininState createState() => _SigininState();
}

class _SigininState extends State<Siginin> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: MyColors.colorB,
            body: Column(children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.8,
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
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: MyColors.colorA,
                                fontSize: 15,
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              } else {
                                return null;
                              }
                            },
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_email.text.isEmpty || _password.text.isEmpty) {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content:
                                      const Text('Please fill in all fields'),
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
                            if (_formKey.currentState!.validate()) {
                              var user = User(
                                firstname: '',
                                lastname: '',
                                email: _email.text,
                                password: _password.text,
                              ).toMap();
                              print(user);
                              setState(() {
                                loading = true;
                              });
                              await Auth().signin(user).then((value) {
                                if (value != null) {
                                  setState(() {
                                    data = value as Map;
                                    loading = false;
                                  });
                                  print(data);
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
                                                //               setState(() {
                                                //   loading = false;
                                                // });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    var user = User.fromMap(data['user']);
                                    print(user);
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: ((context) {
                                      return MainPage(user: user);
                                    })));
                                  }
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
                        child: const Text('Sign In'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Don\'t have an account yet?',
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
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                color: MyColors.colorB,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  )),
            ]));
  }
}
