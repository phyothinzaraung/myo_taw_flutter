import 'package:flutter/material.dart';
import 'package:myotaw/WardAdminContributionListScreen.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/main.dart';

class WardAdminFeatureChooseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child:
            Text(MyString.txt_choose_feature, style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => WardAdminContributionListScreen()));
              },
              child: Column(
                children: <Widget>[
                  //image dao
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Image.asset('images/suggestion.png', width: 130, height: 130,)),
                  //text title
                  Text(MyString.txt_admin_user,textAlign: TextAlign.center,
                    style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),)],),
            ),
            Divider(
              color: MyColor.colorPrimary,
              thickness: 2,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
              },
              child: Column(
                children: <Widget>[
                  //image dao
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Image.asset('images/profile_placeholder.png', width: 130, height: 130)),
                  //text title
                  Text(MyString.txt_myotaw_user,textAlign: TextAlign.center,
                    style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),)],),
            )
          ],
        ),
      ),
    );
  }
}
