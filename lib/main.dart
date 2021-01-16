import 'package:clone/providers/gmapsProvider.dart';
import 'package:clone/providers/list_switcher_provider.dart';
import 'package:clone/route_generator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:clone/services/geolocation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

const userBoxName = 'user';
FirebaseAnalytics analytics;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    WidgetsFlutterBinding.ensureInitialized();
    analytics = FirebaseAnalytics();
    await Hive.initFlutter();
    await Hive.openBox('user');
    await Hive.openBox('serves');
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final String appTitle = 'Icrib Tenant';
  final GeolocatorService geoService = GeolocatorService();
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<ListSwitcherProvider>(
              create: (context) => ListSwitcherProvider()),
          ChangeNotifierProvider<GMapProvider>(
              create: (context) => GMapProvider()),
        ],
        child: MaterialApp(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.black,
            accentColor: Colors.black38,
            scaffoldBackgroundColor: Color(0xFFF3F5F7),
          ),
          darkTheme: ThemeData(
            //   textTheme: Theme.of(context).textTheme.apply(
            //   fontSizeFactor: 0.75,
            //   fontSizeDelta: 1.0,
            // ),
            primaryColor: Colors.black,
            accentColor: Colors.black38,
            scaffoldBackgroundColor: Color(0xFFF3F5F7),
          ),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/',
        ),
      );
}
