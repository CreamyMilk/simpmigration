import 'package:clone/model/locations_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMapProvider extends ChangeNotifier {
  List<ServiceProvider> serviceProviderShops = [
    ServiceProvider(
        rank: 1,
        shopName: 'Stumptown ServiceProvider Roasters',
        address: '18 W 29th St',
        contact: 'tel:254797678252',
        description:
            'ServiceProvider bar chain offering house-roasted direct-trade ServiceProvider, along with brewing gear & whole beans',
        locationCoords: LatLng(40.745803, -73.988213),
        thumbNail:
            'https://lh5.googleusercontent.com/p/AF1QipNNzoa4RVMeOisc0vQ5m3Z7aKet5353lu0Aah0a=w90-h90-n-k-no'),
    ServiceProvider(
        rank: 2,
        shopName: 'Andrews ServiceProvider Shop',
        address: '463 7th Ave',
        contact: 'tel:254797678252',
        description:
            'All-day American comfort eats in a basic diner-style setting',
        locationCoords: LatLng(40.751908, -73.989804),
        thumbNail:
            'https://lh5.googleusercontent.com/p/AF1QipOfv3DSTkjsgvwCsUe_flDr4DBXneEVR1hWQCvR=w90-h90-n-k-no'),
    ServiceProvider(
        rank: 3,
        shopName: 'Third Rail ServiceProvider',
        address: '240 Sullivan St',
        contact: 'tel:254797678252',
        description:
            'Small spot draws serious caffeine lovers with wide selection of brews & baked goods.',
        locationCoords: LatLng(40.730148, -73.999639),
        thumbNail:
            'https://lh5.googleusercontent.com/p/AF1QipPGoxAP7eK6C44vSIx4SdhXdp78qiZz2qKp8-o1=w90-h90-n-k-no'),
    ServiceProvider(
        rank: 4,
        shopName: 'Hi-Collar',
        address: '214 E 10th St',
        contact: 'tel:254797678252',
        description:
            'Snazzy, compact Japanese cafe showcasing high-end ServiceProvider & sandwiches, plus sake & beer at night.',
        locationCoords: LatLng(40.729515, -73.985927),
        thumbNail:
            'https://lh5.googleusercontent.com/p/AF1QipNhygtMc1wNzN4n6txZLzIhgJ-QZ044R4axyFZX=w90-h90-n-k-no'),
    ServiceProvider(
        rank: 5,
        shopName: 'Everyman Espresso',
        address: '301 W Broadway',
        contact: 'tel:254797678252',
        description:
            'Compact ServiceProvider & espresso bar turning out drinks made from direct-trade beans in a low-key setting.',
        locationCoords: LatLng(40.721622, -74.004308),
        thumbNail:
            'https://lh5.googleusercontent.com/p/AF1QipOMNvnrTlesBJwUcVVFBqVF-KnMVlJMi7_uU6lZ=w90-h90-n-k-no')
  ];
  List<Marker> markers = [
    Marker(
      position: LatLng(34.0469058, -118.3503948),
      markerId: MarkerId("sd"),
    ),
    Marker(
      position: LatLng(30.0469058, -108.3503948),
      markerId: MarkerId("sdwewe"),
    )
  ];
  bool showTrans = true;

  void addMarker(double x, double y) {
    markers.add(
      Marker(
        markerId: MarkerId("$x/$y"),
        position: LatLng(x, y),
      ),
    );
    notifyListeners();
  }

  void addStoredMarkers(PageController pcon) {
    serviceProviderShops.forEach((element) {
      markers.add(
        Marker(
          markerId: MarkerId(element.shopName),
          position: element.locationCoords,
          infoWindow: InfoWindow(
            title: element.shopName,
            snippet: element.address,
            onTap: () {
              pcon.animateToPage(element.rank - 1,
                  duration: Duration(microseconds: 900),
                  curve: Curves.decelerate);
            },
          ),
        ),
      );
    });
    notifyListeners();
  }

  void switchElec() {
    showTrans = false;
    notifyListeners();
  }

  void switchRents() {
    showTrans = true;
    notifyListeners();
  }
}
