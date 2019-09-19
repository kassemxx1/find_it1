import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
Firestore _firestore=Firestore.instance;
class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: detail(),
    );
  }
}
class detail extends StatefulWidget {
  static var image='';
  static var title='';
  static var detaill='';
  static var del='';
  static var phone='';
  static var latitude=0.0;
  static var longitude=0.0;
  static var reviewnb=0;
  static var RateAverage=0.0;
  @override
  _detailState createState() => _detailState();
}

class _detailState extends State<detail> {
  var deliveryy = 'yes';
 var deliverycolor = Colors.grey;
  void getrating(String thetitle) async {
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
      setState(() {
        detail.reviewnb=ratelist.length;
        detail.RateAverage= sum / (ratelist.length);
      });

    } else {
      setState(() {
        detail.reviewnb=0;
        detail.RateAverage= 0.0;
      });

    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getrating(detail.title);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
    expandedHeight: 200,
          floating: true,

          flexibleSpace:new FlexibleSpaceBar(
            background: Container(
              child: CachedNetworkImage(imageUrl: '${detail.image}'),
            ),
            title:  Align(
                alignment: Alignment.bottomCenter,
                child: Text('${detail.title}'))
          ),
        ),
        SliverFixedExtentList(delegate: SliverChildListDelegate([
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Rating:   ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  FlutterRatingBarIndicator(
                    rating: detail.RateAverage,
                    itemCount: 5,
                    itemSize: 20.0,
                    emptyColor: Colors.grey[400],
                  ),
                  IconButton(icon: Icon(Icons.rate_review,size: 40,),
                      onPressed: (){
                    var rateNumber;
                     return showDialog(
                         context: context,
                     builder: (BuildContext context){
                       return AlertDialog(
                         elevation: 10,
                         title: Text('Rate It'),
                         content: new FlutterRatingBar(
                             initialRating: 2.5,
                             allowHalfRating: true,

                             onRatingUpdate: (rating){
                               rateNumber=rating;
                             }),
                         actions: <Widget>[
                           new FlatButton(
                             child: new Text("Close"),
                             onPressed: () {
                               Navigator.of(context).pop();
                             },
                           ),
                           new FlatButton(
                             onPressed: () async{
                               _firestore.collection('rating').add({'title':detail.title,'rating':rateNumber});
                               Navigator.of(context).pop();
                             },
                             child: new Text("Rate"),
                           ),
                         ],


                       ) ;
                     },

                     );




                  })
                ],
              ),
            ),
          ),
        ]), itemExtent: 60),
        SliverFixedExtentList(delegate: SliverChildListDelegate([
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Reviews:   (${detail.reviewnb}Reviews)',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ]), itemExtent: 40),
        SliverFixedExtentList(delegate: SliverChildListDelegate([
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width:  MediaQuery.of(context).size.width / 3,
                  child: MaterialButton(onPressed: (){
                    MapUtils.openMap(detail.latitude,detail.longitude);

                  },
                  child: Text('Locate',style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                  ),
                  color: Colors.grey[300],

                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9,
                ),
                Container(
                  color: Colors.grey[300],
                  width:  MediaQuery.of(context).size.width / 3,
                  child: MaterialButton(onPressed: (){
                    launch('tel://${detail.phone}');
                  },
                    child: Text('Call',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                )
              ],
            ),
          ),
        ]), itemExtent: 40),
        SliverFixedExtentList(delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Delivery:${detail.del}.',style: TextStyle(fontSize: 15),),
          ),
        ]), itemExtent:30),
        SliverFixedExtentList(delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Description:${detail.detaill}.',style: TextStyle(fontSize: 15),),
          ),
        ]), itemExtent:100),
      ],
    );
  }
}
class MapUtils {

  static openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}