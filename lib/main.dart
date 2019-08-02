import 'package:flutter/material.dart';
import 'Subcategories.dart';
import 'MainScreen.dart';
import 'Sub_Screen.dart';
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
        SubCategories.id : (context) => SubCategories(),
        categorie.id : (context) => categorie(),

      },
    );
  }
}
