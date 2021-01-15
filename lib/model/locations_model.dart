import 'package:flutter_google_maps/flutter_google_maps.dart';

import 'package:hive/hive.dart';

class ServiceProvider {
  int rank;
  String shopName;
  String address;
  String description;
  String thumbNail;
  String contact;
  GeoCoord locationCoords;

  ServiceProvider(
      {this.rank,
      this.shopName,
      this.address,
      this.description,
      this.thumbNail,
      this.contact,
      this.locationCoords});
}

//get form db
void makeShops() async {
  List<ServiceProvider> serviceProviderShop = [];
  var serveBox = Hive.box("serves");
  List<dynamic> servicesJson = serveBox.get("servicesD", defaultValue: [
    {
      "rank": "1",
      "shopName": "No Service available",
      "address": "NhcLangata",
      "contact": "000",
      "description": "Available from 10 to 2",
      "Lat": "50.00",
      "Long": "10.00"
    }
  ]);
  //List<dynamic> servicesJson = serveBox.get("services",defaultValue:[]);
  for (dynamic s in servicesJson) {
    serviceProviderShop.add(ServiceProvider(
        rank: int.parse(s["rank"]),
        shopName: s["shopName"],
        address: s["address"],
        contact: 'tel:${s["contact"]}',
        description: s["description"],
        locationCoords:
            GeoCoord(double.parse(s["Lat"]), double.parse(s["Long"]))));
  }
}
