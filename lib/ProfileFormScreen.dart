import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';
import 'model/UserModel.dart';
import 'model/LocationModel.dart';
import 'Database/LocationDb.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:connectivity/connectivity.dart';
import 'Database/UserDb.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/CustomProgressIndicator.dart';
import 'myWidget/DropDownWidget.dart';
import 'myWidget/IosPickerWidget.dart';

class ProfileFormScreen extends StatefulWidget {
  bool isAdmin;

  ProfileFormScreen(this.isAdmin);
  @override
  _ProfileFormScreenState createState() => _ProfileFormScreenState(isAdmin);
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  UserModel _userModel;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  String _dropDownState = MyString.txt_choose_state_township;
  String _dropDownTownship = MyString.txt_choose_state_township;
  List<String> _stateList;
  List<String> _townshipList;
  bool _isLoading, _isWardAdmin,_isCon = false;
  LocationDb _locationDb = LocationDb();
  var _response;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();
  UserDb _userDb = UserDb();

  List<Widget> _stateWidgetList = List();
  List<Widget> _townshipWidgetList = List();
  int _statePickerIndex, _townshipPickerIndex;

  _ProfileFormScreenState(this._isWardAdmin);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    _stateList = [_dropDownState];
    _townshipList = [_dropDownTownship];
    _init();

