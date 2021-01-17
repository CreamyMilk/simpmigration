import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone/providers/gmapsProvider.dart';
import 'package:clone/widget/api_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ServicesGrid extends StatelessWidget {
  final Position cordinates;

  const ServicesGrid({Key key, @required this.cordinates}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Choose Service"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: 10),
          ServiceCategoryGrid(
            userCordinates: cordinates,
          ),
        ]),
      )),
    );
  }
}

class ServiceCategoryGrid extends StatefulWidget {
  final Position userCordinates;

  const ServiceCategoryGrid({Key key, @required this.userCordinates})
      : super(key: key);
  @override
  _ServiceCategoryGridState createState() => _ServiceCategoryGridState();
}

class _ServiceCategoryGridState extends State<ServiceCategoryGrid> {
  List<dynamic> allcategories = [
    Itemtile(
      usersPosition: Position(longitude: 10, latitude: 10),
      mapofServices: "",
      prodname: "Featured Products\n\n",
      imageUrl:
          "https://shop.twiga.ke/static/f5457552125a73157ed63cd2e498031b/8ea22/1c70ab84-5d59-455b-9c64-fc9ebc4c0f421589493611.211105.webp",
      categoryID: 9000,
    ),
    Itemtile(
      usersPosition: Position(longitude: 10, latitude: 10),
      mapofServices: "sdsd",
      prodname: "Cement \n\n",
      imageUrl:
          "https://shop.twiga.ke/static/758a50c7e869e88ff7eb52f10026a422/8ea22/0e9f0f9f-2773-4f95-b03d-7fc977a87093.webp",
      categoryID: 5000,
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      width: MediaQuery.of(context).size.width,
      child: CategoriesFutureBuilder(currentPosition: widget.userCordinates),
    );
  }
}

class CategoriesFutureBuilder extends StatelessWidget {
  final Position currentPosition;
  const CategoriesFutureBuilder({
    Key key,
    @required this.currentPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllCategories(context, currentPosition),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("${snapshot.data}");
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 3, crossAxisCount: 3, crossAxisSpacing: 3),
                padding: EdgeInsets.all(8.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Itemtile(
                      prodname: snapshot.data[index]["service_name"],
                      imageUrl: snapshot.data[index]["service_image"],
                      categoryID: snapshot.data[index]["service_id"],
                      mapofServices: snapshot.data[index],
                      usersPosition: currentPosition);
                });
          } else {
            //Make UI to act as place holder first
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          }
        });
  }
}

class Itemtile extends StatelessWidget {
  Itemtile(
      {@required this.prodname,
      @required this.imageUrl,
      @required this.categoryID,
      @required this.mapofServices,
      @required this.usersPosition});
  final String prodname;
  final String imageUrl;
  final int categoryID;
  final Position usersPosition;
  final dynamic mapofServices;

  @override
  Widget build(BuildContext context) {
    return Consumer<GMapProvider>(builder: (context, storeP, child) {
      return GridTile(
        footer: InkWell(
          onTap: () {
            storeP.makeServiceList(mapofServices);
            Navigator.of(context).pushNamed('/map', arguments: usersPosition);
          },
          child: Container(
            color: Color(0xffff2f2f2),
            child: Center(
              child: Text(
                prodname,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        child: InkWell(
          onTap: () {
            storeP.makeServiceList(mapofServices);
            Navigator.of(context).pushNamed('/map', arguments: usersPosition);
          },
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
    });
  }
}
