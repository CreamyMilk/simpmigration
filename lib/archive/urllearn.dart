import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'URL Launcher');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _launched;
  String _phone = '';

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchInWebViewWithDomStorage(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    const String toLaunch = 'https://www.i-crib.co.ke/lists';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                    onChanged: (String text) => _phone = text,
                    decoration: const InputDecoration(
                        hintText: 'Input the phone number to launch')),
              ),
              RaisedButton(
                onPressed: () => setState(() {
                  _launched = _makePhoneCall('tel:$_phone');
                }),
                child: const Text('Make phone call'),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(toLaunch),
              ),
              const Padding(padding: EdgeInsets.all(16.0)),
              RaisedButton(
                onPressed: () => setState(() {
                  _launched = _launchInWebViewWithJavaScript(toLaunch);
                }),
                child: const Text('Launch in app(JavaScript ON)'),
              ),
              RaisedButton(
                onPressed: () => setState(() {
                  _launched = _launchInWebViewWithDomStorage(toLaunch);
                }),
                child: const Text('Launch in app(DOM storage ON)'),
              ),
              const Padding(padding: EdgeInsets.all(16.0)),
              const Padding(padding: EdgeInsets.all(16.0)),
              const Padding(padding: EdgeInsets.all(16.0)),
              FutureBuilder<void>(future: _launched, builder: _launchStatus),
            ],
          ),
        ],
      ),
    );
  }
}
