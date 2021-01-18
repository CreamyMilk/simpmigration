import 'package:clone/archive/users_data.dart';
// import 'package:clone/enums/connectivity_status.dart';
// import 'package:clone/services/connectivity_service.dart';
import 'package:clone/services/geolocation_service.dart';
import 'package:clone/views/choose_service.dart';
import 'package:clone/views/complainsForm.dart';
import 'package:clone/views/home_cards_layouts.dart';
import 'package:clone/views/login_otp.dart';
import 'package:clone/views/maps_view.dart';
import 'package:clone/views/messageHandler.dart';

import 'package:clone/widget/otp_receiver.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

final GeolocatorService geoService = GeolocatorService();

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (ctx) => StartUpScreenProvider());
      case '/otprec':
        return CupertinoPageRoute(
            builder: (ctx) => OtpReceiver(phonenumber: args));
      case '/randomUser':
        return MaterialPageRoute(builder: (ctx) => UserTest(appTitle: 'ok'));
      case '/map':
        return MaterialPageRoute(
            builder: (ctx) => MapSample(initialPosition: args));
      case '/login':
        return MaterialPageRoute(builder: (ctx) => LoginOTP());
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

class StartUpScreenProvider extends StatelessWidget {
  const StartUpScreenProvider({Key key}) : super(key: key);
  // v2 use the connectivity package for all api negotions
  @override
  Widget build(BuildContext context) {
    return MyMessageHandler();
    // return MultiProvider(providers: [
    //   StreamProvider<ConnectivityStatus>(
    //       create: (context) =>
    //           ConnectivityService().connectionStatusController.stream),
    // ], child: MyMessageHandler());
  }
}

class LoginRouter extends StatelessWidget {
  const LoginRouter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      FutureProvider<Position>(
          create: (context) => geoService.getInitialLocation()),
    ], child: LoginOTP());
  }
}
