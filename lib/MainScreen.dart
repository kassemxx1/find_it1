import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Sub_Screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LogIn.dart';
import 'Add_post.dart';
import 'Mid_screen.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
final _firestore = Firestore.instance;
AnimationController animationController;
var heightt = 400.0;

class MainScrenn extends StatefulWidget {
  MainScrenn({this.onSignedIn});
  final VoidCallback onSignedIn;

  static var isSignedIn = false;

  static var MyPoint = GeoPoint(33.322497, 35.477090);
  static var MyLatitud = 33.322497;
  static var MyLonGitude = 35.477090;
  static const String id = 'Main_Screen';
  static var cat = "";
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  _MainScrennState createState() => _MainScrennState();
}

class _MainScrennState extends State<MainScrenn>
    with SingleTickerProviderStateMixin {
  void getCurrentPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    MainScrenn.MyLatitud = position.latitude;
    MainScrenn.MyLonGitude = position.longitude;
    MainScrenn.MyPoint = GeoPoint(position.latitude, position.longitude);
  }

  Widget buildSubmitButtons() {
    if (MainScrenn.isSignedIn == false) {

        return Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Login', style: TextStyle(fontSize: 20.0)),
              onPressed: validateAndSubmit,
            ),
            RaisedButton(
              child: Text('Add Post', style: TextStyle(fontSize: 20.0)),
              onPressed: (){
                Navigator.pushNamed(context, AddPost.id);

              },
            ),


          ],
        );

    } else {

        return Column(
          children: <Widget>[
            RaisedButton(
              child: Text('SignOut', style: TextStyle(fontSize: 20.0)),
              onPressed: validateAndSubmit,
            ),
            RaisedButton(
              child: Text('Add Post', style: TextStyle(fontSize: 20.0)),
              onPressed: (){
                Navigator.pushNamed(context, AddPost.id);

              },
            ),
          ],
        );
    }
  }

  Future<void> validateAndSubmit() async {
    try {
      if (MainScrenn.isSignedIn == false) {
        Navigator.pushNamed(context, LoginScreen.id);
      } else {
        _auth.signOut();
        setState(() {
          MainScrenn.isSignedIn=false;
        });

      }

    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buildSubmitButtons();
    print(MainScrenn.isSignedIn);
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child:Column(
            children: <Widget>[
              DrawerHeader(
                  child: null,
              ),

              buildSubmitButtons(),
            ],
          )
        ),
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
  void getCurrentPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    MainScrenn.MyLatitud = position.latitude;
    MainScrenn.MyLonGitude = position.longitude;
  }

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
              expandedHeight: MediaQuery.of(context).size.height / 3,
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
                    onPressed: () {
                      getCurrentPosition();
                      MainScrenn.cat = ListOfCategoires[index]['subcategories'];
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new MidScreen()));
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
                        )),
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
