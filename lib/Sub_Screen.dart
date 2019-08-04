import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:dio/dio.dart';
import 'package:google_api_availability/google_api_availability.dart';
final _firestore = Firestore.instance;
var items = List<String>();
var all = [{}];
var one = [{}];
   var geolocator = Geolocator();
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
  var distance ;
  Dio dio = new Dio();
  Response response;
  String API_KEY_android='AIzaSyCcgNqHPXujEYpRy1BntzZ1wzp4eblTW-Y';
  String API_KEY_IOS='AIzaSyCETClMi4OZeBmRZ7uJMRLhBUAYZKNxOvs';

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
  void getdistance(double x, double y) async {
    //  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
 //   var geolocator = Geolocator();
 distance = await geolocator
        .distanceBetween(MainScrenn.MyLatitud, MainScrenn.MyLonGitude, x, y);


  }
  void getresponse(String x1,String y1,String x2,String y2 )async{
  String  API_KEY='';
    if(TargetPlatform.iOS==true){
      API_KEY=API_KEY_IOS;
    }
    else {
      API_KEY=API_KEY_android;
    }
  String url='https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins={${x1.toString()}},{${y1.toString()}}&destinations={${x2.toString()}%2C},{${y2.toString()}}&key=$API_KEY_IOS';
print(url);
  response=await dio.get(url);
  print(response.data);
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
            final delivery = msg.data['delivery'] as bool;
            final X = msg.data['X'];
            final Y = msg.data['Y'];
            var deliveryy='yes';
            var deliverycolor=Colors.grey;
            print(MainScrenn.MyLatitud);

            delivery==true ? deliveryy='yes':deliveryy='No';
            delivery==true ? deliverycolor=Colors.green:deliverycolor=Colors.red;
            getresponse(MainScrenn.MyLatitud.toString(),MainScrenn.MyLonGitude.toString(),'36.8899983','33.2999983');


            DetailsList.add({
              'title': title,
              'phone': phone,
              'image': image,
              'delivery': deliveryy,
              'distance': 0,
              'deliverycolor':deliverycolor,
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
                    height: 120.0,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.8,
                              child: CachedNetworkImage(
                                  imageUrl:'${DetailsList[index]['image']}' ),
                            ),
                          ),
                        ),
                        Wrap(
                          children:[ Container(
                              child: Column(
                                children: <Widget>[
                                  Align(
//                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Align(

                                              child: Text(
                                                '${DetailsList[index]['title']}',
                                                style: TextStyle(
                                                  fontSize: 25.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              alignment: Alignment.topLeft,
                                            ),
                                            Align(
                                              child: Text(
                                                '${DetailsList[index]['distance']}',
                                                style: TextStyle(
                                                  fontSize: 25.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  Align(
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: FlutterRatingBarIndicator(
                                        rating: 2.5,
                                        itemCount: 5,
                                        itemSize: 15.0,
                                        emptyColor: Colors.grey[400],
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),

                                  Align(

                                    child: Wrap(
                                      children:[ Row(
                                        children: <Widget>[
                                          MaterialButton(
                                            onPressed: (){},
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.phone),
                                                Text('${DetailsList[index]['phone']}',)
                                              ],
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text('Delivery : ${DetailsList[index]['delivery']}',
                                              style: TextStyle(color: DetailsList[index]['deliverycolor']
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                            ],
                                    ),
                                  ),

                                ],
                              ),

                          ),
                  ]
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
