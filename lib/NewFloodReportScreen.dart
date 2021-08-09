import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
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
import 'helper/PlatformHelper.dart';
import 'model/WardModel.dart';
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
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  bool _showLoading = false;
  bool _isCon = false;
  List<String> _wardList = List();
  String houseNo, blockNo, streetName, remark;
  List<DropdownMenuItem<String>> _dropDownMenuWard;
  var dialogResponse;
  TextEditingController _remarkController = TextEditingController();
  TextEditingController _houseNoController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  String _selectedWard;
  FocusNode _remarkFocusNode = FocusNode();
  FocusNode _streetNameFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getWard();
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
  }

  void _locationInit()async{
    _location.changeSettings(accuracy: LocationAccuracy.high, interval: 3000, distanceFilter: 0);
    var isServiceEnable = await _location.serviceEnabled();
    if(!isServiceEnable){
      var isSuccess = await _location.requestService();
      if(isSuccess){
        if(_lat == null && _lng == null){
          _getLocation();
        }
      }else{
        _locationInit();
      }
    }else{
      if(_lat == null && _lng == null){
        _getLocation();
      }
    }
  }

  _getLocation()async{
    var location = await _location.getLocation();
    setState(() {
      _lat = location.latitude;
      _lng = location.longitude;
    });
  }

  Future<File> camera() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera, maxWidth: MyString.PHOTO_MAX_WIDTH, maxHeight: MyString.PHOTO_MAX_HEIGHT);
    return File(image.path);
  }

  _navigateToGetFloodLevelScreen() async{
    Map result = await NavigatorHelper.myNavigatorPush(context, GetFloodLevelScreen(), ScreenName.GET_FLOOD_LEVEL_SCREEN);
    if(result != null && result['FloodLevel'] != null){
      setState(() {
        _floodLevel = result['FloodLevel'];
      });
    }
  }

  _reportFloodLevel()async{
    var response;
    setState(() {
      _showLoading = true;
    });
    await _sharepreferenceshelper.initSharePref();
    var phNo = _sharepreferenceshelper.getUserPhoneNo();
    var subject = MyString.FLOOD_REPORT;
    var uniqueKey = _sharepreferenceshelper.getUserUniqueKey();
    var regionCode = _sharepreferenceshelper.getRegionCode();
    var isAdmin = _sharepreferenceshelper.isWardAdmin();
    var wardName = _sharepreferenceshelper.getWardName();
    await _userDb.openUserDb();
    UserModel _userModel = await _userDb.getUserById(uniqueKey);
    _userDb.closeUserDb();
    try{
      if(isAdmin){
        response = await ServiceHelper().sendWardAdminSuggestion(
            file: _image.path,
            phoneNo: phNo,
            subject: subject,
            uniqueKey: _userModel.uniqueKey,
            userName: _userModel.name,
            lat: _lat,
            lng: _lng,
            regionCode: regionCode,
            isAdmin: true,
            wardName: wardName,
            floodLevel: _floodLevel,
            houseNo: houseNo,
            streetName: streetName,
            remark: remark,
            blockNo: blockNo
        );
      }else{
        response = await ServiceHelper().sendWardAdminSuggestion(
            file: _image.path,
            phoneNo: _userModel.phoneNo,
            subject: subject,
            uniqueKey: _userModel.uniqueKey,
            userName: _userModel.name,
            lat: _lat,
            lng: _lng,
            regionCode: _userModel.currentRegionCode,
            isAdmin: false,
            wardName: _userModel.wardName,
            floodLevel: _floodLevel
        );
      }


      if(response.data != null){
        CustomDialogWidget().customSuccessDialog(
          context: context,
          content: MyString.txt_flood_report_finish,
          img: 'flood_level.png',
          onPress: ()async{
            await _sharepreferenceshelper.initSharePref();
            FireBaseAnalyticsHelper.trackClickEvent(ScreenName.NEWS_FLOOD_REPORT_SCREEN, ClickEvent.SEND_CONTRIBUTION_SUCCESS_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
            Navigator.of(context).pop();
            Navigator.of(context).pop({'isRefresh' : true});
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


  Widget _body(){
    return ModalProgressHUD(
      inAsyncCall: _showLoading,
      progressIndicator: CustomProgressIndicatorWidget(),
      child: ListView(
        children: <Widget>[
          Container(
            decoration: PlatformHelper.isAndroid()? null :
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
              FireBaseAnalyticsHelper.trackClickEvent(ScreenName.NEWS_FLOOD_REPORT_SCREEN, ClickEvent.CAMERA_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
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
                          if(!_sharepreferenceshelper.isWardAdmin()){
                            if(_lat != null && _lng != null){
                              _reportFloodLevel();
                              FireBaseAnalyticsHelper.trackClickEvent(ScreenName.NEWS_FLOOD_REPORT_SCREEN, ClickEvent.SEND_FLOOD_LEVEL_REPORT_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                            }else{
                              WarningSnackBar(_globalKey, MyString.txt_try_again_no_location);
                            _locationInit();
                            }
                          }else{
                            if(_lat != null && _lng != null){
                              _reportFloodLevel();
                              FireBaseAnalyticsHelper.trackClickEvent(ScreenName.NEWS_FLOOD_REPORT_SCREEN, ClickEvent.SEND_FLOOD_LEVEL_REPORT_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                            }else{
                              if(blockNo!= null){
                                _reportFloodLevel();
                              }else {
                                FocusScope.of(context).requestFocus(FocusNode());
                                showAddressDialog(context, _wardList);
                              }
                            }
                          }


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

  Future<void> showAddressDialog(BuildContext context, List<String> wardList) async {
    _dropDownMenuWard = getDropDownMenuWard(wardList);
    dialogResponse = showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(8.0)), //this right here
              child: Container(
                height: 480,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 4.0),
                          child: Text(MyString.txt_fill_address,
                            style: TextStyle(fontSize: FontSize.textSizeExtraNormal,
                                fontWeight: FontWeight.bold,
                                color: MyColor.colorPrimary),)),
                      Container(
                          margin: EdgeInsets.only(top: 4.0),
                          child: Text(MyString.txt_house_no,
                            style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                        ),
                        child: TextField(
                          maxLines: null,
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                          onChanged: (value) {
                            setState(() {
                              houseNo = value;
                            });
                          },
                          showCursor: true,
                          cursorColor: MyColor.colorPrimary,
                          autocorrect: false,
                          controller: _houseNoController,
                          style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorTextBlack),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child: Text(MyString.txt_owner_street_name,
                            style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                        ),
                        child: TextField(
                          maxLines: null,
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                          showCursor: true,
                          focusNode: _streetNameFocusNode,
                          cursorColor: MyColor.colorPrimary,
                          autocorrect: false,
                          controller: _streetController,
                          style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorTextBlack),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child: Text(MyString.txt_blockNo,
                            style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                        ),
                        child: FormField(builder: (FormFieldState state){
                          return InputDecorator(
                            decoration: InputDecoration(
                                border: InputBorder.none),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text("ရပ်ကွက်ရွေးချယ်ပါ",
                                  style: TextStyle(
                                      fontSize: FontSize.textSizeExtraSmall
                                  ),),
                                value: _selectedWard,
                                isDense: true,
                                onChanged: (value){
                                  setState(() {
                                    _selectedWard = value;
                                  });
                                  _streetNameFocusNode.unfocus();
                                  FocusScope.of(context).requestFocus(_remarkFocusNode);
                                },
                                items: _dropDownMenuWard,
                              ),
                            ),
                          );
                        }),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child: Text(MyString.txt_remark,
                            style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(color: MyColor.colorPrimary,
                                style: BorderStyle.solid,
                                width: 0.80)
                        ),
                        child: TextField(
                          focusNode: _remarkFocusNode,
                          maxLines: null,
                          controller: _remarkController,
                          showCursor: true,
                          cursorColor: MyColor.colorPrimary,
                          autocorrect: false,
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                          style: TextStyle(fontSize: FontSize.textSizeNormal),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: CustomButtonWidget(
                          onPress: (){
                            if(_selectedWard == null){
                              WarningSnackBar(_globalKey, MyString.txt_select_block);
                            }else {
                              setState(() {
                                houseNo = _houseNoController.text;
                                streetName = _streetController.text;
                                blockNo = _selectedWard;
                                remark = _remarkController.text;
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Text(MyString.txt_save, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          color: MyColor.colorPrimary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value){
      setState(() {
        dialogResponse = value;
      });
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuWard(List<String> wardList) {
    List<DropdownMenuItem<String>> _ward = List();
    for (String ward in wardList) {
      _ward.add(DropdownMenuItem(value: ward, child: Text(ward)));
    }
    return _ward;
  }

  _getWard() async{
    String _township;
    await _sharepreferenceshelper.initSharePref();
    String regionCode = _sharepreferenceshelper.getRegionCode();
    print(regionCode);
    switch(regionCode){
      case MyString.TGY_REGION_CODE:
        _township = MyString.TGY_CITY;
        break;
      case MyString.MLM_REGION_CODE:
        _township = MyString.MLM_CITY;
        break;
      case MyString.LKW_REGION_CODE:
        _township = MyString.LKW_CITY;
        break;
      case MyString.MGY_REGION_CODE:
        _township = MyString.MGY_CITY;
        break;
      case MyString.HLY_REGION_CODE:
        _township = MyString.HLY_CITY;
        break;
      case MyString.HPA_REGION_CODE:
        _township = MyString.HPA_CITY;
        break;
    }
    Response _response = await ServiceHelper().getWards(_township);
    if(_response!=null){
      var result = _response.data;
      for(var i in result){
        setState(() {
          _wardList.add(WardModel.fromJson(i).wardName);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _locationInit();
    return CustomScaffoldWidget(
      title: Text(MyString.txt_add_flood_level_record,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(),
      globalKey: _globalKey,
    );
  }

}
