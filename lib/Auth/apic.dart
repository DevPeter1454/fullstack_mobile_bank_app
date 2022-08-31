import 'dart:convert';

import 'package:http/http.dart' as http;

class Wallets {
  dynamic id;
  dynamic accountNumber;
  String walletName;
  dynamic walletBalance;
  dynamic targetAmount;
  String walletDescription;
  Wallets({
    required this.id,
    required this.accountNumber,
    required this.walletName,
    required this.walletBalance,
    required this.targetAmount,
    required this.walletDescription,
  });

 
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'accountNumber': accountNumber});
    result.addAll({'walletName': walletName});
    result.addAll({'walletBalance': walletBalance});
    result.addAll({'targetAmount': targetAmount});
    result.addAll({'walletDescription': walletDescription});

    return result;
  }

  factory Wallets.fromMap(Map<String, dynamic> map) {
    return Wallets(
      accountNumber: map['accountNumber'],
      walletName: map['walletName'] ?? '',
      walletBalance: map['walletBalance'] ?? '',
      targetAmount: map['targetAmount'],
      walletDescription: map['walletDescription'] ?? '', 
      id: map['_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Wallets.fromJson(String source) => Wallets.fromMap(json.decode(source));
}


class UserWallet{

   createWallet(accountNumber, walletName, walletBalance, targetAmount,
      walletDescription) async {
    var url = Uri.parse('https://litcon-bank.herokuapp.com/user/wallet/create');
    dynamic formData = {
      'accountNumber': '$accountNumber',
      'walletName': '$walletName',
      'walletBalance': '$walletBalance',
      'targetAmount': '$targetAmount',
      'walletDescription': '$walletDescription',
    };
    http.Response response = await http.post(url, body: formData);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  getUserWallets(accountNumber)async{
    var url = Uri.parse('https://litcon-bank.herokuapp.com/user/wallet/$accountNumber');
    http.Response response = await http.get(url,);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  fundWallet(accountNumber, amount, id) async {
    var url = Uri.parse('https://litcon-bank.herokuapp.com/user/wallet/fund');
    dynamic formData = {
      'accountNumber': '$accountNumber',
      'fundAmount': '$amount',
      'id': '$id',
    };
    http.Response response = await http.post(url, body: formData);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  deleteWallet(id)async{
    var url = Uri.parse('https://litcon-bank.herokuapp.com/user/wallet/delete/$id');
    http.Response response = await http.get(url);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

}