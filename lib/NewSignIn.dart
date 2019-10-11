import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewSign extends StatefulWidget {
  static const String id = 'NewSign';
  @override
  _NewSignState createState() => _NewSignState();
}

class _NewSignState extends State<NewSign> {
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;
  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted = (FirebaseUser user) {
      setState(() {
        print('Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
      });
    } as PhoneVerificationCompleted;

    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
      setState(() {
        print('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');}
      );
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print("code sent to " + _phoneNumberController.text);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
  void _signInWithPhoneNumber(String smsCode) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final FirebaseUser user =
      (await _auth.signInWithCredential(credential)) as FirebaseUser;

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);


      print('signed in with phone number successful: user -> $user');
    } catch (e) {
      // handleError(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
              controller:  _phoneNumberController,
            ),
            new TextField(
              controller: _smsCodeController,
            ),
            new FlatButton(
                onPressed: () => _signInWithPhoneNumber(_smsCodeController.text),
                child: const Text("Sign In")),

          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _sendCodeToPhoneNumber(),
        tooltip: 'get code',
        child: new Icon(Icons.send),
      ), // This tra
    );
  }
}
