import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';
import 'package:myotaw/ProfileScreen.dart';
import 'SaveNewsFeedScreen.dart';
import 'FaqScreen.dart';

class DashBoardScreen extends StatefulWidget {
  UserModel model;
  DashBoardScreen(this.model);
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState(this.model);
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  UserModel _userModel;
  String _city;
  List _widget = new List();

  _DashBoardScreenState(this._userModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initHeaderTitle();
    _addWidget();
    if(_userModel.resource != 'Android'){
      _widget.removeLast();
    }
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

  _addWidget(){
    _widget = [
      //dao
      GestureDetector(
        child: Column(children: <Widget>[
            Flexible(flex: 2,child: Image.asset('images/dao.png',width: 120, height: 120,)),
            Flexible(flex: 1,child: Text(MyString.txt_municipal,style: TextStyle(fontSize: FontSize.textSizeSmall),))],),
      ),
      //about tax
      GestureDetector(
        child: Column(children: <Widget>[
          Flexible(flex: 2,child: Image.asset('images/about_tax.png',width: 120, height: 120,)),
          Flexible(flex: 1,child: Text(MyString.txt_tax,style: TextStyle(fontSize: FontSize.textSizeSmall)))],),
      ),
      //suggestion
      GestureDetector(
        child: Column(children: <Widget>[
          Flexible(flex: 2,child: Image.asset('images/suggestion.png',width: 120, height: 120,)),
          Flexible(flex: 1,child: Text(MyString.txt_suggestion,style: TextStyle(fontSize: FontSize.textSizeSmall)))],),
      ),
      //business license
      GestureDetector(
        child: Column(children: <Widget>[
          Flexible(flex: 2,child: Image.asset('images/business_license.png',width: 120, height: 120,)),
          Flexible(flex: 1,child: Text(MyString.txt_business_tax,style: TextStyle(fontSize: FontSize.textSizeSmall)))],),
      ),
      //online tax
      GestureDetector(
        child: Column(children: <Widget>[
          Flexible(flex: 2,child: Image.asset('images/online_tax.png',width: 120, height: 120,)),
          Flexible(flex: 1,child: Text(MyString.txt_online_tax,style: TextStyle(fontSize: FontSize.textSizeSmall)))],),
      ),
      //tax use
      GestureDetector(
        child: Column(children: <Widget>[
          Flexible(flex: 2,child: Image.asset('images/tax_used.png',width: 120, height: 120,)),
          Flexible(flex: 1,child: Text(MyString.txt_tax_use,style: TextStyle(fontSize: FontSize.textSizeSmall)))],),
      ),
      //calculate tax
      GestureDetector(
        child: Column(children: <Widget>[
          Flexible(flex: 2,child: Image.asset('images/calculate_tax.png',width: 120, height: 120,)),
          Flexible(flex: 1,child: Text(MyString.txt_calculate_tax,style: TextStyle(fontSize: FontSize.textSizeSmall)))],),
      ),
      //faq
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FaqScreen()));
        },
        child: Column(children: <Widget>[
          Flexible(flex: 2,child: Image.asset('images/questions.png',width: 120, height: 120,)),
          Flexible(flex: 1,child: Text(MyString.txt_faq,style: TextStyle(fontSize: FontSize.textSizeSmall)))],),
      ),
      //save news feed
      GestureDetector(
        onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SaveNewsFeedScreen()));
        },
        child: Column(children: <Widget>[
          Flexible(flex: 2,child: Image.asset('images/save_file.png',width: 120, height: 120,)),
          Flexible(flex: 1,child: Text(MyString.txt_save_newsFeed,style: TextStyle(fontSize: FontSize.textSizeSmall)))],),
      ),
      //profile
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfileScreen(_userModel)));
        },
        child: Column(children: <Widget>[
          Flexible(flex: 2,child: Image.asset('images/profile_placeholder.png',width: 120, height: 120,)),
          Flexible(flex: 1,child: Text(MyString.txt_profile,style: TextStyle(fontSize: FontSize.textSizeSmall)))],),
      ),
      //referral
      GestureDetector(
        child: Column(children: <Widget>[
          Flexible(flex: 2,child: Image.asset('images/referral.png',width: 120, height: 120,)),
          Flexible(flex: 1,child: Text(MyString.txt_referral,style: TextStyle(fontSize: FontSize.textSizeSmall)))],),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
            delegate: SliverChildListDelegate([
              Container(
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
                              Text('သတင်းများ', style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeExtraNormal),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ])),
            SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index){
                  return _widget[index];
                },childCount: _widget.length),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    crossAxisSpacing: 50.0))
          ],
        )
      )
    );
  }
}
