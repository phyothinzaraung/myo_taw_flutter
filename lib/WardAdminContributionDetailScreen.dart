import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/PhotoDetailScreen.dart';
import 'package:myotaw/model/ContributionModel.dart';

import 'helper/MyoTawConstant.dart';

class WardAdminContributionDetailScreen extends StatelessWidget {
  ContributionModel _contributionModel;
  WardAdminContributionDetailScreen(this._contributionModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_contributionModel.subject, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoDetailScreen(BaseUrl.CONTRIBUTE_PHOTO_URL+_contributionModel.photoUrl)));
            },
            child: Hero(
              tag: _contributionModel.photoUrl,
              child: CachedNetworkImage(
                imageUrl: _contributionModel.photoUrl!=null?BaseUrl.CONTRIBUTE_PHOTO_URL+_contributionModel.photoUrl:'',
                imageBuilder: (context, image){
                  return Container(
                    width: double.maxFinite,
                    height: 200.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: image,
                          fit: BoxFit.cover),
                    ),);
                },
                placeholder: (context, url) => Center(child: Container(
                  child: Center(child: new CircularProgressIndicator(strokeWidth: 2.0,)), width: double.maxFinite, height: 200.0,)),
                errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg', width: double.maxFinite, height: 200,fit: BoxFit.cover,),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(MyString.txt_contribute_fact,
                      style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorTextBlack),)),
                Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(_contributionModel.message,
                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),))
              ],
            ),
          )
        ],
      ),
    );
  }
}
