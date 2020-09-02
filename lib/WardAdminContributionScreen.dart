import 'dart:async';
import 'dart:io';
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
import 'helper/MyoTawConstant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'helper/PlatformHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'Database/UserDb.dart';
import 'model/UserModel.dart';
import 'helper/ServiceHelper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'WardAdminLocationUpdateScreen.dart';
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
  bool _isCon, _isLoading;
  File _image;
  var _location = new Location();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  UserModel _userModel;
  var _response;
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition;
  StreamSubscription<LocationData> _streamSubscription;
  Set<Marker> _markers = Set();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  TextEditingController _messController = TextEditingController();
  List<Widget> _subjectWidgetList = List();
  int _pickerIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subjectList = [_dropDownSubject,];
    _subjectList.addAll(MyStringList.suggestion_subject_admin_ward);
    _locationInit();
    for(var i in _subjectList){
      _subjectWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
    _isLoading = false;
  }

  void _locationInit(){
    _location.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 3000, distanceFilter: 0);
    _location.serviceEnabled().then((isEnable){
      if(!isEnable){
        _location.requestService().then((value){
          if(value){
            _streamSubscription = _location.onLocationChanged().listen((currentLocation){
              _lat = currentLocation.latitude;
              _lng = currentLocation.longitude;
              if(mounted){
                setState(() {
                  _cameraPosition = CameraPosition(
                    target: LatLng(currentLocation.latitude, currentLocation.longitude),
                    zoom: 17,
                  );
                  Marker _resultMarker = Marker(
                    markerId: MarkerId(currentLocation.toString()),
                    position: LatLng(currentLocation.latitude, currentLocation.longitude),
                  );
                  _markers.add(_resultMarker);
                });
              }
            });
            //Navigator.of(context).pop();
          }else{
            Navigator.of(context).pop();
          }
        });
      }else{
        _streamSubscription = _location.onLocationChanged().listen((currentLocation){
          _lat = currentLocation.latitude;
          _lng = currentLocation.longitude;
          if(mounted){
            setState(() {
              _cameraPosition = CameraPosition(
                  target: LatLng(currentLocation.latitude, currentLocation.longitude),
                  zoom: 17.0
              );
              Marker _resultMarker = Marker(
                markerId: MarkerId(currentLocation.toString()),
                position: LatLng(currentLocation.latitude, currentLocation.longitude),
              );
              _markers.add(_resultMarker);
            });
          }
        });
      }
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

  _sendSuggestion()async{
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
              Navigator.of(context).pop({'data' : _response.data});
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
    if(result != null && result.containsKey('latLng') != null){
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

  Widget _body(){
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
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await _sharepreferenceshelper.initSharePref();
                                  FireBaseAnalyticsHelper.trackClickEvent(ScreenName.WARD_ADMIN_CONTRIBUTION_SCREEN, ClickEvent.SEND_WARD_ADMIN_CONTRIBUTION_CLICK_EVENT,
                                      _sharepreferenceshelper.getUserUniqueKey());
                                  _sendSuggestion();
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
    return CustomScaffoldWidget(
      title: Text(MyString.txt_suggestion,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(),
      globalKey: _globalKey,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //stop listen location
    _streamSubscription.cancel();
  }
}
