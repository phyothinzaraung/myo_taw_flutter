import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helper/MyoTawConstant.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'helper/SharePreferencesHelper.dart';
import 'helper/ServiceHelper.dart';
import 'Database/UserDb.dart';
import 'model/UserModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProfilePhotoUploadScreen extends StatefulWidget {
  @override
  _ProfilePhotoUploadScreenState createState() => _ProfilePhotoUploadScreenState();
}

class _ProfilePhotoUploadScreenState extends State<ProfilePhotoUploadScreen> {
  File _image;
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  Response _response;
  UserDb _userDb = UserDb();
  UserModel _userModel;
  bool _isCon,_isLoading = false;

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

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
    //print('isCon : ${_isCon}');
  }

  _uploadPhoto()async{
    await _sharepreferenceshelper.initSharePref();
    _response = await ServiceHelper().uploadProfilePhoto(_image.path, _sharepreferenceshelper.getUniqueKey());
    _userModel = UserModel.fromJson(_response.data);
    await _userDb.openUserDb();
    await _userDb.insert(_userModel);
    await _userDb.closeUserDb();
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop({'isNeedRefresh' : true});
    print('uploadprofile: ${_response.data}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: modalProgressIndicator(),
        child: Container(
          width: double.maxFinite,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[CircleAvatar(
                    backgroundImage: _image==null?
                    AssetImage('images/placeholder.jpg') :
                    FileImage(_image),radius: 120.0,)],)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //gallery
                  _image==null?Expanded(
                    child: Container(
                      height: 50.0,
                      child: FlatButton(onPressed: (){
                        gallery();
                        }, child: Text(MyString.txt_gallery, style: TextStyle(color: Colors.white),),
                        color: MyColor.colorPrimary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),),
                    ),
                  ):
                      //uploadphoto
                  Expanded(
                    child: Container(
                      height: 50.0,
                      child: FlatButton(onPressed: ()async{
                        await _checkCon();
                        if(_isCon){
                          setState(() {
                            _isLoading = true;
                          });
                          _uploadPhoto();
                        }else{
                          Fluttertoast.showToast(msg: 'No internet connection', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                        }
                      }, child: Text(MyString.txt_upload_photo, style: TextStyle(color: Colors.white),),
                        color: MyColor.colorPrimary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),),
                    ),
                  ),
                  //camera
                  _image==null?Expanded(
                    child: Container(
                      height: 50.0,
                      child: FlatButton(onPressed: (){
                        camera();
                        }, child: Text(MyString.txt_camera, style: TextStyle(color: Colors.white),),
                        color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),),
                    ),
                  ):
                      //choose again photo
                  Expanded(
                    child: Container(
                      height: 50.0,
                      child: FlatButton(onPressed: (){
                        setState(() {
                          _image = null;
                        });
                      }, child: Text(MyString.txt_choose_photo, style: TextStyle(color: Colors.white),),
                        color: MyColor.colorPrimary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
