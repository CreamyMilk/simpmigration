import 'dart:convert';
import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TokenList extends StatefulWidget {
  @override
  _TokenListState createState() => _TokenListState();
}

class _TokenListState extends State<TokenList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('user').listenable(),
        builder: (context, box, widget) {
          var temp = box.get('transaction');
          var local = json.decode(temp);
          print("SDSSD$local");
          if (true) {
            return Container(
              color: Colors.white70,
              //Bottom Listing size 400
              height: MediaQuery.of(context).size.height *
                  (0.9 - 0.2915941154086502),
              //height:400,
              child: ReorderableListView(
                header: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Past Tokens",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 3.0),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 1),
                  ],
                ),
                onReorder: (oldIndex, newIndex) {
                  print(oldIndex);
                  print(newIndex);
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = local['data'].removeAt(oldIndex);

                    local['data'].insert(newIndex, item);
                    box.put("transaction", jsonEncode(local));
                  });
                },
                children: [
                  for (final item in local['data'])
                    ExpansionTile(
                      key: ValueKey(Random().nextInt(10000)),
                      title: Text(item["month"]),
                      subtitle: Text("${item["time"]}"),
                      leading: CircleAvatar(
                        backgroundColor: Colors.yellowAccent[100],
                        foregroundColor: Colors.transparent,
                        child: Icon(Icons.bolt, color: Colors.black),
                        radius: 20,
                      ),
                      trailing: Text(
                          "Ksh.${(item["rec"]["amount"].toString()).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 15),
                            MaterialButton(
                              child: Row(
                                children: [
                                  Icon(Icons.money, color: Colors.white),
                                  Text(
                                    " Receipt",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              color: Colors.black87,
                              onPressed: () {
                                //Add ID to token
                                Navigator.of(context)
                                    .pushNamed("/tokens", arguments: 1);
                                print("Token");
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                ],
              ),
            );
          }
        });
  }
}