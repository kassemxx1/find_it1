import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: detail(),
    );
  }
}
class detail extends StatelessWidget {
  static var image='';
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
    expandedHeight: 200,
          floating: true,

          flexibleSpace:new FlexibleSpaceBar(
            background: Container(
              child: CachedNetworkImage(imageUrl: '$image'),
            ),
          ),
        )
      ],
    );
  }
}
