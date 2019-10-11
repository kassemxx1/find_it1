import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
final _firestore = Firestore.instance;
class UserProfile extends StatefulWidget {
  static const String id = 'User_Profile';
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseUser user;
  var Name = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUserInfo();
  }
  void GetUserInfo() async{
    user = await _auth.currentUser();
//    print(user.uid);
//    print(user.displayName);
    final messages= await _firestore.collection('users').where('uid',isEqualTo: user.uid).getDocuments();
    print(messages.documents.length);
    if (messages.documents.length==0) {

        await _firestore.collection('users').add({'uid':user.uid});


    }
    else{
    for (var msg in messages.documents){
      final name = msg.data['name'];
      setState(() {
        Name = name;
      });



    }

  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

      ),
    );
  }
}
