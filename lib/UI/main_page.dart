import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:frontend/UI/views.dart/home.dart';
import 'package:frontend/UI/views.dart/profile.dart';
import 'package:frontend/UI/views.dart/settings.dart';
import 'package:frontend/UI/views.dart/transactions.dart';
import 'package:frontend/UI/views.dart/wallet.dart';

class MainPage extends StatefulWidget {
  dynamic user;
  MainPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  int _bottomIndex = 0;
  final _pager = PageController();
  dynamic user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Home(user: user),
      Wallet(user: user),
      const Profile(),
     Transactions(user: user),
      const Settings(),
    ];
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: PageView.builder(
        controller: _pager,
        itemBuilder: (context, index) {
          return children[index];
        },
        onPageChanged: (index) {
          print('causing this');
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: children.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pager.jumpToPage(2);
        },
        backgroundColor: _currentIndex == 2 ? Colors.red : Colors.blue,
        child: const Icon(Icons.person),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeIndex: _bottomIndex,
        activeColor:
            _currentIndex == _bottomIndex || _currentIndex > _bottomIndex
                ? Colors.blue
                : Colors.black,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        icons: const [
          Icons.home,
          Icons.wallet,
          Icons.history,
          Icons.settings,
        ],
        onTap: (index) {
          if (index == 0) {
            setState(() {
              _bottomIndex = index;
              _pager.jumpToPage(0);
            });
          } else if (index == 1) {
            setState(() {
              _bottomIndex = index;
              _pager.jumpToPage(1);
            });
          } else if (index == 2) {
            setState(() {
              _bottomIndex = index;
              _pager.jumpToPage(3);
            });
          } else if (index == 3) {
            setState(() {
              _bottomIndex = index;
              _pager.jumpToPage(4);
            });
          }
          //     setState(() {
          //   _bottomIndex = index;
          //   _pager.jumpToPage(index);
          // });
        },
      ),
    );
  }
}
