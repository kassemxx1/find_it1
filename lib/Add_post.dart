import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:place_picker/place_picker.dart';
FirebaseStorage _storage = FirebaseStorage.instance;
final Firestore _firestore=Firestore.instance;
class AddPost extends StatefulWidget {
  static const String id = 'AddPost_Screen';
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {


var _locationPickerData;

  var radiovalue=0;
  var delivery=false;
  var title ='';
  var PhoneNumber='';
  List categories=[];
  var categorieValue='';
  var ImageLink;
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
  void getcategories()async{
    categories.clear();
   final messages =await _firestore.collection('categories').getDocuments();
   for(var msg in messages.documents){
     final categorie=msg.data['subcategories'];
     setState(() {
       categories.add({
       'display':'$categorie',
         'value':'$categorie',
       });

     });

   }
  }
void showPlacePicker() async {
  LocationResult result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PlacePicker("AIzaSyBBnhAuFuduAMQu5u30xsDzbS6Um0qVNvE")));

  // Handle the result in your way
  print(result);
}
  Future<String> uploadPic() async {

    //Get the file from the image picker and store it
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = _storage.ref().child("images/");

    //Upload the file to firebase
    StorageUploadTask uploadTask = reference.putFile(image);

    // Waits till the file is uploaded then stores the download url
    String location = await (await uploadTask.onComplete).ref.getDownloadURL() as String;
    print(location);
    setState(() {
      ImageLink = location;
    });

    //returns the download url
    return location;

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcategories();
print(categories);
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
          Container(
            padding: EdgeInsets.all(16),
            child: DropDownFormField(
              titleText: 'Categorie',
              hintText: 'Please choose one',
              value: categorieValue,
              onSaved: (value) {
                setState(() {
                  categorieValue = value;
                });
              },
              onChanged: (value) {

                setState(() {
                  categorieValue = value;
                });
              },
              dataSource: categories,
              textField: 'display',
              valueField: 'value',
            ),
          ),
          MaterialButton(
            onPressed: (){
              setState(() {
                uploadPic();
              },);
            },
            child: Text('upload'),
          ),MaterialButton(
            onPressed: ()async {
              LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PlacePicker("AIzaSyBBnhAuFuduAMQu5u30xsDzbS6Um0qVNvE")));

              // Handle the result in your way
              print(result.latLng.longitude.toString());
            },
            child: Text('upload'),
          )


        ],
      ),
    );
  }
}
