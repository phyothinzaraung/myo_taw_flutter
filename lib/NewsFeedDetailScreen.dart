import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'helper/NavigatorHelper.dart';
import 'model/NewsFeedPhotoModel.dart';
import 'model/NewsFeedModel.dart';
import 'helper/MyoTawConstant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'NewsFeedPhotoDetailScreen.dart';
import 'helper/NumConvertHelper.dart';
import 'NewsFeedVideoScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsFeedDetailScreen extends StatefulWidget {
  NewsFeedModel _model;
  List _list = new List();
  NewsFeedDetailScreen(this._model, this._list);
  @override
  _NewsFeedDetailScreenState createState() => _NewsFeedDetailScreenState(this._model, this._list);
}

class _NewsFeedDetailScreenState extends State<NewsFeedDetailScreen> {
  NewsFeedModel _newsFeedModel;
  String _title,_photo,_date, _newsfeedBody,_type, _thumbNail, _videoUrl;
  List _photoList = new List();
  int _currentPhoto = 0;
  List<Widget> _photoWidgetList = List();
  List<Widget> _indicatorWidgetList = List();
  int index = 0;

  _NewsFeedDetailScreenState(this._newsFeedModel, this._photoList);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNewsFeedData();
    addPhoto();
  }

  initNewsFeedData(){
    setState(() {
      _title = _newsFeedModel.title;
      _photo = _newsFeedModel.photoUrl;
      _date = ShowDateTimeHelper().showDateTimeDifference(_newsFeedModel.accesstime);
      _newsfeedBody = _newsFeedModel.body;
      _type = _newsFeedModel.uploadType=='Photo'?'Photo':'Video';
      _thumbNail = _newsFeedModel.thumbNail;
      _videoUrl = _newsFeedModel.videoUrl;
    });
  }

  void addPhoto(){
    if(_photoList.isNotEmpty){
      var photoModelList = _photoList.map((i) => NewsFeedPhotoModel.fromJson(i));
      for(var i in photoModelList){
        index++;
        _photoWidgetList.add(
            GestureDetector(
              onTap: (){
                NavigatorHelper().MyNavigatorPush(context, NewsFeedPhotoDetailScreen(_photoList, null, _currentPhoto),
                    ScreenName.PHOTO_DETAIL_SCREEN);
              },
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: BaseUrl.NEWS_FEED_CONTENT_URL+i.photoUrl,
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
                  Container(
                    width: double.maxFinite,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6)
                      ),
                      child: Text('${NumConvertHelper.getMyanNumInt(index)}${'.'} ${_title}  ',
                        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeSmall),)),
                ],
              ),));
      }
    }
  }

  _indicatorList(){
    for(int i=0; i<index;i++){
      _indicatorWidgetList.add(Container(
        width: _currentPhoto==i?10.0:8.0,
        height: _currentPhoto==i?10.0:8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPhoto==i?MyColor.colorPrimaryDark:Colors.grey
        ),
      ));
    }
  }

  Widget _isPhotoOrvideo(){
    _indicatorWidgetList.clear();
    _indicatorList();
    if(_type == 'Photo'){
      return _photoList.isNotEmpty?
      Column(
        children: <Widget>[
          CarouselSlider(
            items: _photoWidgetList,
            height: 200.0,
            initialPage: 0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.decelerate,
            pauseAutoPlayOnTouch: Duration(seconds: 1),
            scrollDirection: Axis.horizontal,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (i){
              setState(() {
                _currentPhoto = i;
              });
            },),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _indicatorWidgetList,
          )
        ],
      )
          :
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsFeedPhotoDetailScreen([], _photo,_currentPhoto)));
        },
        child: CachedNetworkImage(
          width: double.maxFinite,
          imageUrl: _photo!=null?BaseUrl.NEWS_FEED_CONTENT_URL+_photo:'',
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
          errorWidget: (context, url, error)=> Container(
            width: double.maxFinite,
            height: 200.0,
            decoration: BoxDecoration(
                image: DecorationImage(image: Image.asset('images/placeholder_newsfeed.jpg').image, fit: BoxFit.cover)
            ),
          ),
        ),
      );
    }else{
      return GestureDetector(
        onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsFeedVideoScreen(_videoUrl)));
        },
        child: Container(
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: _thumbNail??'',
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
                  child: Center(child: new CircularProgressIndicator(strokeWidth: 2.0,)), width: double.maxFinite, height: 150.0,)),
                errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg', fit: BoxFit.cover,height: 200,),
              ),
              Container(
                  width: double.maxFinite,
                  height: 200.0,
                  color: Colors.black.withOpacity(0.6),
                  child: Image.asset('images/video_play.png', scale: 2,)),
            ],
          ),
        ),
      );
    }
  }

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
        Column(
          children: <Widget>[
            _isPhotoOrvideo(),
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
                                child: Text(_date, style: TextStyle(color: MyColor.colorTextGrey, fontSize: FontSize.textSizeSmall),)))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 25.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(child: Text(_title!=null?_title:'---',style: TextStyle(fontSize: FontSize.textSizeSmall)))
                      ],),
                  ),
                  Container(
                    child: Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(child:
                          Html(data: _newsfeedBody!=null?_newsfeedBody:'---',
                            onLinkTap: (url){
                                _launchURL(url);
                              },
                            linkStyle: TextStyle(color: Colors.redAccent, decoration: TextDecoration.underline),
                            ),
                          )
                      ],),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(_title,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(context),
    );
  }
}
