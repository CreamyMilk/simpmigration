import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

class Coffee {
  int rank;
  String shopName;
  String address;
  String description;
  String thumbNail;
  String contact;
  LatLng locationCoords;

  Coffee(
      {this.rank,
      this.shopName,
      this.address,
      this.description,
      this.thumbNail,
      this.contact,
      this.locationCoords});
}
List<Coffee> coffeeShops ;
Future<List<Marker>> 
//get form db
makeShops() async {
  List<Coffee> coffeeShop = [];
  var serveBox = Hive.box("serves");
  List<dynamic> servicesJson = serveBox.get("servicesD",defaultValue:[{
    "rank":"1",
    "shopName":"No Service available",
    "address":"NhcLangata",
    "contact":"0797678252",
    "description":"Available from 10 to 2",
    "Lat":"50.00",
    "Long":"10.00"
  }]);
  //List<dynamic> servicesJson = serveBox.get("services",defaultValue:[]);
  for(dynamic s in servicesJson){ 
  coffeeShop.add(Coffee(
      rank: int.parse(s["rank"]),
      shopName: s["shopName"],
      address: s["address"],
      contact: 'tel:${s["contact"]}',
      description:s["description"],
      locationCoords: LatLng(double.parse(s["Lat"]), double.parse(s["Long"]))));
  }
  coffeeShops= coffeeShop;
}

final List<Coffee> coffeeShop = [
  Coffee(
      rank: 1,
      shopName: 'Stumptown Coffee Roasters',
      address: '18 W 29th St',
      //open
      contact: 'tel:254797678252',
      description:
          'Coffee bar chain offering house-roasted direct-trade coffee, along with brewing gear & whole beans',
      locationCoords: LatLng(40.745803, -73.988213),
      thumbNail:
          'https://lh5.googleusercontent.com/p/AF1QipNNzoa4RVMeOisc0vQ5m3Z7aKet5353lu0Aah0a=w90-h90-n-k-no'),
  Coffee(
      rank: 2,
      shopName: 'Andrews Coffee Shop',
      address: '463 7th Ave',
      contact: 'tel:254797678252',
      description:
          'All-day American comfort eats in a basic diner-style setting',
      locationCoords: LatLng(40.751908, -73.989804),
      thumbNail:
          'https://lh5.googleusercontent.com/p/AF1QipOfv3DSTkjsgvwCsUe_flDr4DBXneEVR1hWQCvR=w90-h90-n-k-no'),
  Coffee(
      rank: 3,
      shopName: 'Third Rail Coffee',
      address: '240 Sullivan St',
      contact: 'tel:254797678252',
      description:
          'Small spot draws serious caffeine lovers with wide selection of brews & baked goods.',
      locationCoords: LatLng(40.730148, -73.999639),
      thumbNail:
          'https://lh5.googleusercontent.com/p/AF1QipPGoxAP7eK6C44vSIx4SdhXdp78qiZz2qKp8-o1=w90-h90-n-k-no'),
  Coffee(
      rank: 4,
      shopName: 'Hi-Collar',
      address: '214 E 10th St',
      contact: 'tel:254797678252',
      description:
          'Snazzy, compact Japanese cafe showcasing high-end coffee & sandwiches, plus sake & beer at night.',
      locationCoords: LatLng(40.729515, -73.985927),
      thumbNail:
          'https://lh5.googleusercontent.com/p/AF1QipNhygtMc1wNzN4n6txZLzIhgJ-QZ044R4axyFZX=w90-h90-n-k-no'),
  Coffee(
      rank: 5,
      shopName: 'Everyman Espresso',
      address: '301 W Broadway',
      contact: 'tel:254797678252',
      description:
          'Compact coffee & espresso bar turning out drinks made from direct-trade beans in a low-key setting.',
      locationCoords: LatLng(40.721622, -74.004308),
      thumbNail:
          'https://lh5.googleusercontent.com/p/AF1QipOMNvnrTlesBJwUcVVFBqVF-KnMVlJMi7_uU6lZ=w90-h90-n-k-no')
];
