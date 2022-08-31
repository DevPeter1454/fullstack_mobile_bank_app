// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/Auth/api.dart';
import 'package:frontend/Auth/apic.dart';
import 'package:frontend/Models/user_model.dart';

class Wallet extends StatefulWidget {
  dynamic user;
  Wallet({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  User? user;
  final _walletName = TextEditingController();
  final _walletFundAmount = TextEditingController();
  final _walletTargetAmount = TextEditingController();
  final _walletDescription = TextEditingController();

  List<dynamic> _wallets = [];

  getUser() async {
    user = widget.user;
    var updatedUser = await Auth().getUserRecord(user!.email);
    if (updatedUser != null) {
      user = User.fromMap(updatedUser['user']);
      var result = await UserWallet().getUserWallets(user!.accountNo) as Map;
      var list = result['wallet'] as List;
      _wallets.clear();
      list.forEach((element) {
        _wallets.add(Wallets.fromMap(element));
        // print(element['_id']);
      });
      // print('$_wallets list');
      setState(() {
        // _wallets = list.map((i) => Wallets.fromMap(i)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // user = widget.user;
    getUser();
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Wallet'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),
      body: _wallets.isEmpty
          ? const Center(
              child: Text('No Wallets'),
            )
          : ListView.builder(
              itemCount: _wallets.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                                'Wallet Name: ${_wallets[index].walletName}')),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Wallet Balance: ${_wallets[index].walletBalance}'),
                              const SizedBox(height: 10),
                              Text(
                                  'Target Amount: ${_wallets[index].targetAmount}'),
                              const SizedBox(height: 10),
                              Text(
                                  'Wallet Description: ${_wallets[index].walletDescription}'),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                       print(_wallets[index].id);
                                      showDialog(
                                          context: context,
                                          builder: ((context) {
                                            return AlertDialog(
                                              title: const Text('Fund Wallet'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller:
                                                        _walletFundAmount,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: 'Enter Amount',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    print(_wallets[index].id);
                                                    var result =
                                                        await UserWallet()
                                                            .fundWallet(
                                                                user!.accountNo,
                                                                _walletFundAmount
                                                                    .text,
                                                                _wallets[index]
                                                                    .id) as Map;
                                                    if (result['message'] ==
                                                        'Wallet funded successfully') {
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                            'Wallet funded successfully'),
                                                      ));
                                                      getUser();
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                        content: Text(
                                                            'Wallet funding failed'),
                                                      ));
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text('Fund'),
                                                ),
                                              ],
                                            );
                                          }));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color.fromARGB(
                                            255, 32, 128, 35)),
                                    child: const Text('Fund Wallet'),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color.fromARGB(
                                            255, 235, 178, 7),
                                      ),
                                      child: const Text('Withdraw Funds')),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                      onPressed: () async {
                                        var result = await UserWallet()
                                            .deleteWallet(_wallets[index].id);
                                        if (result['message'] ==
                                            'Wallet deleted successfully') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Wallet deleted successfully'),
                                          ));
                                          getUser();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text('Wallet deletion failed'),
                                          ));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(
                                              255, 201, 14, 23)),
                                      child: const Text('Delete Wallet')),
                                ],
                              )
                            ]),
                      ),
                      // trailing: Text(_wallets[index].walletBalance.toString()),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create Wallet',
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Create Wallet'),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(children: [
                    TextField(
                      controller: _walletName,
                      decoration: const InputDecoration(
                        hintText: 'Wallet Name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _walletTargetAmount,
                      decoration: const InputDecoration(
                        hintText: 'Target Amount',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _walletDescription,
                      decoration: const InputDecoration(
                        hintText: 'Wallet Description',
                      ),
                    ),
                  ]),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      primary: const Color.fromARGB(255, 184, 28, 28),
                    ),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      var data = await UserWallet().createWallet(
                        user!.accountNo,
                        _walletName.text,
                        0,
                        _walletTargetAmount.text,
                        _walletDescription.text,
                      );
                      print(data);
                      if (data != null) {
                        if (data['message'] == 'Wallet created successfully') {
                          Navigator.pop(context);
                          _walletName.clear();
                          _walletTargetAmount.clear();
                          _walletDescription.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Wallet created successfully'),
                            ),
                          );
                          getUser();
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Wallet creation failed'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.grey[850],
        child: const Icon(Icons.add),
      ),
    );
  }
}
