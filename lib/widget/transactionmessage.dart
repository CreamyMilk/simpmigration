import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class TransCard extends StatefulWidget {
  @override
  _TransCardState createState() => _TransCardState();
}

class _TransCardState extends State<TransCard> {
  String transId = "OBFA41763";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(label: Text("Title")),
          DataColumn(label: Text("Data")),
        ],
        rows: [
          DataRow(
            selected: false,
            cells: [
              DataCell(Text("Payed to:")),
              DataCell(BoldTitle(title: "174379")),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Account No:")),
              DataCell(BoldTitle(title: "Jotham#A2")),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("TransactionID")),
              DataCell(BoldTitle(title: "OBFA41763")),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text("Amount")),
              DataCell(BoldTitle(title: "Ksh.10")),
            ],
          ),
          DataRow(
            cells: [
              DataCell(IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () {
                  FlutterClipboard.copy(transId).then(
                    (value) => Scaffold.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(milliseconds: 500),
                        elevation: 100.0,
                        backgroundColor: Colors.greenAccent,
                        content: Row(
                          children: [
                            Icon(Icons.thumb_up),
                            Divider(),
                            Text("Copied Transaction id Succesfully"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
              DataCell(Text("Show Past Transactions")),
            ],
          ),
        ],
      ),
    );
  }
}

class BoldTitle extends StatelessWidget {
  BoldTitle({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }
}
