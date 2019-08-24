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

class SuggestionScreen extends StatefulWidget {
  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  List<String> _subjectList = new List<String>();
  String _dropDownSubject = MyString.txt_choose_subject;
  TextEditingController _messController = TextEditingController();
  String _lat, _lng;
  bool _isCon, _isLoading;
  File _image;
  var _location = new Location();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  UserModel _userModel;
  Response _response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subjectList = [_dropDownSubject,'လမ်းပြင်၊ လမ်းပျက်','အမှိုက်','ရေမြောင်း','ရေကြီး၊ ရေလျှံ','မီးကြိုး','တိရိစ္ဆာန်အရေး','ရေပေးဝေရေး','အများပိုင်နေရာ','အခြား'];
    _location.serviceEnabled().then((isEnable){
      if(!isEnable){
        _location.requestService().then((value){
          if(value){
            _location.onLocationChanged().listen((currentLocation){
              _lat = currentLocation.latitude.toString();
              _lng = currentLocation.longitude.toString();
            });
          }else{
            Navigator.of(context).pop();
          }
        });
      }else{
        _location.onLocationChanged().listen((currentLocation){
          _lat = currentLocation.latitude.toString();
          _lng = currentLocation.longitude.toString();
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

  _sendSuggestion()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUniqueKey());
    await _userDb.closeUserDb();
    _userModel = model;
    _response = await ServiceHelper().sendSuggestion(_image.path, _userModel.phoneNo, _dropDownSubject, _messController.text,
        _userModel.uniqueKey, _userModel.name, _lat, _lng, _userModel.currentRegionCode);
    //print('sendsuggest: ${_mess} ${_dropDownSubject} ${_lat} ${_lng}');
    if(_response.statusCode == 200){
      setState(() {
        _isLoading = false;
      });
      _finishDialogBox();
    }else{
      Fluttertoast.showToast(msg: 'Please try again', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
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
                        child: Text(MyString.txt_suggestion_finish,
                          style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),textAlign: TextAlign.center,)),
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

  /*_getLatLng()async{
    var location = await _location.getLocation();
    _lat = location.latitude.toString();
    _lng = location.longitude.toString();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text(MyString.title_suggestion, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.all(0.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    _image!=null?Image.file(_image, width: double.maxFinite, height: 200.0, fit: BoxFit.cover,):
                    Image.asset('images/placeholder.jpg', width: double.maxFinite, height: 200.0, fit: BoxFit.cover,),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                              child: Text(MyString.title_suggestion_subject, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
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
                                style: new TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),
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
                              child: Text(MyString.title_suggestion_mess,
                                style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
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
                              controller: _messController,
                              style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
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
                                if(_messController.text != null && _image != null && _dropDownSubject != MyString.txt_choose_subject && _lat != null && _lng != null){
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _sendSuggestion();
                                  print('latlng: ${_lat} ${_lng}');
                                }
                              }else{
                                Fluttertoast.showToast(msg: 'No internet connection', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                              }
                              if(_messController.text == null){
                                Fluttertoast.showToast(msg: 'Need to fill message', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                              }

                              if(_image == null){
                                Fluttertoast.showToast(msg: 'Need photo', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                              }

                              if(_dropDownSubject == MyString.txt_choose_subject){
                                Fluttertoast.showToast(msg: 'choose subject', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                              }

                              if(_lat == null && _lng == null){
                                Fluttertoast.showToast(msg: 'can\'t get location', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
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
}
