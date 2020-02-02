import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'model/SaveNewsFeedModel.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'NewsFeedPhotoDetailScreen.dart';
import 'NewsFeedVideoScreen.dart';

class SaveNewsFeedDetailScreen extends StatefulWidget {
  SaveNewsFeedModel model;
  SaveNewsFeedDetailScreen(this.model);
  @override
  _SaveNewsFeedDetailScreenState createState() => _SaveNewsFeedDetailScreenState(this.model);
}

class _SaveNewsFeedDetailScreenState extends State<SaveNewsFeedDetailScreen> {
  SaveNewsFeedModel _saveNewsFeedModel;
  _SaveNewsFeedDetailScreenState(this._saveNewsFeedModel);

  Widget _body(){
    return ListView(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              _saveNewsFeedModel.contentType==MyString.NEWS_FEED_CONTENT_TYPE_PHOTO?
              _saveNewsFeedModel.photoUrl!=null?GestureDetector(
                onTap: (){
                  NavigatorHelper().MyNavigatorPush(context, NewsFeedPhotoDetailScreen([], _saveNewsFeedModel.photoUrl), ScreenName.PHOTO_DETAIL_SCREEN);
                },
                child: Hero(
                  tag: _saveNewsFeedModel.id,
                  child: Image.network(BaseUrl.NEWS_FEED_CONTENT_URL+_saveNewsFeedModel.photoUrl,
                    width: double.maxFinite, height: 180.0, fit: BoxFit.cover,),
                ),
              ):
              Image.asset('images/placeholder_newsfeed.jpg', width: double.maxFinite, height: 180.0, fit: BoxFit.cover,):
              _saveNewsFeedModel.thumbNail!=null?GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsFeedVideoScreen(_saveNewsFeedModel.videoUrl)));
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.network(_saveNewsFeedModel.thumbNail, width: double.maxFinite,height: 180.0, fit: BoxFit.cover,),
                    Container(width: double.maxFinite, height: 180.0,color: Colors.black.withOpacity(0.6),),
                    Image.asset('images/video_play.png', width: 80.0, height: 80.0, fit: BoxFit.cover,)
                  ],
                ),
              ):
              Image.asset('images/placeholder_newsfeed.jpg', width: double.maxFinite, height: 180.0, fit: BoxFit.cover,),
              Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        children: <Widget>[
                          Image.asset('images/calendar.png',width: 18.0,height: 15.0,),
                          Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  child: Text(ShowDateTimeHelper().showDateTimeDifference(_saveNewsFeedModel.accessTime), style: TextStyle(color: MyColor.colorTextGrey, fontSize: FontSize.textSizeSmall),)))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 25.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(child: Text(_saveNewsFeedModel.title!=null?_saveNewsFeedModel.title:'---',
                              style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack)))
                        ],),
                    ),
                    Container(
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(child: Html(data: _saveNewsFeedModel.body!=null?_saveNewsFeedModel.body:'---',))
                        ],),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(_saveNewsFeedModel.title,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(),
    );
    /*return Scaffold(
      appBar: AppBar(
        title: Text(_saveNewsFeedModel.title, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ,
    );*/
  }
}
