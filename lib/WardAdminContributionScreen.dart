import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/CustomButtonWidget.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/CustomProgressIndicator.dart';
import 'package:myotaw/myWidget/DropDownWidget.dart';
import 'package:myotaw/myWidget/IosPickerWidget.dart';
import 'helper/MyoTawCitySetUpHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'helper/PlatformHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'Database/UserDb.dart';
import 'model/UserModel.dart';
import 'helper/ServiceHelper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'WardAdminLocationUpdateScreen.dart';
import 'model/WardModel.dart';
import 'myWidget/NativeProgressIndicator.dart';
import 'myWidget/WarningSnackBarWidget.dart';

class WardAdminContributionScreen extends StatefulWidget {

  @override
  _WardAdminContributionScreenState createState() => _WardAdminContributionScreenState();
}

class _WardAdminContributionScreenState extends State<WardAdminContributionScreen> {
  List<String> _subjectList = new List<String>();
  String _dropDownSubject = MyString.txt_choose_subject;
  double _lat, _lng;
  bool _isCon, _isLoading = false;
  File _image;
  var _location = new Location();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  UserModel _userModel;
  Response _response;
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition;
  Set<Marker> _markers = Set();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  TextEditingController _messController = TextEditingController();
  List<Widget> _subjectWidgetList = List();
  int _pickerIndex = 0;
  List<String> _wardList = List<String>();
  TextEditingController _remarkController = TextEditingController();
  TextEditingController _houseNoController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  String _selectedWard;
  List<DropdownMenuItem<String>> _dropDownMenuWard;
  var dialogResponse;
  String houseNo, blockNo, streetName, remark;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subjectList = [_dropDownSubject,];
    _subjectList.addAll(MyStringList.suggestion_subject_admin_ward);
    for(var i in _subjectList){
      _subjectWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
    _getWard();
  }

  void _locationInit()async{
    _location.changeSettings(accuracy: LocationAccuracy.high, interval: 3000, distanceFilter: 0);
    var isServiceEnable = await _location.serviceEnabled();
    if(!isServiceEnable){
      var isSuccess = await _location.requestService();
      if(!isSuccess){
        _locationInit();
      }else{
        if(_lat == null && _lng == null){
          _getLocation();
        }
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
      if(mounted){
        _cameraPosition = CameraPosition(
            target: LatLng(_lat, _lng),
            zoom: 17.0
        );
        Marker _resultMarker = Marker(
          markerId: MarkerId(location.toString()),
          position: LatLng(_lat, _lng),
        );
        _markers.add(_resultMarker);
      }
    });
  }

