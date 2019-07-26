import 'package:flutter/material.dart';
import 'Model/NewsFeedModel.dart';
import 'helper/myoTawConstant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'package:flutter_html_textview_render/html_text_view.dart';

class NewsFeedDetailScreen extends StatefulWidget {
  NewsFeedModel _model;
  NewsFeedDetailScreen(this._model);
  @override
  _NewsFeedDetailScreenState createState() => _NewsFeedDetailScreenState(this._model);
}

class _NewsFeedDetailScreenState extends State<NewsFeedDetailScreen> {
  NewsFeedModel _newsFeedModel;
  String _title,_photo,_date, _body;


  _NewsFeedDetailScreenState(this._newsFeedModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNewsFeedData();
  }

  initNewsFeedData(){
    setState(() {
      _title = _newsFeedModel.title;
      _photo = _newsFeedModel.photoUrl;
      _date = showDateTime(_newsFeedModel.accesstime);
      _body = _newsFeedModel.body;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title, style: TextStyle(fontSize: fontSize.textSizeNormal),),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: _photo!=null?baseUrl.NEWS_FEED_CONTENT_URL+_photo:'',
                imageBuilder: (context, image){
                  return Container(
                    width: double.maxFinite,
                    height: 180.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: image,
                          fit: BoxFit.cover),
                    ),);
                },
                errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg'),
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
                                  child: Text(_date, style: TextStyle(color: myColor.colorTextGrey, fontSize: fontSize.textSizeSmall),)))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 25.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(child: Text(_title!=null?_title:'---',style: TextStyle(fontSize: fontSize.textSizeLarge)))
                        ],),
                    ),
                    Container(
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(child: HtmlTextView(data: _body!=null?_body:'---',))
                        ],),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}
