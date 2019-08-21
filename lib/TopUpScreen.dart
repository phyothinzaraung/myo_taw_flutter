import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';

class TopUpScreen extends StatefulWidget {
  UserModel model;
  TopUpScreen(this.model);
  @override
  _TopUpScreenState createState() => _TopUpScreenState(this.model);
}

class _TopUpScreenState extends State<TopUpScreen> {
  UserModel _userModel;
  _TopUpScreenState(this._userModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.title_top_up, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
            child: Row(
              children: <Widget>[
                Container(margin: EdgeInsets.only(right: 10.0),
                    child: Image.asset('images/online_tax_no_circle.png', width: 30.0, height: 30.0,)),
                Text(MyString.txt_online_tax, style: TextStyle(fontSize: FontSize.textSizeSmall),)
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 330.0,
            child: Card(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              color: MyColor.colorPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: CircleAvatar(
                        backgroundImage: _userModel.photoUrl==null?AssetImage('images/profile_placeholder.png'):
                        NetworkImage(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl),
                        backgroundColor: MyColor.colorGrey,
                        radius: 60.0,
                      ),
                    ),
                    Container(
                        child: Text(_userModel.name, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)),

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