  _getWard() async{
    String _townsip;
    await _sharepreferenceshelper.initSharePref();
    String regionCode = _sharepreferenceshelper.getRegionCode();
    switch(regionCode){
      case MyString.TGY_REGION_CODE:
        _townsip = MyString.TGY_CITY;
        break;
      case MyString.MLM_REGION_CODE:
        _townsip = MyString.MLM_CITY;
        break;
      case MyString.LKW_REGION_CODE:
        _townsip = MyString.LKW_CITY;
        break;
      case MyString.MGY_REGION_CODE:
        _townsip = MyString.MGY_CITY;
        break;
      case MyString.HLY_REGION_CODE:
        _townsip = MyString.HLY_CITY;
        break;
      case MyString.HPA_REGION_CODE:
        _townsip = MyString.HPA_CITY;
        break;
    }
    _response = await ServiceHelper().getWards(_townsip);
    if(_response!=null){
      var result = _response.data;
      for(var i in result){
        setState(() {
          _wardList.add(WardModel.fromJson(i).wardName);
        });
      }
    }
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

  Future camera() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera, maxWidth: MyString.PHOTO_MAX_WIDTH, maxHeight: MyString.PHOTO_MAX_HEIGHT);
    setState(() {
      _image = File(image.path);
    });
  }

  Future gallery() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery, maxWidth: MyString.PHOTO_MAX_WIDTH, maxHeight: MyString.PHOTO_MAX_HEIGHT);

    setState(() {
      _image = File(image.path);
    });
  }

  _sendSuggestion()async{
    setState(() {
      _isLoading = true;
    });
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userDb.closeUserDb();
    setState(() {
      _userModel = model;
    });
    try{
      _response = await ServiceHelper().sendSuggestion(_image.path, _userModel.phoneNo, _dropDownSubject, _messController.text,
          _userModel.uniqueKey, _userModel.name, _lat, _lng, _userModel.currentRegionCode, true, _userModel.wardName,0);
      //print('sendsuggest: ${_sharepreferenceshelper.isWardAdmin()} ${_userModel.wardName}');
      if(_response.data != null){
        CustomDialogWidget().customSuccessDialog(
            context: context,
            content: MyString.txt_suggestion_finish,
            img: 'suggestion_no_circle.png',
            onPress: ()async{
              FocusScope.of(context).requestFocus(FocusNode());
              await _sharepreferenceshelper.initSharePref();
              FireBaseAnalyticsHelper.trackClickEvent(ScreenName.WARD_ADMIN_CONTRIBUTION_SCREEN, ClickEvent.SEND_CONTRIBUTION_SUCCESS_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
              Navigator.of(context).pop();
              Navigator.of(context).pop({'isRefresh' : true});
            }
        );
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

  _sendWardAdminSuggestion(String houseNumber, String street, String block, String rmk)async{
    setState(() {
      _isLoading = true;
    });
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userDb.closeUserDb();
    setState(() {
      _userModel = model;
    });
    try{
      _response = await ServiceHelper().sendWardAdminSuggestion(_image.path, _userModel.phoneNo, _dropDownSubject, _messController.text,
          _userModel.uniqueKey, _userModel.name, _lat, _lng, _userModel.currentRegionCode, true, _userModel.wardName,0, houseNumber, street, rmk, block);
      //print('sendsuggest: ${_sharepreferenceshelper.isWardAdmin()} ${_userModel.wardName}');
      if(_response.data != null){
        CustomDialogWidget().customSuccessDialog(
            context: context,
            content: MyString.txt_suggestion_finish,
            img: 'suggestion_no_circle.png',
            onPress: ()async{
              FocusScope.of(context).requestFocus(FocusNode());
              await _sharepreferenceshelper.initSharePref();
              FireBaseAnalyticsHelper.trackClickEvent(ScreenName.WARD_ADMIN_CONTRIBUTION_SCREEN, ClickEvent.SEND_CONTRIBUTION_SUCCESS_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
              Navigator.of(context).pop();
              Navigator.of(context).pop({'isRefresh' : true});
            }
        );
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

  _navigateToAdminLocationUpdateScreen()async{
    /*Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => WardAdminLocationUpdateScreen(),
      settings: RouteSettings(name: ScreenName.WARD_ADMIN_LOCATION_UPDATE_SCREEN)
    ));*/
    Map result = await NavigatorHelper.myNavigatorPush(context, WardAdminLocationUpdateScreen(), ScreenName.WARD_ADMIN_LOCATION_UPDATE_SCREEN);
    if(result != null && result['latLng'] != null){
      setState(() {
        LatLng latLng = result['latLng'];
        _lat = latLng.latitude;
        _lng = latLng.longitude;
        _cameraPosition = CameraPosition(
            target: LatLng(latLng.latitude, latLng.longitude),
            zoom: 17.0,
        );
        _updateCameraPosition(_cameraPosition);
        Marker _resultMarker = Marker(
            markerId: MarkerId(result.keys.toString()),
            position: latLng
        );
        _markers.clear();
        _markers.add(_resultMarker);
      });
    }
  }

  _updateCameraPosition(CameraPosition cameraPosition)async{
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Widget _body(String _houseNo, String _blockNo, String _remark, String _streetName ){
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CustomProgressIndicatorWidget(),
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
            child: Row(
              children: <Widget>[
                Container(margin: EdgeInsets.only(right: 10.0),
                    child: Image.asset('images/suggestion_no_circle.png', width: 30.0, height: 30.0,)),
                Text(MyString.title_suggestion, style: TextStyle(fontSize: FontSize.textSizeSmall),),
              ],
            ),
          ),
          //map
          Card(
            margin: EdgeInsets.all(0.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  _image!=null?Image.file(_image, width: double.maxFinite, height: 200.0, fit: BoxFit.cover,):
                  Image.asset('images/placeholder.jpg', width: double.maxFinite, height: 200.0, fit: BoxFit.cover,),
                  Card(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
                    child: Column(
                      children: <Widget>[
                        _cameraPosition!=null?Container(
                            width: double.maxFinite,
                            height: 150.0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                GoogleMap(
                                  initialCameraPosition: _cameraPosition,
                                  mapType: MapType.normal,
                                  myLocationButtonEnabled: false,
                                  onMapCreated: (controller){
                                    _controller.complete(controller);
                                  },
                                  markers: _markers,
                                ),
                                //Image.asset('images/pin_holder.png', width: 15.0, height: 15.0,)
                              ],
                            )
                        ) :
                        Container(
                          width: double.maxFinite,
                          height: 150.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              NativeProgressIndicator()
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _navigateToAdminLocationUpdateScreen();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 20.0),
                                    child: Image.asset('images/location_update.png', width: 25.0, height: 25.0,)),
                                Text(MyString.txt_location_update, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),)

                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //camera
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: PlatformHelper.isAndroid()? null :
                            BoxDecoration(
                              border: Border.all(color: MyColor.colorPrimary, width: 1),
                              borderRadius: BorderRadius.circular(10)
                            ),
                          child: CustomButtonWidget(
                            onPress: ()async{
                              camera();
                              await _sharepreferenceshelper.initSharePref();
                              FireBaseAnalyticsHelper.trackClickEvent(ScreenName.WARD_ADMIN_CONTRIBUTION_SCREEN, ClickEvent.CAMERA_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(side: BorderSide(color: MyColor.colorPrimary,), borderRadius: BorderRadius.circular(5.0)),
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 30.0),
                                    child: Image.asset('images/camera.png', width: 25.0, height: 25.0,)),
                                Text(MyString.txt_upload_photo_camera, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),)
                              ],
                            ),
                          )
                        ),

                        Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            decoration: PlatformHelper.isAndroid()? null :
                            BoxDecoration(
                                border: Border.all(color: MyColor.colorPrimary, width: 1),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: CustomButtonWidget(
                              onPress: ()async{
                                gallery();
                                await _sharepreferenceshelper.initSharePref();
                                FireBaseAnalyticsHelper.trackClickEvent(ScreenName.WARD_ADMIN_CONTRIBUTION_SCREEN, ClickEvent.GALLERY_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                              },
                              color: Colors.white,
                              shape: RoundedRectangleBorder(side: BorderSide(color: MyColor.colorPrimary,), borderRadius: BorderRadius.circular(5.0)),
                              elevation: 5,
                              borderRadius: BorderRadius.circular(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(right: 30.0),
                                      child: Image.asset('images/gallery.png', width: 25.0, height: 25.0,)),
                                  Text(MyString.txt_upload_photo_gallery, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),)
                                ],
                              ),
                            )
                        ),

                        Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Text(MyString.title_suggestion_subject, style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                        Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.8
                              )
                          ),
                          child: PlatformHelper.isAndroid()?

                              DropDownWidget(
                                value: _dropDownSubject,
                                onChange: (value){
                                  setState(() {
                                    _dropDownSubject = value;
                                  });
                                },
                                list: _subjectList,
                              ) :
                          IosPickerWidget(
                            onPress: (){
                              setState(() {
                                _dropDownSubject = _subjectList[_pickerIndex];
                              });
                              Navigator.pop(context);
                            },
                            onSelectedItemChanged: (index){
                              _pickerIndex = index;
                            },
                            fixedExtentScrollController: FixedExtentScrollController(initialItem: _pickerIndex),
                            text: _dropDownSubject,
                            children: _subjectWidgetList,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Text(MyString.title_suggestion_mess, style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                        Container(
                          margin: EdgeInsets.only(top: 5.0, bottom: 20.0),
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          height: 160.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                          ),
                          child: TextField(
                            maxLines: null,
                            showCursor: true,
                            cursorColor: MyColor.colorPrimary,
                            autocorrect: false,
                            controller: _messController,
                            decoration: InputDecoration(
                                border: InputBorder.none
                            ),
                            style: TextStyle(fontSize: FontSize.textSizeNormal),
                          ),
                        ),

                        Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: CustomButtonWidget(
                            onPress: () async{
                              await _checkCon();
                              if(_isCon){
                                if(_messController.text.isNotEmpty && _image != null && _dropDownSubject != MyString.txt_choose_subject){
                                  if(_lat != null && _lng != null){
                                    _sendSuggestion();
                                    FireBaseAnalyticsHelper.trackClickEvent(ScreenName.WARD_ADMIN_CONTRIBUTION_SCREEN, ClickEvent.SEND_WARD_ADMIN_CONTRIBUTION_CLICK_EVENT,
                                        _sharepreferenceshelper.getUserUniqueKey());
                                  }else{
                                    // WarningSnackBar(_globalKey, MyString.txt_try_again_no_location);
                                    // _locationInit();
                                    print("no location");
                                    if(_blockNo!= null){
                                      _sendWardAdminSuggestion(_houseNo, _streetName, _blockNo, _remark);
                                    }else {
                                      showAddressDialog(context, _wardList);
                                    }
                                  }

                                }else if(_image == null){
                                  WarningSnackBar(_globalKey, MyString.txt_need_suggestion_photo);
                                }else if(_dropDownSubject == MyString.txt_choose_subject){
                                  WarningSnackBar(_globalKey, MyString.txt_need_subject);
                                }else if(_messController.text.isEmpty){
                                  WarningSnackBar(_globalKey, MyString.txt_need_suggestion);
                                }
                              }else{
                                WarningSnackBar(_globalKey, MyString.txt_no_internet);
                              }
                            },
                            child: Text(MyString.txt_send_contribution, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            color: MyColor.colorPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      ],
                    ),
                  )
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
    _locationInit();
    return CustomScaffoldWidget(
      title: Text(MyString.txt_suggestion,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(houseNo, blockNo, remark, streetName),
      globalKey: _globalKey,
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
}
