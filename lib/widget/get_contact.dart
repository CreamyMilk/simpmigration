import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class ContactTest extends StatefulWidget {
  @override
  _ContactTestState createState() => _ContactTestState();
}

class _ContactTestState extends State<ContactTest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: MainWidget(),
      );
}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  PhoneContact _phoneContact;

  String _contact;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            if (_phoneContact != null)
              Column(
                children: <Widget>[
                  const Text("Phone contact:"),
                  Text("Name: ${_phoneContact.fullName}"),
                  Text(
                      "Phone: ${_phoneContact.phoneNumber.number} (${_phoneContact.phoneNumber.label})"),
                ],
              ),
            if (_contact != null) Text(_contact),
            RaisedButton(
              child: const Text("pick phone contact"),
              onPressed: () async {
                final PhoneContact contact =
                    await FlutterContactPicker.pickPhoneContact();
                print(contact);
                setState(() {
                  _phoneContact = contact;
                });
              },
            ),
            RaisedButton(
              child: const Text('Check permission'),
              onPressed: () async {
                final granted = await FlutterContactPicker.hasPermission();
                showDialog(
                    context: context,
                    child: AlertDialog(
                        title: const Text('Granted: '),
                        content: Text('$granted')));
              },
            ),
            RaisedButton(
              child: const Text('Request permission'),
              onPressed: () async {
                final granted = await FlutterContactPicker.requestPermission();
                showDialog(
                    context: context,
                    child: AlertDialog(
                        title: const Text('Granted: '),
                        content: Text('$granted')));
              },
            ),
          ],
        ),
      );
}
