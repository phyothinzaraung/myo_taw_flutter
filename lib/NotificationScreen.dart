import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';
import 'helper/SharePreferencesHelper.dart';
import 'Database/UserDb.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  UserModel _userModel;
  String _city;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  _getUser()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    await _userDb.closeUserDb();
    setState(() {
      _userModel = model;
    });
    _initHeaderTitle();
  }

  _initHeaderTitle(){
    switch(_userModel.currentRegionCode){
      case MyString.TGY_REGIONCODE:
        _city = MyString.TGY_CITY;
        break;
      case MyString.MLM_REGIONCODE:
        _city = MyString.MLM_CITY;
        break;
      case MyString.MDY_REGIONCODE:
        _city = MyString.MDY_CITY;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_city!=null?_city:'', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeLarge)),
                          Text(MyString.txt_title_notification, style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
