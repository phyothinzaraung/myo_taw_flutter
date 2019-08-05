import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';

class NotificationScreen extends StatefulWidget {
  UserModel model;
  NotificationScreen(this.model);
  @override
  _NotificationScreenState createState() => _NotificationScreenState(this.model);
}

class _NotificationScreenState extends State<NotificationScreen> {
  UserModel _userModel;
  String _city;
  _NotificationScreenState(this._userModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initHeaderTitle();
  }

  _initHeaderTitle(){
    switch(_userModel.currentRegionCode){
      case MyString.TGY_REGIONCODE:
        _city = MyString.TGY_CITY;
        break;
      case MyString.MLM_REGIONCODE:
        _city = MyString.MLM_CITY;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 48.0, bottom: 20.0, left: 15.0, right: 15.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_city, style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeLarge)),
                        Text('အသိပေးနှိုးဆော်ချက်', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}
