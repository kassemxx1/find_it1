import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
final _firestore = Firestore.instance;
var items = List<String>();
var all=[{}];
var one=[{}];
class Sub extends StatefulWidget {
  static const String id = 'Sub_Screen';
  static  String catt;
  var itemm = List<String>();
  static var duplicateItems = List<String>();
  String title;
  @override
  _SubState createState() => _SubState();
}

class _SubState extends State<Sub> {
  TextEditingController editingController = TextEditingController();

@override
  void initState() {
    items.addAll(MainScrenn.subcat);

    super.initState();
    getsub();
    print(one);

  }
  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(Sub.duplicateItems);
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if(item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(Sub.duplicateItems);
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('FindIt'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: getsub(),
            ),
          ],
        ),
      ),
    );
  }
}
class getsub extends StatefulWidget {

  @override
  _getsubState createState() => _getsubState();
}

class _getsubState extends State<getsub> {
  void filterr(String name){
    for (int i=0;i<all.length;i++){
      if ( name == all[i]['title']){
        one.add(all[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:_firestore.collection('sub').where('sub',isEqualTo: Sub.catt).snapshots(),
        builder: (context,snapshot){
          Sub.duplicateItems.clear();
          for(var msg in snapshot.data.documents){
            final name =msg['title'].toString();
            final sub =msg['sub'].toString();
            final isdelivery=msg['delivery'];
            final image = msg['image'].toString();
           Sub.duplicateItems.add(name);
           all.add({
             'title':name,
             'sub':sub,
             'delivery': isdelivery,
             'image':image,
           });
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              filterr(items[index]);
              return ListTile(
                title: Text('${one[index]['title']}'),
                leading: CachedNetworkImage(imageUrl: '${one[index]['image']}'),
              );
            },
          );
        },
    );
  }
}
