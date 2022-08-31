import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Pay {
  sendPay(email, amount) async {
    var url = Uri.parse('https://api.paystack.co/transaction/initialize');
    dynamic userData = {
      'amount': amount,
      'email': email,
    };
    http.Response response = await http.post(url, body: userData, headers: {
      'Authorization':
          'Bearer sk_test_1420119f005ac71d5d41fb23fba62431be47b8f5',
    });
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  verifyPay(reference) async {
    var url =
        Uri.parse('https://api.paystack.co/transaction/verify/$reference');
    http.Response response = await http.get(url, headers: {
      'Authorization':
          'Bearer sk_test_1420119f005ac71d5d41fb23fba62431be47b8f5',
    });
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  createTransaction( receiverAccount, amount) async {
    var url = Uri.parse('https://litcon-bank.herokuapp.com/user/create/transaction');
    dynamic body = {
      'senderAccount': 0000000000.toString(),
      'recieverAccount': receiverAccount.toString(),
      'amount': amount.toString(),
      'type': 'Fund',
      'date': DateTime.now().millisecondsSinceEpoch.toString(),
      'reference':
          '${Random().nextInt(1000000000) * Random().nextInt(10000000)}',
    };
    http.Response response = await http.post(url, body: body);
    print(json.decode(response.body));
    return json.decode(response.body);
  }
}
