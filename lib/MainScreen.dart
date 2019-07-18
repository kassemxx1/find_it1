import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
final _firestore = Firestore.instance;
class MainScrenn extends StatefulWidget {
  static const String id = 'Main_Screen';
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
  var ListOfCategoires =[];
  var height = 300;

  void GetCategories() async {
    ListOfCategoires.clear();
    final messages = await _firestore.collection('categories').getDocuments();
    for (var message in messages.documents) {
      final title = message.data['subcategories'].toString();
      final imagename = message.data['image'].toString();

      ListOfCategoires.add({
        'title': title,
        'image': imagename,
      });
      ListOfCategoires.add(title);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetCategories();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                [
                  GridView.builder(
                      itemCount: 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.4),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            CachedNetworkImage(imageUrl: ListOfCategoires[index]['image'],fit: BoxFit.fill,),
                            Text(ListOfCategoires[index]['title']),
                          ],
                        );
                      }),
                ],
              ),
              itemExtent: 600,
            ),
          ],
        ),
      ),
    );
  }
}