    _statePickerIndex = 0;
    _townshipPickerIndex = 0;
  }

  _initStateIosPickerWidgetList(){
    for(var i in _stateList){
      _stateWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _initTownshipIosPickerWidgetList(){
    for(var i in _townshipList){
      _townshipWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _getUser()async{
    await _sharepreferenceshelper.initSharePref();
    var response = await ServiceHelper().getUserInfo(_sharepreferenceshelper.getUserUniqueKey());
    if(response != DioErrorType.DEFAULT && response.data != null){
      setState(() {
        _userModel = UserModel.fromJson(response.data);
      });
    }else{
      WarningSnackBar(_scaffoldState, MyString.txt_try_again);
    }
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
    print('isCon : ${_isCon}');
  }

  _init()async{
    setState(() {
      _isLoading = true;
    });
    try{

      await _getUser();

      await _locationDb.openLocationDb();
      var stateList = await _locationDb.getState();
      _locationDb.closeLocationDb();
      print(stateList);
      _stateList.addAll(stateList);
      _initStateIosPickerWidgetList();

      //bind user data
      if(_userModel.name != null){
        _nameController.text = _userModel.name;
        _addressController.text = _userModel.address;
        _dropDownState = _userModel.state;
        _dropDownTownship = _userModel.township;
        await _getTownshipByState(_userModel.state);
        _statePickerIndex = _stateList.indexOf(_userModel.state);
        _townshipPickerIndex = _townshipList.indexOf(_userModel.township);
      }
      print(_userModel.toJson());
    }catch (e){
      print(e);
      CustomDialogWidget().customSuccessDialog(
        context: context,
        content: MyString.txt_no_internet,
        img: 'warning.png',
        onPress: (){
          Navigator.of(context).pop();
        }
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  _getTownshipByState(String state)async{
    await _locationDb.openLocationDb();
    var townshipList = await _locationDb.getTownshipByState(state);
    _locationDb.closeLocationDb();
    setState(() {
      _townshipList.addAll(townshipList);
      _initTownshipIosPickerWidgetList();
    });
  }

  void _updateUser()async{
    await _checkCon();
    setState(() {
      _isLoading = true;
    });
    _userModel.name = _nameController.text;
    _userModel.address = _addressController.text;
    _userModel.state = _dropDownState;
    _userModel.township = _dropDownTownship;
    //_userModel.isWardAdmin = 1;//1 is true -- 0 is false
    print('${_userModel.toJson()}');
    try{
      _response = await ServiceHelper().updateUserInfo(_userModel);
      if(_response.data != null){
        await _userDb.openUserDb();
        await _userDb.insert(UserModel.fromJson(_response.data));
        _userDb.closeUserDb();
        //_sharepreferenceshelper.setIsWardAdmin(_userModel.isWardAdmin==1? true : false);
        CustomDialogWidget().customSuccessDialog(
          context: context,
          content: MyString.txt_profile_complete,
          img: 'isvalid.png',
          onPress: (){
            Navigator.of(context).pop();
            Navigator.of(context).pop({'isNeedRefresh' : true});
          },
        );
      }else{
        WarningSnackBar(_scaffoldState, MyString.txt_try_again);
      }
    }catch(e){
      print(e);
      WarningSnackBar(_scaffoldState, MyString.txt_try_again);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _body(){
    return Center(
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: CustomProgressIndicatorWidget(),
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  color: MyColor.colorPrimary,
                  width: double.maxFinite,
                  height: 250,
                ),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: 'profile',
                        child: CircleAvatar(backgroundImage: _userModel!=null?_userModel.photoUrl!=null?
                        CachedNetworkImageProvider(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl):
                        AssetImage('images/profile_placeholder.png') : AssetImage('images/profile_placeholder.png'),
                          backgroundColor: MyColor.colorGrey, radius: 50.0,),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0, bottom: 15.0,left: 20.0, right: 20.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          color: Colors.white,
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 40, left: 30, right: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(margin: EdgeInsets.only(bottom: 10.0),
                                    child: Text(MyString.txt_user_name, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),

                                //textfield name
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
                                    controller: _nameController,
                                    style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorTextBlack),
                                  ),
                                ),
                                Container(margin: EdgeInsets.only(top:20.0, bottom: 10.0),
                                    child: Text(MyString.txt_user_address, style: TextStyle(fontSize: FontSize.textSizeSmall ,color: MyColor.colorTextBlack),)),

                                //textfield address
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
                                    controller: _addressController,
                                    style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorTextBlack),
                                  ),
                                ),

                                _isWardAdmin?Container():Container(margin: EdgeInsets.only(top:20.0, bottom: 10.0),
                                    child: Text(MyString.txt_user_state, style: TextStyle(fontSize: FontSize.textSizeSmall ,color: MyColor.colorTextBlack),)),

                                //dropdown state
                                _isWardAdmin?Container():Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      border: Border.all(
                                          color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.80
                                      )
                                  ),
                                  child: PlatformHelper.isAndroid()?

                                  DropDownWidget(
                                    value: _dropDownState,
                                    onChange: (value){
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      setState(() {
                                        _dropDownState = value;
                                      });
                                      _townshipList.clear();
                                      setState(() {
                                        _dropDownTownship = MyString.txt_choose_state_township;
                                      });
                                      _townshipList = [_dropDownTownship];
                                      _getTownshipByState(value);
                                    },
                                    list: _stateList,
                                  ) :
                                  IosPickerWidget(
                                    onPress: (){
                                      setState(() {
                                        _dropDownState = _stateList[_statePickerIndex];
                                      });
                                      _townshipList.clear();
                                      _townshipWidgetList.clear();
                                      setState(() {
                                        _dropDownTownship = MyString.txt_choose_state_township;
                                      });
                                      _townshipList = [_dropDownTownship];
                                      _getTownshipByState(_dropDownState);
                                      Navigator.pop(context);
                                    },
                                    onSelectedItemChanged: (index){
                                      _statePickerIndex = index;
                                    },
                                    fixedExtentScrollController: FixedExtentScrollController(initialItem: _statePickerIndex),
                                    text: _dropDownState,
                                    children: _stateWidgetList,
                                  ),
                                ),

                                //dropdown township
                                _isWardAdmin?Container():Container(margin: EdgeInsets.only(top:20.0, bottom: 10.0),
                                    child: Text(MyString.txt_user_township, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                                _isWardAdmin?Container():Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      border: Border.all(
                                          color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.80
                                      )
                                  ),
                                  child: PlatformHelper.isAndroid()?

                                  DropDownWidget(
                                    value: _dropDownTownship,
                                    onChange: (value){
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      setState(() {
                                        _dropDownTownship = value;
                                      });
                                    },
                                    list: _townshipList,
                                  ) :
                                  IosPickerWidget(
                                    onPress: (){
                                      setState(() {
                                        _dropDownTownship = _townshipList[_townshipPickerIndex];
                                      });
                                      Navigator.pop(context);
                                    },
                                    onSelectedItemChanged: (index){
                                      _townshipPickerIndex = index;
                                    },
                                    fixedExtentScrollController: FixedExtentScrollController(initialItem: _townshipPickerIndex),
                                    text: _dropDownTownship,
                                    children: _townshipWidgetList,
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 40.0),
                                  width: double.maxFinite,
                                  child: CustomButtonWidget(
                                    onPress: ()async{
                                      await _checkCon();
                                      if(_userModel != null){
                                        if(_isCon){
                                          if(_nameController.text.isNotEmpty && _addressController.text.isNotEmpty && _dropDownState != MyString.txt_choose_state_township &&
                                              _dropDownTownship != MyString.txt_choose_state_township
                                          ){
                                            _updateUser();
                                          }else{
                                            WarningSnackBar(_scaffoldState, MyString.txt_need_user_information);
                                          }
                                        }else{
                                          WarningSnackBar(_scaffoldState, MyString.txt_no_internet);
                                        }
                                      }else{
                                        _init();
                                      }


                                    },color: MyColor.colorPrimary,
                                    borderRadius: BorderRadius.circular(10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    child: Text(_userModel!=null?
                                    MyString.txt_save_user_profile :
                                      MyString.txt_try_again, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(MyString.title_profile,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(),
      globalKey: _scaffoldState,
    );
  }
}
