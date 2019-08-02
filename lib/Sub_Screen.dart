import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
final _firestore = Firestore.instance;
var items = List<String>();
var all=[{}];
var one=[{}];
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
  var MyLatitud=0.0;
  var MyLonGitude=0.0;
  var distance=0.0;
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
  void getCurrentPosition(double X,double Y)async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    MyLatitud=position.latitude;
    MyLonGitude=position.longitude;
    var geolocator = Geolocator();
    distance= await Geolocator().distanceBetween(MyLatitud, MyLonGitude, X, Y);

  }

  List DetailsList =[{}];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('sub').where('sub',isEqualTo: MainScrenn.cat).snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          DetailsList.clear();
          final messages=snapshot.data.documents;
          for(var msg in messages){
            final title= msg.data['title'].toString();
            final phone= msg.data['phone'].toString();
            final image= msg.data['image'].toString();
            final delivery= msg.data['delivey'];
            final X= msg.data['X'];
            final Y= msg.data['Y'];
            getCurrentPosition(X, Y);

          DetailsList.add({
            'title':title,
            'phone':phone,
            'image':image,
            'delivery':delivery,
            'distance':distance,

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
                    IconButton(
                        icon: Icon(Icons.filter_list), onPressed:(){
                    })
                  ],
                )
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                return ListTile(
                  leading: CachedNetworkImage(imageUrl: '${DetailsList[index]['image']}'),
                  title: Text('${DetailsList[index]['title']}  ${DetailsList[index]['distance']}'),

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
