import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dio/dio.dart';

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

class GetData extends StatefulWidget {
//  var currentLocation = LocationData;
  @override
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  var geolocator = Geolocator();
  var distance = '';
  var duration = '';
  Dio dio = new Dio();
  Response response;
  String API_KEY_android = 'AIzaSyCcgNqHPXujEYpRy1BntzZ1wzp4eblTW-Y';
  String API_KEY_IOS = 'AIzaSyCETClMi4OZeBmRZ7uJMRLhBUAYZKNxOvs';

  Future getresponse(String x1, String y1, String x2, String y2) async {
    String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${x1.toString()},${y1.toString()}&destinations=${x2.toString()},${y2.toString()}&key=$API_KEY_IOS';

    response = await dio.get(url);
    setState(() {
      distance = response.data['rows'][0]['elements'][0]['distance']['text'];
      duration = response.data['rows'][0]['elements'][0]['duration']['text'];
    });

    print(duration);
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
            final point = msg.data['location'] as GeoPoint;
            final al = point.latitude;
            final lon = point.longitude;
            final X = msg.data['X'];
            final Y = msg.data['Y'];
            var deliveryy = 'yes';
            var deliverycolor = Colors.grey;
            print(MainScrenn.MyLatitud);
            final dddd = '99999999';
            delivery == true ? deliveryy = 'yes' : deliveryy = 'No';
            delivery == true
                ? deliverycolor = Colors.green
                : deliverycolor = Colors.red;
            print(getresponse('33.3224968977418', '35.47709048134694',
                '33.22932992335729', '35.52890069414021'));

            DetailsList.add({
              'title': title,
              'phone': phone,
              'image': image,
              'delivery': deliveryy,
              'distance': distance,
              'deliverycolor': deliverycolor,
            });
          }
          DetailsList.sort((a, b) {
            return a['title'].compareTo(b['title']);
          });
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
                                  imageUrl: '${DetailsList[index]['image']}'),
                            ),
                          ),
                        ),
                        Wrap(children: [
                          Container(
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
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              'Delivery : ${DetailsList[index]['delivery']}',
                                              style: TextStyle(
                                                  color: DetailsList[index]
                                                      ['deliverycolor']),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Align(
                                            child: Column(
                                              children: <Widget>[
                                                Text('Distance: $distance'),
                                                Text('Duration: $duration'),
                                              ],
                                            ),
                                            alignment: Alignment.bottomRight,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
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
