import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Subcategories.dart';
import 'Sub_Screen.dart';

final _firestore = Firestore.instance;
AnimationController animationController;
var heightt = 400.0;

class MainScrenn extends StatefulWidget {
  static const String id = 'Main_Screen';
  static var cat = "";
  @override
  _MainScrennState createState() => _MainScrennState();
}

class _MainScrennState extends State<MainScrenn>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StreamData(),
      ),
    );
  }
}

class StreamData extends StatelessWidget {


  List colrs = [
    Colors.cyan,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.grey,
    Colors.cyan,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.grey
  ];
  var ListOfCategoires = [];
  void getSub() {}
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('categories').snapshots(),
        builder: (context, snapshot) {
          ListOfCategoires.clear();
          if (snapshot.hasData) {
            final messages = snapshot.data.documents;
            for (var doc in messages) {
              final subcat = doc['subcategories'].toString();
              final imagelink = doc['image'].toString();
              ListOfCategoires.add({
                'subcategories': subcat,
                'imagelink': imagelink,
              });
            }
          }
          return CustomScrollView(slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  height: 300,
                  color: Colors.red,
                  child: Swiper(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(color: colrs[index]);
                    },
                    autoplay: true,
                    loop: true,
                  ),
                ),
              ),
            ),
            SliverFixedExtentList(
              delegate: SliverChildListDelegate(
                [
                  Material(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width,
                      child: MaterialButton(
                        onPressed: () {},
                        child: Text(
                          "Hot Deal",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        height: 60.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              itemExtent: 60,
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                ///no.of items in the horizontal axis
                crossAxisCount: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return MaterialButton(
                    onPressed: (){
                      MainScrenn.cat=ListOfCategoires[index]['subcategories'];
                      print(MainScrenn.cat);
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) =>
                          new categorie())
                      );
//                      Navigator.pushNamed(context, categorie.id);
                    },
                    child: AnimatedContainer(

                      duration: Duration(seconds: 1),
                      curve: Curves.linear,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: ListOfCategoires[index]['imagelink'],
                            fit: BoxFit.fill,
                          ),
                          Text(
                            ListOfCategoires[index]['subcategories'],
                          ),
                        ],
                      )


                    ),
                  );
                },
                childCount: ListOfCategoires.length,

                /// Set childCount to limit no.of items
                /// childCount: 100,
              ),
            )
          ]);
        });
  }
}


//class cards extends StatefulWidget {
//  cards(this.categoriee, this.imageLink);
//  final String categoriee;
//  final String imageLink;
//
//  @override
//  _cardsState createState() => _cardsState();
//}
//
//class _cardsState extends State<cards> {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialButton(
//      child: Column(
//        children: <Widget>[
//          CachedNetworkImage(
//            imageUrl: widget.imageLink,
//            fit: BoxFit.fill,
//          ),
//          Text(widget.categoriee,),
//        ],
//      ),
//      onPressed: (){
//        MainScrenn.cat=categoriee;
//        Navigator.pushNamed(context, categorie.id);
//      },
//
//    );
//  }
//}

//GridView.builder(
//
//
//itemCount: ListOfCategoires.length,
//gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//crossAxisCount: 3,
//childAspectRatio: MediaQuery.of(context).size.width /
//(MediaQuery.of(context).size.height / 1.4),
//),
//itemBuilder: (BuildContext context, int index) {
//
//
//return Container(
//child: cards(ListOfCategoires[index]['subcategories'],
//ListOfCategoires[index]['imagelink']),
//);
//});
