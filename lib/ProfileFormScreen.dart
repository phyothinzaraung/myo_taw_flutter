import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';
import 'model/LocationModel.dart';
import 'Database/LocationDb.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:connectivity/connectivity.dart';
import 'Database/UserDb.dart';

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
  String _dropDownState = 'နေရပ်ရွေးပါ';
  String _dropDownTownship = 'နေရပ်ရွေးပါ';
  List<String> _stateList;
  List<String> _townshipList;
  bool _isLoading, _isWardAdmin,_isCon = false;
  LocationDb _locationDb = LocationDb();
  var _response;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  GlobalKey<ScaffoldState> _scaffoldState = new GlobalKey<ScaffoldState>();
  UserDb _userDb = UserDb();

  _ProfileFormScreenState(this._isWardAdmin);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
    _init();
    _stateList = [_dropDownState];
    _townshipList = [_dropDownTownship];
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
    try{
      setState(() {
        _isLoading = true;
      });

      await _getUser();
      _nameController.text = _userModel.name;
      _addressController.text = _userModel.address;
      await _locationDb.openLocationDb();
      var state = await _locationDb.getState();
      await _locationDb.closeLocationDb();
      for(var i in state){
        _stateList.add(i);
        print('stateList: ${i}');
      }
      await _getTownshipByState(_userModel.state);
      print(_userModel.toJson());
      setState(() {
        if(!_sharepreferenceshelper.isWardAdmin()){
          _dropDownState = _userModel.state;
          _dropDownTownship = _userModel.township;
        }
        _isLoading = false;
      });
    }catch (e){
      print(e);
      _getFailUserInfoDialogBox();
    }
    print('initlocation');
  }

  _getTownshipByState(String state)async{
    await _locationDb.openLocationDb();
    var township = await _locationDb.getTownshipByState(state);
    await _locationDb.closeLocationDb();

    for(var i in township){
      _townshipList.add(i);
      print('townshipList: ${i}');
    }
    setState(() {

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
                  child: Text('Loading......',style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack))),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColor.colorPrimary))
            ],
          ),
        ),
      ),
    );
  }

  _getFailUserInfoDialogBox(){
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
                          child: Image.asset('images/warning.png', width: 50.0, height: 50.0,)),
                      Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(MyString.txt_no_internet,
                            style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),textAlign: TextAlign.center,)),
                      Container(
                        width: 200.0,
                        height: 45.0,
                        child: RaisedButton(onPressed: (){
                          Navigator.of(context).pop();
                          _init();

                        }, child: Text(MyString.txt_try_again, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                          color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                      )
                    ],
                  ),
                )
              ],
            ), onWillPop: (){},
          );
        }, barrierDismissible: false);
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
                          child: Image.asset('images/isvalid.png', width: 50.0, height: 50.0,)),
                      Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(MyString.txt_profile_complete,
                            style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),textAlign: TextAlign.center,)),
                      Container(
                        width: 200.0,
                        height: 45.0,
                        child: RaisedButton(onPressed: ()async{
                          Navigator.of(context).pop();
                          Navigator.of(context).pop({'isNeedRefresh' : true});

                        }, child: Text(MyString.txt_close, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                          color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                      )
                    ],
                  ),
                )
              ],
            ), onWillPop: (){},
          );
        }, barrierDismissible: false);
  }

  void _updateUser()async{
    await _checkCon();
    setState(() {
      _isLoading = true;
    });
    if(_isCon){
      _userModel.name = _nameController.text;
      _userModel.address = _addressController.text;
      if(!_sharepreferenceshelper.isWardAdmin()){
        _userModel.state = _dropDownState;
        _userModel.township = _dropDownTownship;
      }
      //_userModel.isWardAdmin = 1;//1 is true -- 0 is false
      print('${_userModel.toJson()}');
      try{
        _response = await ServiceHelper().updateUserInfo(_userModel);
        if(_response.data != null){
          await _userDb.openUserDb();
          await _userDb.insert(UserModel.fromJson(_response.data));
          await _userDb.closeUserDb();
          //_sharepreferenceshelper.setIsWardAdmin(UserModel.fromJson(_response.data).isWardAdmin==1?true:false);
          _finishDialogBox();
          /*print('usermodel: ${_userModel.name} ${_userModel.address} ${_userModel.state} '
              '${_userModel.township} ${_userModel.currentRegionCode} ${_userModel.androidToken}');*/
        }else{
          WarningSnackBar(_scaffoldState, MyString.txt_try_again);
        }
      }catch(e){
        print(e);
        WarningSnackBar(_scaffoldState, MyString.txt_try_again);
      }

    }else{
      WarningSnackBar(_scaffoldState, MyString.txt_no_internet);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(MyString.title_profile, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          progressIndicator: modalProgressIndicator(),
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
                                        value: _dropDownState,
                                        onChanged: (String value){
                                          setState(() {
                                            _dropDownState = value;
                                          });
                                          _townshipList.clear();
                                          setState(() {
                                            _dropDownTownship = 'နေရပ်ရွေးပါ';
                                          });
                                          _townshipList = [_dropDownTownship];
                                          _getTownshipByState(value);
                                        },
                                        items: _stateList.map<DropdownMenuItem<String>>((String str){
                                          return DropdownMenuItem<String>(
                                            value: str,
                                            child: Text(str),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),

                                  //dropdown township
                                  _isWardAdmin?Container():Container(margin: EdgeInsets.only(top:20.0, bottom: 10.0),
                                      child: Text(MyString.txt_user_township, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                                  _isWardAdmin?Container():Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                        value: _dropDownTownship,
                                        onChanged: (String value){
                                          setState(() {
                                            _dropDownTownship = value;
                                          });
                                        },
                                        items: _townshipList.map<DropdownMenuItem<String>>((String str){
                                          return DropdownMenuItem<String>(
                                            value: str,
                                            child: Text(str),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(top: 40.0),
                                    width: double.maxFinite,
                                    height: 50.0,
                                    child: RaisedButton(
                                      onPressed: (){
                                        _updateUser();
                                      },color: MyColor.colorPrimary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0)
                                      ),
                                      child: Text(MyString.txt_save_user_profile, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),),
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
      ),
    );
  }
}
