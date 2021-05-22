// Future getServices(serviceName, lat, long, context) async {
//   ServicesNet data;
//   print('Service requested for is  $serviceName');
//   if (serviceName != null) {
//     print("Got Data from api");
//     try {
//       final response = await http.post(
//         ("http://92.222.201.138:9003/" + "service"),
//         headers: {
//           "Accept": "application/json",
//           "content-type": "application/json",
//         },
//         body: jsonEncode(
//           {'name': serviceName, 'lat': lat, 'long': long},
//         ),
//       );
//       var myjson = json.decode(response.body);
//       data = ServicesNet.fromJson(myjson);
//       var t = data.toJson();
//       serveput("servicesD", t["servicesArray"]);
//       makeShops();
//     } catch (SocketException) {
//       showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//                 title: Text("Network error."),
//                 actions: [
//                   MaterialButton(
//                       color: Colors.black,
//                       onPressed: () {
//                         AppSettings.openWIFISettings();
//                       },
//                       child: Text("Turn on",
//                           style: TextStyle(color: Colors.white)))
//                 ],
//               ));
//     }
//   }
// }
// //*148*1*9228#
