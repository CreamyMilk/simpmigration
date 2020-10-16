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
        child: Column(
          children: [
            Text("Type"),
            TextField(),
            Text("Complain Description"),
            TextField(),
            MaterialButton(
              onPressed: () {
                showDialog(
                  //Text(message['notification']['title']
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Type"),
                    content: Text("\n Description:"),
                    actions: [Text("Close")],
                  ),
                );
              },
              child: Text("Submit"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancal"),
            )
          ],
        ),
      ),
    );
  }
}
