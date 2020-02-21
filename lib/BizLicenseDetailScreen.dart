import 'package:flutter/material.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helper/MyoTawConstant.dart';
import 'model/BizLicenseModel.dart';
import 'package:flutter_html/flutter_html.dart';
import 'ApplyBizLicenseFormScreen.dart';
import 'myWidget/CustomButtonWidget.dart';

class BizLicenseDetailScreen extends StatefulWidget {
  BizLicenseModel model;
  BizLicenseDetailScreen(this.model);
  @override
  _BizLicenseDetailScreenState createState() => _BizLicenseDetailScreenState(this.model);
}

class _BizLicenseDetailScreenState extends State<BizLicenseDetailScreen> {
  BizLicenseModel _bizLicenseModel;
  _BizLicenseDetailScreenState(this._bizLicenseModel);

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _body(BuildContext context){
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0,left: 30.0, right: 30.0, bottom: 15.0),
                //header
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
                //text requirements
                child: Container(
                    padding: EdgeInsets.all(30.0),
                    child: Html(data: _bizLicenseModel.requirements, onLinkTap: (url) => _launchURL(url),linkStyle: TextStyle(color: Colors.redAccent, decoration: TextDecoration.underline),)
                ),
              ),
              _bizLicenseModel.isApplyAllow==true?
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(20.0),
                child: CustomButtonWidget(onPress: ()async{

                  NavigatorHelper.MyNavigatorPushReplacement(context, ApplyBizLicenseFormScreen(_bizLicenseModel), ScreenName.APPLY_BIZ_LICENSE_FORM_SCREEN);
                }, child: Text(MyString.txt_apply_license, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                  color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ) : Container()
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
        title: Text(MyString.txt_business_tax,maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
        body: _body(context)
    );
  }
}
