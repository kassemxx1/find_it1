import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Sub_Screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LogIn.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
enum signForm{SignedIn,SignedOut }
final _firestore = Firestore.instance;
AnimationController animationController;
var heightt = 400.0;
Geolocator _geolocator=Geolocator();
Position _position;
class MainScrenn extends StatefulWidget {


  static var MyPoint=GeoPoint(33.322497, 35.477090);
  static var MyLatitud=33.322497;
  static var MyLonGitude=35.477090;
  static const String id = 'Main_Screen';
  static var cat = "";
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  _MainScrennState createState() => _MainScrennState();
}

class _MainScrennState extends State<MainScrenn>
    with SingleTickerProviderStateMixin {
signForm _signForm=signForm.SignedOut;
  void getCurrentPosition()async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    MainScrenn.MyLatitud=position.latitude;
    MainScrenn.MyLonGitude=position.longitude;
    MainScrenn.MyPoint =GeoPoint(position.latitude, position.longitude);

  }
  Future<FirebaseUser> getuser() async{
    return await _auth.currentUser();
  }
Future<Widget> signInForm() async{
    return Column(
      children: <Widget>[
        MaterialButton(
          child: Text('SignIn'),
          onPressed: (){
            Navigator.pushNamed(context, LoginScreen.id);

          },

        ),
      ],
    );
}
 SignOUtForm()async{
  return Column(
    children: <Widget>[
      MaterialButton(
        child: Text('SignOut'),
        onPressed: (){
          _auth.signOut();


        },

      ),
    ],
  );

}
Future<void> drawerform() async{
    if(_signForm==signForm.SignedOut) {
      return new Future (()=>  Navigator.pushNamed(context, MainScrenn.id));
    }
    if(_signForm==signForm.SignedIn){
      return new Future (()=>  _auth.signOut());
    }
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser().then((user){
      if(user !=null){
    _signForm=signForm.SignedIn;
    print('signedIn${user.phoneNumber}');
      }
    });


    getCurrentPosition();


  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
         child: FutureBuilder(
             builder: (BuildContext context ,AsyncSnapshot<void> text){
               return MaterialButton(
                 child: Text('sign'),
                 onPressed: (){
                   setState(() {
                     text.data;
                   });

                 },
               );

             },
           future: drawerform(),
         ),
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
  void getCurrentPosition()async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    MainScrenn.MyLatitud=position.latitude;
    MainScrenn.MyLonGitude=position.longitude;
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
              expandedHeight: MediaQuery.of(context).size.height/3,
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
                      getCurrentPosition();
                      MainScrenn.cat=ListOfCategoires[index]['subcategories'];
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



