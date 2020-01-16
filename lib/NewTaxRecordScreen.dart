import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helper/SharePreferencesHelper.dart';
import 'Database/UserDb.dart';
import 'model/UserModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';

class NewTaxRecordScreen extends StatefulWidget {
  @override
  _NewTaxRecordScreenState createState() => _NewTaxRecordScreenState();
}

class _NewTaxRecordScreenState extends State<NewTaxRecordScreen> {
  TextEditingController _recordNameController = new TextEditingController();
  File _image;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  UserModel _userModel;
  bool _isCon ,_isLoading = false;
  var _response;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();

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

  Widget modalProgressIndicator(){
    return Center(
      child: Card(
        child: Container(
          width: 220.0,
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(margin: EdgeInsets.only(right: 30.0),
                  child: Text('Loading......',style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.black))),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColor.colorPrimary))
            ],
          ),
        ),
      ),
    );
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
    //print('isCon : ${_isCon}');
  }

  _uploadTaxRecord() async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    await _userDb.closeUserDb();
    _userModel = model;
    try{
      _response = await ServiceHelper().uploadTaxRecord(_image.path, _recordNameController.text, _userModel.uniqueKey, _userModel.name, _userModel.currentRegionCode);
      //print('uploaddata: ${_recordName} ${_userModel.uniqueKey} ${_userModel.name} ${_userModel.currentRegionCode}');
      if(_response.data != null){
        Navigator.of(context).pop({'isNeedRefresh' : true});
      }else{
        //Fluttertoast.showToast(msg: MyString.txt_try_again, fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
        WarningSnackBar(_globalKey, MyString.txt_try_again);
      }
    }catch(e){
      print(e);
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(MyString.txt_tax_record, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: modalProgressIndicator(),
        child: ListView(
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
                            border: InputBorder.none,
                        ),
                        controller: _recordNameController,
                        style: TextStyle(fontSize: FontSize.textSizeNormal),
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
              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
              height: 45.0,
              child: RaisedButton(onPressed: ()async{
                await _checkCon();
                if(_isCon){
                  if(_recordNameController.text != '' && _image != null){
                    setState(() {
                      _isLoading = true;
                    });
                    _uploadTaxRecord();
                  } else if(_recordNameController.text == ''){
                    /*Fluttertoast.showToast(msg: 'Please fill record name', backgroundColor: Colors.black.withOpacity(0.7),
                        fontSize: FontSize.textSizeNormal);*/
                    WarningSnackBar(_globalKey, MyString.txt_need_tax_record_name);
                  }else{
                    /*Fluttertoast.showToast(msg: 'Choose Photo Form camera or gallery', backgroundColor: Colors.black.withOpacity(0.7),
                        fontSize: FontSize.textSizeNormal);*/
                    WarningSnackBar(_globalKey, MyString.txt_need_suggestion_photo);
                  }
                }else{
                  //Fluttertoast.showToast(msg: 'No internet connection', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                  WarningSnackBar(_globalKey, MyString.txt_no_internet);
                }

                }, child: Text(MyString.txt_save_user_profile, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
            )
          ],
        ),
      ),
    );
  }
}
