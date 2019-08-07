import 'package:flutter/material.dart';
import 'Sub_Screen.dart';
import 'Details_Screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
class SubCategories extends StatefulWidget {
  static const String id = 'SubCategories';
  SubCategories({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 50,
          pinned: true,
          actions: <Widget>[
            IconButton(
                icon: IconButton(
                    icon: Icon(Icons.time_to_leave),
                    onPressed: () {
                      setState(() {

                        categorie.DetailsList.sort((a, b) {
                          return a['distance'].compareTo(b['distance']);
                        });
                      });
                    })),
            IconButton(
                icon: IconButton(
                    icon: Icon(Icons.sort_by_alpha),
                    onPressed: () {
                      setState(() {
                        categorie.DetailsList.sort((a, b) {
                          return a['title'].compareTo(b['title']);
                        });
                      });
                    })),
          ],
        ),
        SliverList(

          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return GestureDetector(
                onTap: (){
                  detail.image=categorie.DetailsList[index]['image'];
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => DetailsScreen()));
                },
                child: Container(
                  decoration:
                  BoxDecoration(border: Border.all(color: Colors.grey)),
                  height: MediaQuery.of(context).size.height / 4.9,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: CachedNetworkImage(
                              imageUrl: '${categorie.DetailsList[index]['image']}'),
                        ),
                        Flexible(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height:
                                  MediaQuery.of(context).size.height / 15,
                                  child: Center(
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          left: 5,
                                          top: 5,
                                          child: Text(
                                            '${categorie.DetailsList[index]['title']}',
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 5,
                                          top: 10,
                                          child: Text(
                                            'Delivery : ${categorie.DetailsList[index]['delivery']}',
                                            style: TextStyle(
                                              color: categorie.DetailsList[index]
                                              ['deliverycolor'],
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height:
                                  MediaQuery.of(context).size.height / 15,
                                  child: Center(
                                    child: FlutterRatingBarIndicator(
                                      rating: 2.5,
                                      itemCount: 5,
                                      itemSize: 25.0,
                                      emptyColor: Colors.grey[400],
                                    ),
                                  ),
                                ),
                                Container(
                                  height:
                                  MediaQuery.of(context).size.height / 15,
                                  child: Container(
                                    child: FutureBuilder(
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> text) {
                                        return new Text(

                                          '${text.data}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        );
                                      },
                                      initialData: 'loading',
//                                      future: getresponse(index),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: categorie.DetailsList.length,


            // Or, uncomment the following line:
            // childCount: 3,
          ),
        ),
      ],
    );;
  }

}


