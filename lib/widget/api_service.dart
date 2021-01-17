import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

Future getAllCategories(BuildContext ctx, Position cords) async {
  try {
    final response = await http.post(
      ("http://192.168.0.13:9009/serivces"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(
        {
          'branchid': "8", //Switch in new building
          "lat": cords.latitude,
          "long": cords.longitude,
          "everyting":
              "$cords  altitude:${cords.altitude} speed ${cords.speed} speeed Accuracy ${cords.speedAccuracy} heading ${cords.heading} heading ${cords.heading} mocked ${cords.mocked} ,timestamp ${cords.timestamp} ,accuracy ${cords.accuracy}"
        },
      ),
    );
    var myjson = json.decode(response.body);
    print("Categoreis api returned $myjson");
    print(response.body);

    return myjson;
  } catch (SocketException) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        title: Text("Seems that a Network Error has occured."),
        //       actions: [MaterialButton(color:Colors.black,onPressed:(){AppSettings.openWIFISettings();},child:Text("Turn on",style:TextStyle(color:Colors.white)))],));
      ),
    );
  }
}
