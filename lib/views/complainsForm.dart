import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ComplainsForm extends StatefulWidget {
  ComplainsForm({Key key}) : super(key: key);

  @override
  _ComplainsFormState createState() => _ComplainsFormState();
}

GlobalKey<FormState> formkey = GlobalKey<FormState>();

class _ComplainsFormState extends State<ComplainsForm> {
  final typeController = TextEditingController();
  final descController = TextEditingController();

  void validateForm() {
    if (formkey.currentState.validate()) {
      var ty = typeController.text;
      var ds = descController.text;
      sendComplain(ty, ds, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _loading = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complains Sumbmisson",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Complain Type",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
              SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Required";
                  } else {
                    return null;
                  }
                },
                controller: typeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Kindly enter a category',
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
                validator: (value) {
                  if (value.isEmpty) {
                    return "Required";
                  } else {
                    return null;
                  }
                },
                controller: descController,
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
                  Hero(
                    tag: 'report',
                    child: MaterialButton(
                      color: Colors.black,
                      onPressed: () {
                        validateForm();
                        setState(() {
                          if (formkey.currentState.validate()) {
                            _loading = true;
                          }
                        });
                      },
                      child: _loading
                          ? CircularProgressIndicator()
                          : Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
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
      ),
    );
  }
}

Future sendComplain(type, desc, context) async {
  final userHiveBox = Hive.box('user');
  final uid = userHiveBox.get("uid", defaultValue: "1");
  try {
    final response = await http.post(
      ("http://92.222.201.138:9003" + "/complain"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(
        {"type": type, "description": desc, "uid": uid, "bid": "8"},
      ),
    );
    var myjson = json.decode(response.body);
    if (myjson["message"] == "1") {
      showDialog(
        //Text(message['notification']['title']
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Complain Submitted"),
          content: Text("It will be resolved in due time\nThank You."),
          actions: [
            MaterialButton(
              child: Text("Close", style: TextStyle(color: Colors.white)),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed('/home');
              },
            ),
          ],
        ),
      );
    }
  } catch (SocketException) {
    showDialog(
      //Text(message['notification']['title']
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error on Submittion"),
        content: Text("Please try later with a stable\nConnection."),
        actions: [
          MaterialButton(
            child: Text("Close", style: TextStyle(color: Colors.white)),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed('/home');
            },
          ),
        ],
      ),
    );
  }
}
