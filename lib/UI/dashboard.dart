import 'package:flutter/material.dart';
import 'package:frontend/Auth/api.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Uri _url = Uri.parse('https://checkout.paystack.com/bmfccwm2vvcfhjw');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $_url';
    }
  }

  launchNewUrl(newUrl) async {
    if (!await launchUrl(newUrl, mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $newUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Title'),
          leading: SizedBox.shrink(),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: CircleAvatar(
                  radius: 50,
                ),
              ),
              ListTile(
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _launchUrl();
                },
                child: Text('Show Flutter homepage'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // var result = await Pay().sendPay() as Map;
                // if (result['status'] == true) {
                //   print('${result["data"]["authorization_url"]} result');
                //   var firstUrl = result['data']["authorization_url"];
                //   var accessCode = result['data']["access_code"];
                //   var secondUrl = Uri.parse('$firstUrl/$accessCode');
                //   launchNewUrl(secondUrl);
                //   // launchNewUrl('$newUrl');
                // }
              },
              child: Text('send pay'),
            ),
          ],
        ));
  }
}
