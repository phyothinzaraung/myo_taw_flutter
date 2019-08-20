import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'model/BizLicenseModel.dart';
import 'package:flutter_html/flutter_html.dart';
import 'ApplyBizLicenseFormScreen.dart';

class BizLicenseDetailScreen extends StatefulWidget {
  BizLicenseModel model;
  BizLicenseDetailScreen(this.model);
  @override
  _BizLicenseDetailScreenState createState() => _BizLicenseDetailScreenState(this.model);
}

class _BizLicenseDetailScreenState extends State<BizLicenseDetailScreen> {
  BizLicenseModel _bizLicenseModel;
  _BizLicenseDetailScreenState(this._bizLicenseModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_business_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15.0,left: 30.0, right: 30.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/business_license_nocircle.png', width: 30.0, height: 30.0,)),
                      Text(MyString.title_biz_license, style: TextStyle(fontSize: FontSize.textSizeSmall),)
                    ],
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(0.0),
                  elevation: 0.0,
                  child: Container(
                      padding: EdgeInsets.all(30.0),
                      child: Html(data: _bizLicenseModel.requirements,)),
                ),
                _bizLicenseModel.isApplyAllow==true?
                Container(
                  height: 45.0,
                  width: double.maxFinite,
                  margin: EdgeInsets.all(20.0),
                  child: RaisedButton(onPressed: ()async{
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ApplyBizLicenseFormScreen(_bizLicenseModel)));
                    }, child: Text(MyString.txt_apply_license, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                    color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                ) : Container()
              ],
            ),
          ),
        ],
      )
    );
  }
}
