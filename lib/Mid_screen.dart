import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MainScreen.dart';
import 'Sub_Screen.dart';
Firestore _firestore=Firestore.instance;
class MidScreen extends StatefulWidget {
  static const String id = 'Mid_Screen';
  static var cat = "";
  @override
  _MidScreenState createState() => _MidScreenState();
}

class _MidScreenState extends State<MidScreen> {
  var MidList = ['Null'];
  void getMid() async {
    MidList.clear();
 final messages = await _firestore.collection('mid').where('cat',isEqualTo: MainScrenn.cat).getDocuments();
    for (var msg in messages.documents){
      final mid = msg.data['sub'].toString();
      setState(() {
        MidList.add(mid);
      });

    }


}
@override
  void initState() {
    // TODO: implement initState
  getMid();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(

            delegate: SliverChildBuilderDelegate(
                (BuildContext context,int index) {
                  return Container(
                    height: 40,
                    child: Center(
                      child: GestureDetector(

                        onTap: (){
                          MidScreen.cat = MidList[index];
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new categorie()));
                        },
                        child: Text(MidList[index],style: TextStyle(
                          fontSize: 20,
                        ),),

                      ),
                    ),
                  );
                },
                childCount: MidList.length,
            ),


          ),

        ],
      ),
    );
  }
}
