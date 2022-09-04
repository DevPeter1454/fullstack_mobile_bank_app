import 'package:flutter/material.dart';
import 'package:frontend/Auth/api.dart';
import 'package:frontend/Models/transaction_model.dart';
import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  dynamic user;
  Transactions({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  List userTransactions = [] ;

 getUserTransactions() async {
    var value = await Auth().getTransactions(widget.user.accountNo);
    if (value != null) {
      // print(value);
      if(value['message']=='Transactions found'){
        var transactions = value['transactions'] as dynamic;
      transactions.forEach((transaction) =>
          {userTransactions.add(Transaction.fromMap(transaction))});
      setState(() {
      });
      }else{
        userTransactions = [];
        setState(() {
      });
      }
      // print(transactions);
    }
    // print(accountNumber);
  }

  @override
  void initState() {
    super.initState();
    getUserTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body:  userTransactions.isEmpty ? const Center(child: Text('No transactions found')):ListView.builder(
            itemCount: userTransactions.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: userTransactions[index].senderAccount == widget.user.accountNo ?Colors.red[50]:Colors.green[50],
                      child: userTransactions[index].senderAccount == widget.user.accountNo ? const Icon(Icons.arrow_upward_rounded, color: Colors.red,): const Icon(Icons.arrow_downward_rounded, color: Colors.green),
                    ),
                    title: userTransactions[index].senderAccount == widget.user.accountNo
                        ? Text(
                            'You transferred ${userTransactions[index].amount} to ${userTransactions[index].receiverAccount} ',
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                ),
                          )
                        : Text(
                            'You received ${userTransactions[index].amount} from  ${userTransactions[index].senderAccount} ',
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 15,
                                ),

                          ),
                    subtitle: Text(DateFormat.yMEd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(userTransactions[index].date)).toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            )),
                  
                  ),
                ),
              );
            }));
  }
}
