import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dio/dio.dart';
import 'Details_Screen.dart';
import 'Mid_screen.dart';
import 'dart:math' show cos, sqrt, asin;

final _firestore = Firestore.instance;
var items = List<String>();
var all = [{}];
var one = [{}];
var geolocator = Geolocator();

class categorie extends StatefulWidget {
  static const String id = 'categorie_Screen';
  static List DetailsList = [{}];
  @override
  _categorieState createState() => _categorieState();
}
double calculateDistance(double lat1,double lon1,double lat2,double lon2){
  var p = 0.017453292519943295;
 // var c = cos;
  var a = 0.5 - cos((lat2 - lat1) * p)/2 +
      cos(lat1 * p) * cos(lat2 * p) *
          (1 - cos((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}


class _categorieState extends State<categorie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetData(),
    );
  }
}

class GetData extends StatefulWidget {
//  var currentLocation = LocationData;
  @override
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  @override
  List headers = [];
  var geolocator = Geolocator();

  Dio dio = new Dio();

  Response response;
  String API_KEY_android = 'AIzaSyCcgNqHPXujEYpRy1BntzZ1wzp4eblTW-Y';
  String API_KEY_IOS = 'AIzaSyBBnhAuFuduAMQu5u30xsDzbS6Um0qVNvE';
//
//  Future<String> getresponse(int i)  async{
//  //  calculateDistance(MainScrenn.MyLatitud, MainScrenn.MyLonGitude, categorie.DetailsList[i]['latitude'], categorie.DetailsList[i]['longitude']);
//    var distance;
//  distance =  await '${calculateDistance(MainScrenn.MyLatitud, MainScrenn.MyLonGitude, categorie.DetailsList[i]['latitude'], categorie.DetailsList[i]['longitude'])}';
////    var duration = 'null';
////    String url =
////        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${MainScrenn.MyLatitud},${MainScrenn.MyLonGitude}&destinations=${categorie.DetailsList[i]['latitude']},${categorie.DetailsList[i]['longitude']}&key=$API_KEY_IOS';
////
////    response = await dio.get(url);
////    print(url);
////
////    distance = response.data['rows'][0]['elements'][0]['distance']['text'];
////    duration = response.data['rows'][0]['elements'][0]['duration']['text'];
////
////    return new Future(() => '${distance.toString()}    ${duration.toString()}');
//    return new Future(() => '${distance.toString()} KM');
//  }

  Future<double> getrating(String thetitle) async {
    var ratelist = [
      {'rating': 0.0}
    ];

    final messages = await _firestore
        .collection('rating')
        .where('title', isEqualTo: thetitle)
        .getDocuments();
    ratelist.clear();
    var sum = 0.0;
    for (var msg in messages.documents) {
      final rating = msg.data['rating'].toDouble();
      ratelist.add({'rating': rating});
    }
    if (ratelist.length > 0) {
      for (var j in ratelist) {
        var i = j['rating'].toDouble();
        sum = sum + i;
      }
      return new Future(() => sum / (ratelist.length));
    } else {
      return new Future(() => 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('sub')
          .where('sub', isEqualTo: MidScreen.cat)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          categorie.DetailsList.clear();
          final messages = snapshot.data.documents;
          for (var msg in messages) {
            final title = msg.data['title'].toString();
            final phone = msg.data['phone'].toString();
            final image = msg.data['image'].toString();
            final delivery = msg.data['delivery'] as bool;
            final point = msg.data['location'] as GeoPoint;
            final al = point.latitude;
            final lon = point.longitude;
            var deliveryy = 'yes';
            var deliverycolor = Colors.grey;
            print(MainScrenn.MyLatitud);
            delivery == true ? deliveryy = 'yes' : deliveryy = 'No';
            delivery == true
                ? deliverycolor = Colors.green
                : deliverycolor = Colors.red;
            categorie.DetailsList.add({
              'title': title,
              'phone': phone,
              'image': image,
              'delivery': deliveryy,
              'deliverycolor': deliverycolor,
              'latitude': al,
              'longitude': lon,
            });
            headers.add(title);
          }
          categorie.DetailsList.sort((a, b) {
            return a['title'].compareTo(b['title']);
          });
        }
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 50,
              pinned: true,
              actions: <Widget>[
                IconButton(
                    icon: IconButton(
                        icon: Icon(Icons.time_to_leave),
                        onPressed: () {
                          setState(() {
                            categorie.DetailsList.sort((a, b) {
                              return a['distance'].compareTo(b['distance']);
                            });
                          });
                        })),
                IconButton(
                    icon: IconButton(
                        icon: Icon(Icons.sort_by_alpha),
                        onPressed: () {
                          setState(() {
                            categorie.DetailsList.sort((a, b) {
                              return a['title'].compareTo(b['title']);
                            });
                          });
                        })),
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      detail.image = categorie.DetailsList[index]['image'];
                      detail.title = categorie.DetailsList[index]['title'];
                      detail.detaill = categorie.DetailsList[index]['detail'];
                      detail.del = categorie.DetailsList[index]['delivery'];
                      detail.phone = categorie.DetailsList[index]['phone'];
                      detail.latitude =
                          categorie.DetailsList[index]['latitude'];
                      detail.latitude =
                          categorie.DetailsList[index]['longitude'];

                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => DetailsScreen()));
                    },
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      height: MediaQuery.of(context).size.height / 4.9,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              child: CachedNetworkImage(
                                  imageUrl:
                                      '${categorie.DetailsList[index]['image']}'),
                            ),
                            Flexible(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: Center(
                                        child: Stack(
                                          children: <Widget>[
                                            Positioned(
                                              left: 5,
                                              top: 5,
                                              child: Text(
                                                '${categorie.DetailsList[index]['title']}',
                                                style: TextStyle(
                                                  fontSize: 25.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 5,
                                              top: 10,
                                              child: Text(
                                                'Delivery : ${categorie.DetailsList[index]['delivery']}',
                                                style: TextStyle(
                                                  color: categorie
                                                          .DetailsList[index]
                                                      ['deliverycolor'],
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: FutureBuilder(
                                        builder: (BuildContext context,
                                            AsyncSnapshot<double> ratenumber) {
                                          return Center(
                                            child: FlutterRatingBarIndicator(
                                              rating: ratenumber.data,
                                              itemCount: 5,
                                              itemSize: 25.0,
                                              emptyColor: Colors.grey[400],
                                            ),
                                          );
                                        },
                                        initialData: 0.0,
                                        future: getrating(
                                            '${categorie.DetailsList[index]['title']}'),
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: Container(
//                                        child: FutureBuilder(
//                                          builder: (BuildContext context,
//                                              AsyncSnapshot<String> text) {
//                                            return new Text(
//                                              '${text.data}',
//                                              style: TextStyle(
//                                                fontWeight: FontWeight.bold,
//                                                color: Colors.black,
//                                                fontSize: 15,
//                                              ),
//                                            );
//                                          },
//                                          initialData: 'loading',
//                                          future: getresponse(index),
//                                        ),
                                      child: Text('Distance: ${(calculateDistance(MainScrenn.MyLatitud, MainScrenn.MyLonGitude, categorie.DetailsList[index]['latitude'], categorie.DetailsList[index]['longitude'])).round().toString()} KM',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: categorie.DetailsList.length,

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
