import 'dart:ui';

import 'package:flutter/material.dart';

class ComplainsForm extends StatefulWidget {
  ComplainsForm({Key key}) : super(key: key);

  @override
  _ComplainsFormState createState() => _ComplainsFormState();
}

class _ComplainsFormState extends State<ComplainsForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complains Sumbmisson",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Complain Type",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
            SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Kindly enter a caegory',
                helperText: 'Complain type',
                labelText: 'Category',
              ),
              maxLines: 1,
            ),
            SizedBox(height: 20),
            Text("Complain Description",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
            SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Kindly describe the issue',
                helperText: 'Be descriptive as possible.',
                labelText: 'Description',
              ),
              maxLines: 3,
            ),
            Row(
              children: [
                MaterialButton(
                  color: Colors.black,
                  onPressed: () {
                    showDialog(
                      //Text(message['notification']['title']
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Complain Submitted"),
                        content:
                            Text("It will be resolved in due time\nThank You."),
                        actions: [
                          MaterialButton(child:Text("Close",style: TextStyle(color:Colors.white)),color:Theme.of(context).primaryColor,onPressed: () { Navigator.of(context).pushNamed('/home'); },),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Spacer(),
                OutlineButton(
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
