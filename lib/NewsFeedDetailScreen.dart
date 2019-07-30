import 'package:flutter/material.dart';
import 'Model/NewsFeedModel.dart';
import 'helper/myoTawConstant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'package:flutter_html_textview_render/html_text_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Model/NewsFeedPhotoModel.dart';
import 'NewsFeedPhotoDetail.dart';

class NewsFeedDetailScreen extends StatefulWidget {
  NewsFeedModel _model;
  List list = new List();
  NewsFeedDetailScreen(this._model, this.list);
  @override
  _NewsFeedDetailScreenState createState() => _NewsFeedDetailScreenState(this._model, this.list);
}

class _NewsFeedDetailScreenState extends State<NewsFeedDetailScreen> {
  NewsFeedModel _newsFeedModel;
  String _title,_photo,_date, _body;
  List _photoList = new List();
  int _currentPhoto = 0;
  List<Widget> _photoWidget = List();
  List<String> _photoUrl = new List();

  _NewsFeedDetailScreenState(this._newsFeedModel, this._photoList);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNewsFeedData();
    addPhoto();
  }

  void addPhoto(){
    if(_photoList.isNotEmpty){
      var photoModelList = _photoList.map((i) => NewsFeedPhotoModel.fromJson(i));
      for(var i in photoModelList){
        print('photlist: ${i}');
        _photoWidget.add(
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsFeedPhotoDetail(i.photoUrl)));
              },
              child: CachedNetworkImage(
                width: double.maxFinite,
                imageUrl: i.photoUrl!=null?baseUrl.NEWS_FEED_CONTENT_URL+i.photoUrl:'',
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
                placeholder: (context, url) => Center(child: Container(
                  child: Center(child: new CircularProgressIndicator(strokeWidth: 2.0,)), width: double.maxFinite, height: 180.0,)),
                errorWidget: (context, url, error)=> Container(
                  width: double.maxFinite,
                  height: 180.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: Image.asset('images/placeholder_newsfeed.jpg').image, fit: BoxFit.cover)
                  ),
                ),
              ),));
      }
    }
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
              _photoList.isNotEmpty?
          CarouselSlider(
            items: _photoWidget,
            height: 180.0,
            initialPage: 0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 2),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: Duration(seconds: 1),
            scrollDirection: Axis.horizontal,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (i){
              setState(() {
                _currentPhoto = i;
              });
            },)
              :
              CachedNetworkImage(
                width: double.maxFinite,
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
                errorWidget: (context, url, error)=> Container(
                  width: double.maxFinite,
                  height: 180.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: Image.asset('images/placeholder_newsfeed.jpg').image, fit: BoxFit.cover)
                  ),
                ),
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
          )
        ],
      )
    );
  }
}
