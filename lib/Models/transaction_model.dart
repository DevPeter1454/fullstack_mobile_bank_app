import 'dart:convert';

class Transaction {
  dynamic senderAccount;
  dynamic receiverAccount;
  dynamic date;
  dynamic type;
  dynamic amount;
  dynamic reference;
  Transaction({
    this.senderAccount,
    this.receiverAccount,
    this.date,
    this.type,
    this.amount,
    this.reference,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'senderAccount': senderAccount});
    result.addAll({'receiverAccount': receiverAccount});
    result.addAll({'date': date});
    result.addAll({'type': type});
    result.addAll({'amount': amount});
    result.addAll({'reference': reference});
  
    return result;
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      senderAccount: map['senderAccount'],
      receiverAccount: map['recieverAccount'],
      date: map['date'],
      type: map['type'],
      amount: map['amount'],
      reference: map['reference'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));
}
