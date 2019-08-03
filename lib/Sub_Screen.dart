import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

final _firestore = Firestore.instance;
var items = List<String>();
var all = [{}];
var one = [{}];

class categorie extends StatefulWidget {
  static const String id = 'categorie_Screen';
  @override
  _categorieState createState() => _categorieState();
}

class _categorieState extends State<categorie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetData(),
    );
  }
}

class GetData extends StatelessWidget {
//  var currentLocation = LocationData;
  var geolocator = Geolocator();
  var distance = 0.0;
//void getlocationn(){
//  var location = new Location();
//  location.onLocationChanged().listen((LocationData currentLocation) {
//    MyLatitud=currentLocation.latitude;
//    MyLonGitude=currentLocation.longitude;
//    print(currentLocation.latitude);
//    print(currentLocation.longitude);
//  });
//
//}
  void getCurrentPosition(double X, double Y) async {
    //  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var geolocator = Geolocator();
    distance = await Geolocator()
        .distanceBetween(MainScrenn.MyLatitud, MainScrenn.MyLonGitude, X, Y);
  }

  List DetailsList = [{}];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('sub')
          .where('sub', isEqualTo: MainScrenn.cat)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DetailsList.clear();
          final messages = snapshot.data.documents;
          for (var msg in messages) {
            final title = msg.data['title'].toString();
            final phone = msg.data['phone'].toString();
            final image = msg.data['image'].toString();
            final delivery = msg.data['delivey'];
            final X = msg.data['X'];
            final Y = msg.data['Y'];
            getCurrentPosition(X, Y);

            DetailsList.add({
              'title': title,
              'phone': phone,
              'image': image,
              'delivery': delivery,
              'distance': distance,
            });
          }
        }
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 50,
              pinned: true,
              actions: <Widget>[
                ButtonBar(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.filter_list), onPressed: () {})
                  ],
                )
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    height: 150.0,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: CachedNetworkImage(
                                  imageUrl: DetailsList[index]['image']),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      DetailsList[index]['title'],
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                Align(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlutterRatingBarIndicator(
                                      rating: 2.5,
                                      itemCount: 5,
                                      itemSize: 25.0,
                                      emptyColor: Colors.grey[400],
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: ,
                                )

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: DetailsList.length,

                // Or, uncomment the following line:
                // childCount: 3,
              ),
            ),
          ],
        );
      },
    );
  }
}
