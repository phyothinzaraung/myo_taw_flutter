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
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomProgressIndicator.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'dart:io';
import 'helper/MyoTawConstant.dart';
import 'myWidget/CustomButtonWidget.dart';

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
    return image;
  }

  _navigateToGetFloodLevelScreen() async{
    Map result = await NavigatorHelper.MyNavigatorPush(context, GetFloodLevelScreen(), ScreenName.GET_FLOOD_LEVEL_SCREEN);
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
    _userDb.closeUserDb();
    try{
      var response = await ServiceHelper().sendSuggestion(_image.path, phNo, subject, '', uniqueKey, _userModel.name,
          _lat, _lng, regionCode, isAdmin, wardName, _floodLevel);
      if(response.data != null){
        CustomDialogWidget().customSuccessDialog(
          context: context,
          content: MyString.txt_flood_report_finish,
          img: 'flood_level.png',
          onPress: ()async{
            await _sharepreferenceshelper.initSharePref();
            FireBaseAnalyticsHelper.TrackClickEvent(ScreenName.NEWS_FLOOD_REPORT_SCREEN, ClickEvent.SEND_CONTRIBUTION_SUCCESS_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
            Navigator.of(context).pop();
            Navigator.of(context).pop({'isNeedRefresh' : true});
          }
        );
      }
    }catch(e){
      print(e);
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }

    setState(() {
      _showLoading = false;
    });
  }


  Widget _body(BuildContext context){
    return ModalProgressHUD(
      inAsyncCall: _showLoading,
      progressIndicator: CustomProgressIndicatorWidget(),
      child: ListView(
        children: <Widget>[
          Container(
            decoration: Platform.isAndroid? null :
            BoxDecoration(
                border: Border.all(color: MyColor.colorPrimary, width: 1),
                borderRadius: BorderRadius.circular(10)
            ),
            margin: EdgeInsets.only(bottom: 20.0, top: 20, left: 20, right: 20),
            child: CustomButtonWidget(onPress: ()async{
              camera().then((image)async{
                if(image != null){
                  await _navigateToGetFloodLevelScreen();
                  setState(() {
                    _image = image;
                  });
                }
              });
              await _sharepreferenceshelper.initSharePref();
              FireBaseAnalyticsHelper.TrackClickEvent(ScreenName.NEWS_FLOOD_REPORT_SCREEN, ClickEvent.CAMERA_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
            },child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 30.0),
                    child: Image.asset('images/camera.png', width: 25.0, height: 25.0,)),
                Text(MyString.txt_get_flood_level_photo, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),)
              ],
            ),color: Colors.white,elevation: 5.0,
              shape: RoundedRectangleBorder(side: BorderSide(color: MyColor.colorPrimary,), borderRadius: BorderRadius.circular(5.0)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

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
                            child: Text(MyString.txt_flood_level_inch +' '+ '${_floodLevel!=0?FloodLevelFtInHelper.getFtInFromWaterLevel(_floodLevel) : '၀ ပေ'}',
                              style: TextStyle(fontSize: FontSize.textSizeExtraSmall),))
                      ],
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(bottom: 40),
                    child: CustomButtonWidget(onPress: ()async{
                      await _checkCon();
                      if(_isCon){
                        if(_image != null && _floodLevel != 0){
                          await _sharepreferenceshelper.initSharePref();
                          FireBaseAnalyticsHelper.TrackClickEvent(ScreenName.NEWS_FLOOD_REPORT_SCREEN, ClickEvent.SEND_FLOOD_LEVEL_REPORT_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
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
                      borderRadius: BorderRadius.circular(10),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(MyString.txt_add_flood_level_record,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(context),
      globalKey: _globalKey,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamSubscription.cancel();
  }
}
