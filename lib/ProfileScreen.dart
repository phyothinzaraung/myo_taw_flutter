import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';
import 'helper/MyanNumConvertHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'helper/UserDb.dart';
import 'SplashScreen.dart';

class ProfileScreen extends StatefulWidget {
  UserModel model;
  ProfileScreen(this.model);
  @override
  _ProfileScreenState createState() => _ProfileScreenState(this.model);
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel _userModel;
  UserDb _userDb;
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  _ProfileScreenState(this._userModel);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _logOutClear()async{
    await _sharepreferenceshelper.initSharePref();
    _userDb = UserDb.instance;
    _sharepreferenceshelper.logOutSharePref();
    _userDb.deleteUser();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()),(Route<dynamic>route) => false);
  }

  _dialogLogOut(){
    showDialog(context: (context),
      builder: (context){
        return SimpleDialog(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(margin: EdgeInsets.only(bottom: 10.0),child: Image.asset('images/logout_icon.png', width: 50.0, height: 50.0,)),
                Container(margin: EdgeInsets.only(bottom: 10.0),child: Text(MyString.txt_are_u_sure,
                  style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: 90.0,
                      child: RaisedButton(onPressed: (){
                        _logOutClear();
                      },child: Text(MyString.txt_log_out,style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                        color: MyColor.colorPrimary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                    ),
                    Container(
                      height: 40.0,
                      width: 90.0,
                      child: RaisedButton(onPressed: (){
                          Navigator.of(context).pop();
                      },child: Text(MyString.txt_log_out_cancel,style: TextStyle(fontSize: FontSize.textSizeSmall),),
                        color: MyColor.colorGrey,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                    )

                  ],
                )
              ],
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_profile, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
              child: Row(
                children: <Widget>[
                  Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/profile.png', width: 30.0, height: 30.0,)),
                  Text(MyString.title_profile, style: TextStyle(fontSize: FontSize.textSizeSmall),)
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              CircleAvatar(backgroundImage: _userModel.photoUrl!=null?
                              NetworkImage(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl):AssetImage('images/profile_placeholder.png'),
                                backgroundColor: MyColor.colorGrey, radius: 50.0,),
                              Image.asset('images/photo_edit.png', width: 25.0, height: 25.0,)
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(margin: EdgeInsets.only(bottom: 10.0),
                                    child: Text(_userModel.name, style: TextStyle(fontSize: FontSize.textSizeSmall,),)),
                                Text(MyanNumConvertHelper().getMyanNumString(_userModel.phoneNo), style: TextStyle(fontSize: FontSize.textSizeSmall),),
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(margin: EdgeInsets.only(bottom: 5.0),child: Text(MyString.txt_setting, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorPrimary),)),
                        Container(
                          child: Row(
                            children: <Widget>[
                                Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/edit_profile.png',width: 30.0, height: 38.0,)),
                                Text(MyString.txt_edit_profile, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                            ],
                          ),
                        ),
                        Divider(color: MyColor.colorPrimary,),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/apply_biz_list.png',width: 30.0, height: 38.0,)),
                              Text(MyString.txt_apply_biz_license, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                            ],
                          ),
                        ),
                        Divider(color: MyColor.colorPrimary,),
                        GestureDetector(
                          onTap: (){
                            _dialogLogOut();
                          },
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/log_out.png',width: 30.0, height: 38.0,)),
                                Text(MyString.txt_log_out, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(MyString.txt_tax_record, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorPrimary),)),
                    Container(
                      height: 50.0,
                      width: 300.0,
                      child: RaisedButton(onPressed: (){
                      },child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(margin: EdgeInsets.only(right: 10.0),child: Text(MyString.txt_tax_new_record, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),),
                          Icon(Icons.add, color: Colors.white,)
                        ],
                      ),color: MyColor.colorPrimary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                    )
                  ],
                ),
            )
          ],
        ),
      ),
    );
  }
}
