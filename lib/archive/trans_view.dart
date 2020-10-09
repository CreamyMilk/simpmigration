import 'package:clone/providers/mpesaTransPorvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsView extends StatefulWidget {
  @override
  _TransactionsViewState createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  @override
  Widget build(BuildContext context) {
    return BasicHome();
  }
}

class BasicHome extends StatelessWidget {
  const BasicHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Mpesa Callbacks"),
        backgroundColor: Colors.lightGreen,
      ),
      body: ChangeNotifierProvider<MpexaProvider>(
        create: (context) => MpexaProvider(),
        child: Consumer<MpexaProvider>(
          builder: (context, provider, child) {
            if (provider.data == null) {
              provider.getData(context);
              return Center(child: CircularProgressIndicator());
            }
            return ListView(
                children: provider.data.results
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.network_check,
                                            color: Colors.greenAccent),
                                        Text(
                                          "AccountNo",
                                          style: TextStyle(
                                              color: Colors.grey[500]),
                                        )
                                      ],
                                    ),
                                    Text("${e.billRefNumber}"),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Amount Paid",
                                        style:
                                            TextStyle(color: Colors.grey[500])),
                                    Text(
                                      "Ksh.${e.transAmount}",
                                      style: boldText,
                                    ),
                                    Text("Paid By",
                                        style:
                                            TextStyle(color: Colors.grey[500])),
                                    Text(
                                      "${e.firstName} ",
                                      style: boldText,
                                    )
                                  ],
                                ),
                                Icon(Icons.lightbulb_outline)
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList());
          },
        ),
      ),
      bottomNavigationBar: makeBottom,
    );
  }
}

final boldText = TextStyle(fontWeight: FontWeight.bold);
final makeLight = TextStyle(color: Colors.grey[100], fontSize: 18.0);
final makeBottom = Container(
  height: 55.0,
  child: BottomAppBar(
    color: Color.fromRGBO(58, 66, 86, 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.home, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.blur_on, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.hotel, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.account_box, color: Colors.white),
          onPressed: () {},
        )
      ],
    ),
  ),
);
