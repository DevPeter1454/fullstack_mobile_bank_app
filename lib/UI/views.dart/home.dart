// ignore_for_file: library_private_types_in_public_api, must_be_immutable, use_build_context_synchronously

import 'package:frontend/Auth/apib.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants/loading.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:frontend/Auth/api.dart';
import 'package:frontend/Models/user_model.dart';

class Home extends StatefulWidget {
  dynamic user;
  Home({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  User? user;
  //get user records from the database
  getUser() async {
    user = widget.user;
    var updatedUser = await Auth().getUserRecord(user!.email);
    if (updatedUser != null) {
      user = User.fromMap(updatedUser['user']);
      // print(user!.balance.toString().split('').);
      setState(() {});
    }
  }

  final fundAmount = TextEditingController(); //for the amount to be funded
  var reference = ''; //for the reference
  bool process = false; //for the loading process

  @override
  void initState() {
    super.initState();
    print('init');
    getUser();
    //for web
    if (kIsWeb) {
      html.window.addEventListener('focus', onFocus);
      html.window.addEventListener('blur', onBlur);
    } else {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  //focused on the appp
  void onFocus(html.Event e) {
    didChangeAppLifecycleState(AppLifecycleState.resumed);
  }

  //blurred from the app
  void onBlur(html.Event e) {
    didChangeAppLifecycleState(AppLifecycleState.paused);
  }

  @override
  void dispose() {
    html.window.removeEventListener('focus', onFocus);
    html.window.removeEventListener('blur', onBlur);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    print('deactivate');
    // getUser();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (process) {
          //verify transaction
          var result = await Pay().verifyPay(reference);
          if (result['data']['status'] == 'success') {
            var amount = (result['data']['amount'] / 100).toString();
            var data = await Auth().fundAccount(user!.email, amount) as Map;
            
            if (data['message'] == 'User funded successfully') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account funded successfully'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error funding account'),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error funding account'),
              ),
            );
          }
          var updatedUser = await Auth().getUserRecord(user!.email);
          setState(() {
            process = false;
            reference = '';
            user = User.fromMap(updatedUser['user']);
          });
        }
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  //launch transaction
  launchNewUrl(newUrl) async {
    if (!await launchUrl(newUrl, mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $newUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    // getUser();
    return process
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: const Text('Dashboard'),
              leading: const SizedBox.shrink(),
              elevation: 0,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Welcome back ${user!.firstname} ${user!.lastname} ",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0XFF3523A9),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0XFF1C97EB),
                            Colors.blue,
                            Color(0XFF3523A9),
                          ]),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${user!.accountNo}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Balance',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${user!.balance}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var result = await Navigator.pushNamed(context, '/transfer', arguments: {
                          'user': user,
                        });
                        // Navigator.pop(context);
                        Future.delayed(const Duration(seconds: 1), () {
                          getUser();
                        });
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.money_rounded),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Send'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Column(
                        children: const [
                          Icon(Icons.arrow_downward),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Request'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Column(
                        children: const [
                          Icon(Icons.payment),
                          SizedBox(
                            height: 10,
                          ),
                          Text('PayBill'),
                        ],
                      ),
                    ),
                    //fund account
                    GestureDetector(
                      onTap: () async {
                        //
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Fund Your Account'),
                                content: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.8,
                                  height: 70,
                                  child: TextField(
                                    controller: fundAmount,
                                    decoration: const InputDecoration(
                                      labelText: 'Amount in Kobo',
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    child: const Text('Pay'),
                                    onPressed: () async {
                                      var result = await Pay().sendPay(
                                          user!.email, fundAmount.text) as Map;
                                      print('result $result');
                                      if (result['status'] == true) {
                                        setState(() {
                                          process = true;
                                          reference =
                                              result['data']['reference'];
                                        });
                                        print(
                                            '${result["data"]["authorization_url"]} result');
                                        var firstUrl =
                                            result['data']["authorization_url"];
                                        var accessCode =
                                            result['data']["access_code"];
                                        var secondUrl =
                                            Uri.parse('$firstUrl/$accessCode');
                                        Navigator.pop(context);
                                        launchNewUrl(secondUrl);
                                        fundAmount.clear();
                                        // launchNewUrl('$newUrl');
                                      }
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.add_box_rounded),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Fund Account'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }
}
