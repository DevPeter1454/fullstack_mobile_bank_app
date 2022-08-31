import 'dart:convert';

class User {
  String firstname;
  String lastname;
  String email;
  String password;
  late dynamic accountNo;
  late dynamic balance;
  late dynamic imgUrl;
  User({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    this.accountNo,
    this.balance,
    this.imgUrl,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'email': email});
    result.addAll({'password': password});
    result.addAll({'accountNo': accountNo});
    result.addAll({'balance': balance});
    result.addAll({'imgUrl': imgUrl});
  
    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      accountNo: map['accountNumber'] ?? '',
      balance: map['accountBalance'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
