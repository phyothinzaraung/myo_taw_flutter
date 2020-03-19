import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/CustomButtonWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';
import 'model/ApplyBizLicenseModel.dart';
import 'helper/NumConvertHelper.dart';
import 'ApplyBizLicensePhotoListScreen.dart';

class ApplyBizLicenseDetailScreen extends StatelessWidget {
  ApplyBizLicenseModel _applyBizLicenseModel;
  ApplyBizLicenseDetailScreen(this._applyBizLicenseModel);

  Widget _applyBizLicensePhotoListWidget(BuildContext context){
    return Container(
        margin: EdgeInsets.all(10.0),
        decoration: PlatformHelper.isAndroid()? null :
        BoxDecoration(
            border: Border.all(color: MyColor.colorPrimary, width: 1),
            borderRadius: BorderRadius.circular(10)
        ),
        child: CustomButtonWidget(
          onPress: ()async{
            NavigatorHelper.myNavigatorPush(context, ApplyBizLicensePhotoListScreen(_applyBizLicenseModel), ScreenName.APPLY_BIZ_LICENSE_PHOTO_LIST_SCREEN);
          },
          color: Colors.white,
          shape: RoundedRectangleBorder(side: BorderSide(color: MyColor.colorPrimary,), borderRadius: BorderRadius.circular(5.0)),
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Text(MyString.txt_need_paper_work, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
        )
    );
  }


  Widget _body(BuildContext context){
    return ListView(
      children: <Widget>[
        _applyBizLicensePhotoListWidget(context),
        Card(
          margin: EdgeInsets.only(bottom: 50.0),
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          child: Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0, top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //text biz license information title
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(MyString.txt_biz_license_information, style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),)),
                //text bizname
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_biz_name, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.bizName.isNotEmpty?_applyBizLicenseModel.bizName:'-----',
                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                //text biz type
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_biz_type, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.bizType, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                //text biz area
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_area, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(NumConvertHelper.getMyanNumDou(_applyBizLicenseModel.length)+'  '+'${MyString.txt_unit_feet}',
                        style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),),
                      Expanded(child: Text(NumConvertHelper.getMyanNumDou(_applyBizLicenseModel.width)+'  '+'${MyString.txt_unit_feet}',
                        style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),))
                    ],
                  ),
                ),
                //text location
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(MyString.txt_biz_location, style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),)),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: <Widget>[
                      // text biz region no
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: Text(MyString.txt_biz_region_no, style: TextStyle(fontSize: FontSize.textSizeNormal,color: MyColor.colorTextBlack),)),
                            Text(_applyBizLicenseModel.bizRegionNo.isNotEmpty?_applyBizLicenseModel.bizRegionNo:'-----',
                              style: TextStyle(fontSize: FontSize.textSizeNormal,color: MyColor.colorTextBlack),)
                          ],
                        ),
                      ),
                      //text biz street name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: Text(MyString.txt_biz_street_name, style: TextStyle(fontSize: FontSize.textSizeNormal,color: MyColor.colorTextBlack),)),
                            Text(_applyBizLicenseModel.bizStreetName.isNotEmpty?_applyBizLicenseModel.bizStreetName:'-----',
                              style: TextStyle(fontSize: FontSize.textSizeNormal,color: MyColor.colorTextBlack),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //text biz block no
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_biz_block_no, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.bizBlockNo.isNotEmpty?_applyBizLicenseModel.bizBlockNo:'-----', style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                //text biz state
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_state, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.bizState, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                //text biz township
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_township, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.bizTownship, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
              ],
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.all(0.0),
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          child: Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0, top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //text biz license information title
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(MyString.txt_owner_information, style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),)),
                //text owner name
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_owner_name, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.ownerName, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                //text nrc no
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_owner_nrc_no, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.nrcNo, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                //text biz ph no
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_owner_ph_no, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.phoneNo, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                //text location
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(MyString.txt_biz_location, style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),)),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: <Widget>[
                      // text owner region no
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: Text(MyString.txt_owner_region_no, style: TextStyle(fontSize: FontSize.textSizeNormal,color: MyColor.colorTextBlack),)),
                            Text(_applyBizLicenseModel.regionNo.isNotEmpty?_applyBizLicenseModel.regionNo:'-----',
                              style: TextStyle(fontSize: FontSize.textSizeNormal,color: MyColor.colorTextBlack),)
                          ],
                        ),
                      ),
                      //text owner street name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(bottom: 5.0),
                                child: Text(MyString.txt_owner_street_name, style: TextStyle(fontSize: FontSize.textSizeNormal,color: MyColor.colorTextBlack),)),
                            Text(_applyBizLicenseModel.streetName.isNotEmpty?_applyBizLicenseModel.streetName:'-----',
                              style: TextStyle(fontSize: FontSize.textSizeNormal,color: MyColor.colorTextBlack),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //text owner block no
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_owner_block_no, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.blockNo.isNotEmpty?_applyBizLicenseModel.blockNo:'-----', style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                //text owner state
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_state, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.state, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                //text owner township
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_township, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.township, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                //text remark
                Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_remark, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(_applyBizLicenseModel.remark.isNotEmpty?_applyBizLicenseModel.remark:'-----',
                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)),
              ],
            ),
          ),
        ),
        _applyBizLicensePhotoListWidget(context),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(_applyBizLicenseModel.bizName.isNotEmpty?_applyBizLicenseModel.bizName:'---',maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(context),
    );
  }
}
