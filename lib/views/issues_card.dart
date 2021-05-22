import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:simpmigration/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class IssuesCard extends StatefulWidget {
  IssuesCard({Key key}) : super(key: key);

  @override
  _IssuesCardState createState() => _IssuesCardState();
}

class _IssuesCardState extends State<IssuesCard> {
  String _houseNumber = "-";

  List<String> option = ["Contact Us"];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "HouseNo  :$_houseNumber",
                style: TextStyle(
                    fontSize: 10.0,
                    //ontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
              Container(child: Text("Issues")),
              PopupMenuButton(
                onSelected: choiceAction,
                icon: Icon(Icons.more_horiz),
                itemBuilder: (BuildContext context) {
                  return option.map((String choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          ValueListenableBuilder(
              valueListenable: Hive.box(Constants.HiveBoxName).listenable(),
              builder: (context, box, widget) {
                var noofcomplains = box.get(Constants.ReportedIssuesStore);
                return Text(
                  "$noofcomplains",
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 30.0,
                  ),
                );
              }),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 100),
                color: Colors.transparent,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(5.0),
                child: MaterialButton(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text("Inquiry", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/complain', arguments: "Inquiry");
                    // setState(() {
                    //   _testvar = !_testvar;
                    // });
                  },
                ),
              ),
              AnimatedContainer(
                duration: Duration(seconds: 100),
                color: Colors.transparent,
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(5.0),
                child: Hero(
                  tag: "report",
                  child: MaterialButton(
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      children: [
                        Text("Report !", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/complain', arguments: "Complain");
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

void choiceAction(String choice) async {
  if (choice == "Contact Us") {
    final url = 'tel:254714164318';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
