import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
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
class detail extends StatelessWidget {
  static var image='';
  static var title='';
  static var detaill='';
  static var del='true';
  static var phone='';
  static var latitude=0.0;
  static var longitude=0.0;






  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
    expandedHeight: 200,
          floating: true,

          flexibleSpace:new FlexibleSpaceBar(
            background: Container(
              child: CachedNetworkImage(imageUrl: '$image'),
            ),
            title:  Align(
                alignment: Alignment.bottomCenter,
                child: Text('$title',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 35),))
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
                    rating: 2.5,
                    itemCount: 5,
                    itemSize: 30.0,
                    emptyColor: Colors.grey[400],
                  ),
                  IconButton(icon: Icon(Icons.rate_review,size: 40,), onPressed: (){

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
                Text('Reviews:   (Reviews)',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                    MapUtils.openMap(latitude,longitude);

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
                    launch('tel://$phone');

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
            child: Text('Delivery : $del',style: TextStyle(fontSize: 25,color: detail.del=='true'?Colors.green:Colors.red,fontWeight: FontWeight.bold)),
          ),
        ]), itemExtent:50),
        SliverFixedExtentList(delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Description:$detaill.',style: TextStyle(fontSize: 20),),
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