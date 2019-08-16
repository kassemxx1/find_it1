import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final Firestore _firestore=Firestore.instance;
class AddPost extends StatefulWidget {
  static const String id = 'AddPost_Screen';
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var radiovalue=0;
  var delivery=false;
  var title ='';
  var PhoneNumber='';
  void _handeleRadio(int value){
    setState(() {
      radiovalue=value;
      switch(radiovalue){
        case 0 :
          delivery = false;
          break;
        case 1:
          delivery = true;
          break;
      }
      print(delivery);

    });
  }
  void getcategories(){
   final messages = _firestore.collection('categories').getDocuments();



    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter The Title',
            ),
            onChanged: (value){
              setState(() {
                title=value;
              });

            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter The Phone Number',
            ),
            onChanged: (value){
              setState(() {
                PhoneNumber=value;
              });

            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Delivery:  '),
              Text('No'),
              Radio(
                  value: 0,
                  groupValue: radiovalue,
                  onChanged: _handeleRadio,
              ),
              Text('yes'),
              Radio(
                value: 1,
                groupValue: radiovalue,
                onChanged: _handeleRadio,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
