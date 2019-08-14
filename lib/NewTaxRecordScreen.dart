import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'helper/MyoTawConstant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helper/SharePreferencesHelper.dart';
import 'Database/UserDb.dart';

class NewTaxRecordScreen extends StatefulWidget {
  @override
  _NewTaxRecordScreenState createState() => _NewTaxRecordScreenState();
}

class _NewTaxRecordScreenState extends State<NewTaxRecordScreen> {
  TextEditingController _recordNameController = new TextEditingController();
  String _recordName;
  File _image;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future camera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 1024, maxHeight: 768);
    setState(() {
      _image = image;
    });
  }

  Future gallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 1024, maxHeight: 768);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_tax_record, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(0.0),
            child: Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(MyString.txt_tax_record_name, style: TextStyle(fontSize: FontSize.textSizeSmall),textAlign: TextAlign.left,),
                  Container(
                    margin: EdgeInsets.only(top: 5.0, bottom: 20.0),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none
                      ),
                      controller: _recordNameController,
                      style: TextStyle(fontSize: FontSize.textSizeNormal),
                      onChanged: (value){
                        _recordName = value;
                      },
                    ),
                  ),
                  //camera
                  Container(
                    height: 45.0,
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: RaisedButton(onPressed: (){
                      camera();
                      },child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 30.0),
                            child: Image.asset('images/camera.png', width: 25.0, height: 25.0,)),
                        Text(MyString.txt_upload_photo_camera, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),)
                      ],
                    ),color: Colors.white,elevation: 1.0,
                      shape: RoundedRectangleBorder(side: BorderSide(color: MyColor.colorPrimary,), borderRadius: BorderRadius.circular(5.0)),),
                  ),
                  //gallery
                  Container(
                    height: 45.0,
                    child: RaisedButton(onPressed: (){
                      gallery();
                      },child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(right: 30.0),
                            child: Image.asset('images/gallery.png', width: 25.0, height: 25.0,)),
                        Text(MyString.txt_upload_photo_gallery, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),)
                      ],
                    ),color: Colors.white,elevation: 1.0,
                      shape: RoundedRectangleBorder(side: BorderSide(color: MyColor.colorPrimary,), borderRadius: BorderRadius.circular(5.0)),),
                  )
                ],
              ),
            ),
          ),
          Container(
              child: _image!=null?Image.file(_image, fit: BoxFit.cover,):
              Image.asset('images/placeholder.jpg', fit: BoxFit.cover,), width: double.maxFinite, height: 270.0,),
          Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            margin: EdgeInsets.only(top: 50.0),
            height: 45.0,
            child: RaisedButton(onPressed: (){
              if(_recordName != null && _image != null){
                Fluttertoast.showToast(msg: 'upload', backgroundColor: Colors.black.withOpacity(0.7),
                    fontSize: FontSize.textSizeSmall);
              } else if(_recordName == null){
                Fluttertoast.showToast(msg: 'Please fill record name', backgroundColor: Colors.black.withOpacity(0.7),
                    fontSize: FontSize.textSizeSmall);
              }else{
                Fluttertoast.showToast(msg: 'Choose Photo Form camera or gallery', backgroundColor: Colors.black.withOpacity(0.7),
                    fontSize: FontSize.textSizeSmall);
              }

              }, child: Text(MyString.txt_save_user_profile, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
              color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
          )
        ],
      ),
    );
  }
}
