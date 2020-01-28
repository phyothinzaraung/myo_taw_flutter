import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:myotaw/GetFloodLevelScreen.dart';
import 'package:myotaw/database/UserDb.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/helper/FloodLevelFtInHelper.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:myotaw/myWidget/ModalProgressIndicatorWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'dart:io';
import 'helper/MyoTawConstant.dart';

class NewFloodReportScreen extends StatefulWidget {
  @override
  _NewFloodReportScreenState createState() => _NewFloodReportScreenState();
}

class _NewFloodReportScreenState extends State<NewFloodReportScreen> {
  File _image;
  double _floodLevel = 0;
  var _location = new Location();
  double _lat, _lng;
  StreamSubscription<LocationData> _streamSubscription;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  bool _showLoading = false;
  bool _isCon = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationInit();
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
  }

  _locationInit(){
    _location.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 3000, distanceFilter: 0);
    _location.serviceEnabled().then((isEnable){
      if(!isEnable){
        _location.requestService().then((value){
          if(value){
            _streamSubscription = _location.onLocationChanged().listen((currentLocation){
              _lat = currentLocation.latitude;
              _lng = currentLocation.longitude;
            });
          }else{
            Navigator.of(context).pop();
          }
        });
      }else{
        _streamSubscription = _location.onLocationChanged().listen((currentLocation){
          _lat = currentLocation.latitude;
          _lng = currentLocation.longitude;
        });
      }
    });
  }

  Future<File> camera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: MyString.PHOTO_MAX_WIDTH, maxHeight: MyString.PHOTO_MAX_HEIGHT);
    setState(() {
      _image = image;
    });
    return image;
  }

  _navigateToGetFloodLevelScreen() async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetFloodLevelScreen(),
      settings: RouteSettings(name: ScreenName.GET_FLOOD_LEVEL_SCREEN)
    ));
    if(result != null && result.containsKey('FloodLevel')){
      setState(() {
        _floodLevel = result['FloodLevel'];
      });
    }
  }

  _reportFloodLevel()async{
    setState(() {
      _showLoading = true;
    });
    await _sharepreferenceshelper.initSharePref();
    var phNo = _sharepreferenceshelper.getUserPhoneNo();
    var subject = MyString.FLOOD_CONTRIBUTE;
    var uniqueKey = _sharepreferenceshelper.getUserUniqueKey();
    var regionCode = _sharepreferenceshelper.getRegionCode();
    var isAdmin = _sharepreferenceshelper.isWardAdmin();
    var wardName = _sharepreferenceshelper.getWardName();
    await _userDb.openUserDb();
    UserModel _userModel = await _userDb.getUserById(uniqueKey);
    await _userDb.closeUserDb();
    try{
      var response = await ServiceHelper().sendSuggestion(_image.path, phNo, subject, '', uniqueKey, _userModel.name,
          _lat, _lng, regionCode, isAdmin, wardName, _floodLevel);
      if(response.data != null){
        _finishDialogBox();
      }
    }catch(e){
      print(e);
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }

    setState(() {
      _showLoading = false;
    });
  }

  _finishDialogBox(){
    return showDialog(
        context: context,
        builder: (ctxt){
          return WillPopScope(
            child: SimpleDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: Image.asset('images/flood_level.png', width: 50.0, height: 50.0,)),
                      Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(MyString.txt_flood_report_finish,
                            style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),textAlign: TextAlign.center,)),
                      Container(
                        width: 200.0,
                        height: 45.0,
                        child: RaisedButton(onPressed: ()async{
                          await _sharepreferenceshelper.initSharePref();
                          FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.NEWS_FLOOD_REPORT_SCREEN, ClickEvent.SEND_CONTRIBUTION_SUCCESS_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                          Navigator.of(context).pop();
                          Navigator.of(context).pop({'isNeedRefresh' : true});

                        }, child: Text(MyString.txt_close, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                          color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                      )
                    ],
                  ),
                )
              ],
            ),onWillPop: (){},
          );
        }, barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(MyString.txt_add_flood_level_record, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showLoading,
        progressIndicator: ModalProgressIndicatorWidget(),
        child: ListView(
          children: <Widget>[
            Container(
              height: 50,
              margin: EdgeInsets.only(bottom: 20.0, top: 20, left: 20, right: 20),
              child: RaisedButton(onPressed: ()async{
                camera().then((image){
                  if(image != null){
                    _navigateToGetFloodLevelScreen();
                  }
                });
                await _sharepreferenceshelper.initSharePref();
                FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.NEWS_FLOOD_REPORT_SCREEN, ClickEvent.CAMERA_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
              },child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 30.0),
                      child: Image.asset('images/camera.png', width: 25.0, height: 25.0,)),
                  Text(MyString.txt_upload_photo_camera, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),)
                ],
              ),color: Colors.white,elevation: 5.0,
                shape: RoundedRectangleBorder(side: BorderSide(color: MyColor.colorPrimary,), borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
            /*Container(
              height: 50,
              margin: EdgeInsets.only(bottom: 50.0,left: 20, right: 20),
              child: RaisedButton(onPressed: (){
                _navigateToGetFloodLevelScreen();
              },child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 30.0),
                      child: Image.asset('images/flood_level.png', width: 25.0, height: 25.0,)),
                  Text(MyString.txt_flood_level_height, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),)
                ],
              ),color: Colors.white,elevation: 5.0,
                shape: RoundedRectangleBorder(side: BorderSide(color: MyColor.colorPrimary,), borderRadius: BorderRadius.circular(5.0)),
              ),
            ),*/
            Card(
              margin: EdgeInsets.all(0),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0)
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: _image==null?
                        Image.asset('images/placeholder.jpg', width: double.maxFinite, height: 180, fit: BoxFit.cover,) :
                            Image.file(_image, width: double.maxFinite, height: 180, fit: BoxFit.cover,)
                    ),
                    SizedBox(height: 30,),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Image.asset('images/flood.png', width: 35, height: 35,)),
                          Flexible(
                              flex: 1,
                              child: Text(MyString.txt_flood_level_inch +' '+ '${_floodLevel!=0?FloodLevelFtInHelper().getFtInFromWaterLevel(_floodLevel) : '၀ ပေ'}',
                                style: TextStyle(fontSize: FontSize.textSizeExtraSmall),))
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.maxFinite,
                      margin: EdgeInsets.only(bottom: 40),
                      child: RaisedButton(onPressed: ()async{
                        await _checkCon();
                        if(_isCon){
                          if(_image != null && _floodLevel != 0){
                            await _sharepreferenceshelper.initSharePref();
                            FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.NEWS_FLOOD_REPORT_SCREEN, ClickEvent.SEND_FLOOD_LEVEL_REPORT_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                            _reportFloodLevel();
                          }else if(_image == null){
                            WarningSnackBar(_globalKey, MyString.txt_need_suggestion_photo);
                          }else if(_floodLevel == 0){
                            WarningSnackBar(_globalKey, MyString.txt_need_flood_level);
                          }
                        }else{
                          WarningSnackBar(_globalKey, MyString.txt_no_internet);
                        }
                      },child: Text(MyString.txt_add_flood_level_record,
                        style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: MyColor.colorPrimary,elevation: 5.0,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamSubscription.cancel();
  }
}
