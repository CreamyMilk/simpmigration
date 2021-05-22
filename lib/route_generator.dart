import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpmigration/services/geolocation_service.dart';
import 'package:simpmigration/views/choose_service.dart';
import 'package:simpmigration/views/complainsForm.dart';
import 'package:simpmigration/views/home_cards_layouts.dart';
import 'package:simpmigration/views/login_otp.dart';
import 'package:simpmigration/views/logoPage.dart';
import 'package:simpmigration/views/maps_view.dart';
import 'package:simpmigration/widget/otp_receiver.dart';

final GeolocatorService geoService = GeolocatorService();

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (ctx) => LogoPage());
      case '/login':
        return MaterialPageRoute(builder: (ctx) => LoginOTP());
      case '/otprec':
        return CupertinoPageRoute(
            builder: (ctx) => OtpReceiver(phonenumber: args));
      case '/home':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondAnimation) {
            return ListenableProvider(
                create: (context) => animation,
                child: HomeViewCardLayout(
                  transitionAnime: animation,
                ));
          },
          transitionDuration: const Duration(seconds: 2),
        );
      case '/map':
        return MaterialPageRoute(
            builder: (ctx) => MapSample(initialPosition: args));
      case '/services':
        return MaterialPageRoute(
            builder: (ctx) => ServicesGrid(
                  cordinates: args,
                ));

      case '/complain':
        return MaterialPageRoute(
            builder: (ctx) => ComplainsForm(
                  title: args,
                ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
