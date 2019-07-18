import 'package:flutter/material.dart';
import 'MainScreen.dart';
void main() => runApp(Find_it());
class Find_it extends StatefulWidget {

  @override
  _Find_itState createState() => _Find_itState();
}

class _Find_itState extends State<Find_it> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MainScrenn.id,
      routes: {
        MainScrenn.id : (context) => MainScrenn(),
      },
    );
  }
}
