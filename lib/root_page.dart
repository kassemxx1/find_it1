import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MainScreen.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
class RootPage extends StatefulWidget {
  static const String id = 'Root_Screen';

  @override
  _RootPageState createState() => _RootPageState();
}
enum AuthStatus {

  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  Future<FirebaseUser> getuser() async{
    return await _auth.currentUser();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getuser().then((user){
      if(user !=null){
        setState(() {
          authStatus=AuthStatus.signedIn;
          MainScrenn.isSignedIn=true;
        });

      }
      else{
        authStatus=AuthStatus.notSignedIn;
        MainScrenn.isSignedIn=false;
      }
    });
  }
  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
      MainScrenn.isSignedIn=true;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
      MainScrenn.isSignedIn=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch (authStatus) {

      case AuthStatus.notSignedIn:
        return MainScrenn(
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return MainScrenn(
          onSignedIn: _signedOut,
        );
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
