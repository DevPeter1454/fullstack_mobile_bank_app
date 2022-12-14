// ignore_for_file: avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth {
  signUp(user) async {
    // var url = Uri.https('http://localhost:5000', '/');
    try{
      var url = Uri.parse('https://litcon-bank.herokuapp.com/user');
    var signUp = Uri.parse('https://litcon-bank.herokuapp.com/user/signup');
    http.Response response = await http.get(url);
    print(json.decode(response.body));
    // print(json.encode(user));
    dynamic userData = {
      'firstname': user['firstname'],
      'lastname': user['lastname'],
      'email': user['email'],
      'password': user['password'],
      'accountNumber': user['accountNo'],
      'accountBalance': user['balance'],
      'imgage': user['imgUrl'],
    };
    http.Response data = await http.post(signUp, body: userData);
    print(json.decode(data.body));
    return json.decode(data.body);
    } catch(e){
      print(e);
    }
  }

  signin(user) async {
    try{
      var url = Uri.parse('https://litcon-bank.herokuapp.com/user/signin');
    dynamic userData = {
      'email': user['email'],
      'password': user['password'],
    };
    print(userData);
    http.Response response = await http.post(url, body: userData);
    print(json.decode(response.body));
    return json.decode(response.body);
    } catch(e){
      print(e);
    }
  }

  fundAccount(email, amount) async {
   try{
     var url = Uri.parse('https://litcon-bank.herokuapp.com/user/pay/fund');
    dynamic userData = {
      'email': email,
      'amount': amount,
    };
    print(userData);
    http.Response response = await http.post(url, body: userData);
    print(json.decode(response.body));
    return json.decode(response.body);
   } catch(e){
     print(e);
   }
  }

  getUserRecord(email) async {
    try{
      var url = Uri.parse('https://litcon-bank.herokuapp.com/user/getUser');
    dynamic userData = {
      'email': email,
    };
    http.Response response = await http.post(url, body: userData);
    print(json.decode(response.body));
    return json.decode(response.body);
    }catch(e){
      print(e);
    }
  }

  uploadImage(img) async {
    try{
      var url = Uri.parse('https://litcon-bank.herokuapp.com/user/upload');
    dynamic body = {
      'image': img,
    };
    http.Response response = await http.post(url, body: body);
    print(json.decode(response.body));
    return json.decode(response.body);
    } catch(e){
      print(e);
    }
  }

  transfer(senderAccount, receiverAccount, amount)async{
    try{
      var url = Uri.parse('https://litcon-bank.herokuapp.com/user/transfer');
    dynamic body = {
      'senderAccount': senderAccount.toString(),
      'recieverAccount': receiverAccount.toString(),
      'amount': amount.toString(),
      'type': 'Transfer',
      'date': DateTime.now().millisecondsSinceEpoch.toString(),
      'reference': '${Random().nextInt(1000000000)*Random().nextInt(10000000)}',

    };
    http.Response response = await http.post(url, body: body);
    print(json.decode(response.body));
    return json.decode(response.body);
    } catch(e){
      print(e);
    }
  }

  getTransferRecipient(accountNumber)async{
    try{
      var url = Uri.parse('https://litcon-bank.herokuapp.com/user/transfer/recipients/$accountNumber');
    http.Response response = await http.get(url);
    print(json.decode(response.body));
    return json.decode(response.body);
    }catch (e){
      print(e);
    }
  }

  getTransactions(accountNumber)async{
    try{
      var url = Uri.parse('https://litcon-bank.herokuapp.com/user/get/transactions/$accountNumber/$accountNumber');
    http.Response response = await http.get(url);
    // print(json.decode(response.body));
    return json.decode(response.body);
    } catch(e){
      print(e);
    }
  }
}




