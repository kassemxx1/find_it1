import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Subcategories.dart';
import 'Sub_Screen.dart';


final _firestore = Firestore.instance;

class MainScrenn extends StatefulWidget {
  static const String id = 'Main_Screen';
  static final subcat=List<String>();
  @override
  _MainScrennState createState() => _MainScrennState();
}

class _MainScrennState extends State<MainScrenn> {
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

  var height = 300;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          getcatgorie('70385816');
          print(MainScrenn.subcat);
          Navigator.pushNamed(context, Sub.id);

        }),
        body: CustomScrollView(
          slivers: <Widget>[
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
            SliverFixedExtentList(
              delegate: SliverChildListDelegate(
                [StreamData()],
              ),
              itemExtent: 500,
            ),
          ],
        ),
      ),
    );
  }
}

class StreamData extends StatelessWidget {
  var ListOfCategoires = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('categories').snapshots(),
      builder: (context, snapshot) {
        ListOfCategoires.clear();

        for (var doc in snapshot.data.documents) {
          final subcat = doc['subcategories'].toString();
          final imagelink = doc['image'].toString();
          ListOfCategoires.add({
            'subcategories': subcat,
            'imagelink': imagelink,
          });
        }
        return GridView.builder(
            itemCount: ListOfCategoires.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.4),
            ),
            itemBuilder: (BuildContext context, int index) {
              return MaterialButton(
                child: cards(ListOfCategoires[index]['subcategories'],
                    ListOfCategoires[index]['imagelink']),
                onPressed: () {
                getcatgorie(ListOfCategoires[index]['subcategories']);
                  Navigator.pushNamed(context, Sub.id);
                },
              );
            });
      },
    );
  }
}

class cards extends StatelessWidget {
  cards(this.categorie, this.imageLink);
  final String categorie;
  final String imageLink;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: imageLink,
          fit: BoxFit.fill,
        ),
        Text(categorie),
      ],
    );
  }
}
class getcatgorie extends StatelessWidget {
  final String cat;
  getcatgorie(this.cat);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('subcategories').where('phone',isEqualTo: cat).snapshots(),
      builder: (context, snapshot) {
        MainScrenn.subcat.clear();

        for (var doc in snapshot.data.documents) {
          final subcat = doc['title'].toString();
//          final imagelink = doc['image'].toString();
          print(subcat);
          MainScrenn.subcat.add(subcat);
        }
      },
    );
  }
}
