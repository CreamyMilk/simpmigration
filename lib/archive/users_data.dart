import 'package:clone/archive/trans_view.dart';
import 'package:clone/providers/usersprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserTest extends StatelessWidget {
  final String appTitle;

  const UserTest({this.appTitle});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TransactionsView(),
          ));
        },
      ),
      body: ChangeNotifierProvider<MyTransactionprovider>(
        create: (context) => MyTransactionprovider(),
        child: Consumer<MyTransactionprovider>(
          builder: (context, provider, child) {
            if (provider.data == null) {
              provider.getData(context);
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text("rent"),
                    ),
                    DataColumn(
                      label: Text("rent"),
                    ),
                    DataColumn(label: Text("rent"))
                  ],
                  rows: provider.data.results
                      .map((e) => DataRow(cells: [
                            DataCell(Text(e.rUnitNo)),
                            DataCell(Text(e.rent.toString())),
                            DataCell(Text(e.status.toString())),
                          ]))
                      .toList(),
                ),
              ),
            );
          },
        ),
      ));
}
