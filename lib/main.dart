import 'package:clone/route_generator.dart';
import 'package:clone/services/geolocation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  final String appTitle = 'Icrib Tenant';
  final GeolocatorService geoService = GeolocatorService();
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.black38,
          scaffoldBackgroundColor: Color(0xFFF3F5F7),
        ),
        darkTheme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.black38,
          scaffoldBackgroundColor: Color(0xFFF3F5F7),
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: '/',
      );
}
