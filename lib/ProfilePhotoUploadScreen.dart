import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'helper/SharePreferencesHelper.dart';
import 'helper/ServiceHelper.dart';
import 'Database/UserDb.dart';
import 'model/UserModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'myWidget/CustomProgressIndicator.dart';

class ProfilePhotoUploadScreen extends StatefulWidget {
  @override
  _ProfilePhotoUploadScreenState createState() => _ProfilePhotoUploadScreenState();
}

class _ProfilePhotoUploadScreenState extends State<ProfilePhotoUploadScreen> {
  File _image;
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  var _response;
  UserDb _userDb = UserDb();
  UserModel _userModel;
  bool _isCon,_isLoading = false;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future camera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: MyString.PHOTO_MAX_WIDTH, maxHeight: MyString.PHOTO_MAX_HEIGHT);
    setState(() {
      _image = image;
    });
  }

  Future gallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: MyString.PHOTO_MAX_WIDTH, maxHeight: MyString.PHOTO_MAX_HEIGHT);

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
  }

  _uploadPhoto()async{
    await _sharepreferenceshelper.initSharePref();
    try{
      _response = await ServiceHelper().uploadProfilePhoto(_image.path, _sharepreferenceshelper.getUserUniqueKey());
      if(_response.data != null){
        _userModel = UserModel.fromJson(_response.data);
        await _userDb.openUserDb();
        await _userDb.insert(_userModel);
        _userDb.closeUserDb();
        Navigator.of(context).pop({'isRefresh' : true});
      }else{
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

  Widget _body(){
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CustomProgressIndicatorWidget(),
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
                    child: FlatButton(onPressed: ()async{
                      gallery();
                      await _sharepreferenceshelper.initSharePref();
                      FireBaseAnalyticsHelper.trackClickEvent(ScreenName.PROFILE_PHOTO_SCREEN, ClickEvent.GALLERY_CLICK_EVENT,
                          _sharepreferenceshelper.getUserUniqueKey());
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
                        await _sharepreferenceshelper.initSharePref();
                        FireBaseAnalyticsHelper.trackClickEvent(ScreenName.PROFILE_PHOTO_SCREEN, ClickEvent.PROFILE_PHOTO_UPLOAD_CLICK_EVENT,
                            _sharepreferenceshelper.getUserUniqueKey());
                        _uploadPhoto();
                      }else{
                        WarningSnackBar(_globalKey, MyString.txt_no_internet);
                      }
                    }, child: Text(MyString.txt_upload_photo, style: TextStyle(color: Colors.white),),
                      color: MyColor.colorPrimary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),),
                  ),
                ),
                //camera
                _image==null?Expanded(
                  child: Container(
                    height: 50.0,
                    child: FlatButton(onPressed: ()async{
                      camera();
                      await _sharepreferenceshelper.initSharePref();
                      FireBaseAnalyticsHelper.trackClickEvent(ScreenName.PROFILE_PHOTO_SCREEN, ClickEvent.CAMERA_CLICK_EVENT,
                          _sharepreferenceshelper.getUserUniqueKey());
                    }, child: Text(MyString.txt_camera, style: TextStyle(color: Colors.white),),
                      color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),),
                  ),
                ):
                //choose again photo
                Expanded(
                  child: Container(
                    height: 50.0,
                    child: FlatButton(onPressed: ()async{
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: null,
      body: _body(),
      globalKey: _globalKey,
    );
  }
}
