import 'dart:async';
import 'dart:io';
import 'package:location/location.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myotaw/myWidget/CustomButtonWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'helper/FireBaseAnalyticsHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'helper/PlatformHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'Database/UserDb.dart';
import 'model/UserModel.dart';
import 'helper/ServiceHelper.dart';
import 'myWidget/CustomDialogWidget.dart';
import 'myWidget/CustomProgressIndicator.dart';
import 'myWidget/DropDownWidget.dart';
import 'myWidget/IosPickerWidget.dart';
import 'myWidget/WarningSnackBarWidget.dart';
import 'package:flutter/cupertino.dart';

class ContributionScreen extends StatefulWidget {
  @override
  _ContributionScreenState createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {
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
  StreamSubscription<LocationData> _streamSubscription;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  TextEditingController _messController = TextEditingController();
  List<Widget> _subjectWidgetList = List();
  int _pickerIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subjectList = [_dropDownSubject,];
    _subjectList.addAll(MyStringList.suggestion_subject);
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

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
  }

  Future camera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: MyString.PHOTO_MAX_WIDTH, maxHeight: MyString.PHOTO_MAX_HEIGHT);
    setState(() {
      _image = image;
    });
  }

  _sendSuggestion()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userDb.closeUserDb();
    _userModel = model;
    try{
      _response = await ServiceHelper().sendSuggestion(_image.path, _userModel.phoneNo, _dropDownSubject, _messController.text,
          _userModel.uniqueKey, _userModel.name, _lat, _lng, _userModel.currentRegionCode, false, _sharepreferenceshelper.getWardName(),0);
      //print('sendsuggest: ${_mess} ${_dropDownSubject} ${_lat} ${_lng}');
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
              Navigator.of(context).pop({'isNeedRefresh' : true});
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


  Widget _body(BuildContext context){
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CustomProgressIndicatorWidget(),
      child: ListView(
        children: <Widget>[
          headerTitleWidget(MyString.title_suggestion, 'suggestion_no_circle'),
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
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: PlatformHelper.isAndroid()? null :
                          BoxDecoration(
                              border: Border.all(color: MyColor.colorPrimary, width: 1),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: CustomButtonWidget(onPress: ()async{
                            camera();
                            await _sharepreferenceshelper.initSharePref();
                            FireBaseAnalyticsHelper.trackClickEvent(ScreenName.CONTRIBUTION_SCREEN, ClickEvent.CAMERA_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());

                          },child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(right: 30.0),
                                  child: Image.asset('images/camera.png', width: 25.0, height: 25.0,)),
                              Text(MyString.txt_upload_photo_camera, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),)
                            ],
                          ),color: Colors.white,elevation: 5.0,
                            borderRadius: BorderRadius.circular(10),
                            shape: RoundedRectangleBorder(side: BorderSide(color: MyColor.colorPrimary,), borderRadius: BorderRadius.circular(5.0)),),
                        ),

                        Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Text(MyString.title_suggestion_subject, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),

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
                            controller: _messController,
                            maxLines: null,
                            decoration: InputDecoration(
                                border: InputBorder.none
                            ),
                            style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                          ),
                        ),

                        Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: CustomButtonWidget(onPress: ()async{

                            await _checkCon();
                            if(_isCon){
                              if(_messController.text.isNotEmpty && _image != null && _dropDownSubject != MyString.txt_choose_subject){
                                setState(() {
                                  _isLoading = true;
                                });
                                _sendSuggestion();
                                await _sharepreferenceshelper.initSharePref();
                                FireBaseAnalyticsHelper.trackClickEvent(ScreenName.CONTRIBUTION_SCREEN, ClickEvent.SEND_CONTRIBUTION_CLICK_EVENT,
                                    _sharepreferenceshelper.getUserUniqueKey());
                                print('latlng: ${_lat} ${_lng}');
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

                          }, child: Text(MyString.txt_send_contribution, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                            color: MyColor.colorPrimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
      body: _body(context),
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
