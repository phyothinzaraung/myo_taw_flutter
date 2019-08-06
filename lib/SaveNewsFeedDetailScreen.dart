import 'package:flutter/material.dart';
import 'model/SaveNewsFeedModel.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'package:flutter_html_textview_render/html_text_view.dart';

class SaveNewsFeedDetailScreen extends StatefulWidget {
  SaveNewsFeedModel model;
  SaveNewsFeedDetailScreen(this.model);
  @override
  _SaveNewsFeedDetailScreenState createState() => _SaveNewsFeedDetailScreenState(this.model);
}

class _SaveNewsFeedDetailScreenState extends State<SaveNewsFeedDetailScreen> {
  SaveNewsFeedModel _saveNewsFeedModel;
  _SaveNewsFeedDetailScreenState(this._saveNewsFeedModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_saveNewsFeedModel.title, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Hero(
                  tag: _saveNewsFeedModel.photoUrl,
                  child: _saveNewsFeedModel.photoUrl!=null?Image.network(BaseUrl.NEWS_FEED_CONTENT_URL+_saveNewsFeedModel.photoUrl,
                    width: double.maxFinite, height: 180.0, fit: BoxFit.cover,):
                  Image.asset('images/placeholder_newsfeed.jpg', width: double.maxFinite, height: 180.0, fit: BoxFit.cover,),
                ),
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
                                    child: Text(showDateTime(_saveNewsFeedModel.accessTime), style: TextStyle(color: MyColor.colorTextGrey, fontSize: FontSize.textSizeSmall),)))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 25.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(child: Text(_saveNewsFeedModel.title!=null?_saveNewsFeedModel.title:'---',
                                style: TextStyle(fontSize: FontSize.textSizeNormal)))
                          ],),
                      ),
                      Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(child: HtmlTextView(data: _saveNewsFeedModel.body!=null?_saveNewsFeedModel.body:'---',))
                          ],),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
