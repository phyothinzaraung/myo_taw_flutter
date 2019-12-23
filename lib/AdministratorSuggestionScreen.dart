import 'dart:async';
import 'dart:io';
import 'package:location/location.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'helper/MyoTawConstant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'helper/SharePreferencesHelper.dart';
import 'Database/UserDb.dart';
import 'model/UserModel.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'AdminLocationUpdateScreen.dart';
import 'myWidget/WarningSnackBarWidget.dart';

class AdministratorSuggestionScreen extends StatefulWidget {
  @override
  _AdministratorSuggestionScreenState createState() => _AdministratorSuggestionScreenState();
}

class _AdministratorSuggestionScreenState extends State<AdministratorSuggestionScreen> {
  List<String> _subjectList = new List<String>();
  String _dropDownSubject = MyString.txt_choose_subject;
  String _mess, _lat, _lng;
  bool _isCon, _isLoading;
  File _image;
  var _location = new Location();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  UserModel _userModel;
  Response _response;
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition;
  StreamSubscription<LocationData> _streamSubscription;
  Set<Marker> _markers = Set();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subjectList = [_dropDownSubject,];
    _subjectList.addAll(MyArray.suggestion_subject);
    _location.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 3000, distanceFilter: 0);
    _location.serviceEnabled().then((isEnable){
      if(!isEnable){
        _location.requestService().then((value){
          if(value){
            _streamSubscription = _location.onLocationChanged().listen((currentLocation){
              _lat = currentLocation.latitude.toString();
              _lng = currentLocation.longitude.toString();
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
          _lat = currentLocation.latitude.toString();
          _lng = currentLocation.longitude.toString();
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

    _isLoading = false;
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

  _sendSuggestion()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    await _userDb.closeUserDb();
    _userModel = model;
    _response = await ServiceHelper().sendSuggestion(_image.path, _userModel.phoneNo, _dropDownSubject, _mess,
        _userModel.uniqueKey, _userModel.name, _lat, _lng, _userModel.currentRegionCode);
    //print('sendsuggest: ${_mess} ${_dropDownSubject} ${_lat} ${_lng}');
    setState(() {
      _isLoading = false;
    });
    if(_response.data != null){
      _finishDialogBox();
    }else{
      //Fluttertoast.showToast(msg: MyString.txt_try_again, fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }
  }

  _finishDialogBox(){
    return showDialog(
        context: context,
        builder: (ctxt){
          return SimpleDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: Image.asset('images/suggestion_no_circle.png', width: 50.0, height: 50.0,)),
                    Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Text(MyString.txt_suggestion_finish, style: TextStyle(fontSize: FontSize.textSizeSmall),textAlign: TextAlign.center,)),
                    Container(
                      width: 200.0,
                      height: 45.0,
                      child: RaisedButton(onPressed: ()async{
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                        }, child: Text(MyString.txt_close, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                        color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                    )
                  ],
                ),
              )
            ],
          );
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

  _navigateToAdminLocationUpdateScreen()async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminLocationUpdateScreen()));
    if(result != null && result.containsKey('latLng') != null){
      setState(() {
        LatLng latLng = result['latLng'];
        _lat = latLng.latitude.toString();
        _lng = latLng.longitude.toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(MyString.txt_suggestion, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: modalProgressIndicator(),
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
                                CircularProgressIndicator()
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
                            height: 45.0,
                            margin: EdgeInsets.only(bottom: 10.0),
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
                          margin: EdgeInsets.only(bottom: 10.0),
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
                        ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                              child: Text(MyString.title_suggestion_subject, style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            padding: EdgeInsets.symmetric(horizontal: 7.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(
                                    color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.80
                                )
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                style: new TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.black87),
                                isExpanded: true,
                                iconEnabledColor: MyColor.colorPrimary,
                                value: _dropDownSubject,
                                onChanged: (String value){
                                  setState(() {
                                    _dropDownSubject = value;
                                  });
                                },
                                items: _subjectList.map<DropdownMenuItem<String>>((String str){
                                  return DropdownMenuItem<String>(
                                    value: str,
                                    child: Text(str),
                                  );
                                }).toList(),
                              ),
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
                              decoration: InputDecoration(
                                  border: InputBorder.none
                              ),
                              style: TextStyle(fontSize: FontSize.textSizeNormal),
                              onChanged: (value){
                                _mess = value;
                              },
                            ),
                          ),
                          Container(
                            height: 45.0,
                            width: double.maxFinite,
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: RaisedButton(onPressed: ()async{
                              await _checkCon();
                              //await _getLatLng();
                              if(_isCon){
                                if(_mess != null && _image != null && _dropDownSubject != MyString.txt_choose_subject && _lat != null && _lng != null){
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _sendSuggestion();
                                }else if(_image == null){
                                  //Fluttertoast.showToast(msg: MyString.txt_need_suggestion_photo, fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                                  WarningSnackBar(_globalKey, MyString.txt_need_suggestion_photo);
                                }else if(_dropDownSubject == MyString.txt_choose_subject){
                                  //Fluttertoast.showToast(msg: MyString.txt_need_subject, fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                                  WarningSnackBar(_globalKey, MyString.txt_need_subject);
                                }else if(_mess == null){
                                  //Fluttertoast.showToast(msg: MyString.txt_need_suggestion, fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                                  WarningSnackBar(_globalKey, MyString.txt_need_suggestion);
                                }else if(_lat == null && _lng == null){
                                  //Fluttertoast.showToast(msg: MyString.txt_need_suggestion_location, fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                                  WarningSnackBar(_globalKey, MyString.txt_need_suggestion_location);
                                }
                              }else{
                                //Fluttertoast.showToast(msg: MyString.txt_no_internet, fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                                WarningSnackBar(_globalKey, MyString.txt_no_internet);
                              }


                              }, child: Text(MyString.txt_save_user_profile, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                              color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
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
      ),
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
