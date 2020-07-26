import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:myotaw/helper/PlatformHelper.dart';
import 'package:myotaw/model/NewsFeedPhotoModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'package:myotaw/myWidget/PrimaryColorSnackBarWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'helper/NavigatorHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'NewsFeedPhotoDetailScreen.dart';
import 'helper/NumConvertHelper.dart';
import 'NewsFeedVideoScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/NewsFeedModel.dart';

class NewsFeedDetailScreen extends StatefulWidget {
  NewsFeedModel _model;
  List<NewsFeedPhotoModel> _list = new List();
  NewsFeedDetailScreen(this._model, this._list);
  @override
  _NewsFeedDetailScreenState createState() => _NewsFeedDetailScreenState(this._model, this._list);
}

class _NewsFeedDetailScreenState extends State<NewsFeedDetailScreen> {
  NewsFeedModel _newsFeedModel;
  String _title,_photo,_date, _newsfeedBody, _thumbNail, _videoUrl, _contentType, _audioUrl, _pdfUrl;
  List<NewsFeedPhotoModel> _photoList = new List();
  List<NewsFeedPhotoModel> _list = new List();
  int _currentPhoto = 0;
  List<Widget> _photoWidgetList = List();
  List<Widget> _indicatorWidgetList = List();
  int index = 0;
  ReceivePort _port = ReceivePort();
  var _localPath;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  _NewsFeedDetailScreenState(this._newsFeedModel, this._photoList);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNewsFeedData();
    addPhoto();
    //_initDownload();
  }

  initNewsFeedData(){
    _title = _newsFeedModel.title;
    _photo = _newsFeedModel.photoUrl;
    _date = ShowDateTimeHelper.showDateTimeDifference(_newsFeedModel.accesstime);
    _newsfeedBody = _newsFeedModel.body;
    _thumbNail = _newsFeedModel.thumbnail;
    _videoUrl = _newsFeedModel.videoUrl;
    _contentType = _newsFeedModel.uploadType;
    _audioUrl = _newsFeedModel.audioUrl;
    _pdfUrl = _newsFeedModel.pdfUrl;


    _list.clear();
    if(_photo != null){
      NewsFeedPhotoModel _newsfeedPhotoModel = NewsFeedPhotoModel();
      _newsfeedPhotoModel.photoUrl = _photo;
      _list.add(_newsfeedPhotoModel);
    }
    _list.addAll(_photoList);
  }

  void addPhoto(){
    if(_photoList.isNotEmpty){
      for(var i in _list){
        index++;
        _photoWidgetList.add(
            GestureDetector(
              onTap: (){
                if (_list.isNotEmpty) {
                  NavigatorHelper.myNavigatorPush(context, NewsFeedPhotoDetailScreen(_list, null, _currentPhoto),
                      ScreenName.PHOTO_DETAIL_SCREEN);
                }
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
                      child: Center(child: NativeProgressIndicator()), width: double.maxFinite, height: 200.0,)),
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
    if(_contentType ==  MyString.NEWS_FEED_CONTENT_TYPE_PHOTO){
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
          if (_photo != null) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsFeedPhotoDetailScreen([], _photo,_currentPhoto)));
          }
        },
        child: CachedNetworkImage(
          width: double.maxFinite,
          imageUrl: _photo!=null?BaseUrl.NEWS_FEED_CONTENT_URL+_photo : '',
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
        )
      );
    }else if (_contentType == MyString.NEWS_FEED_CONTENT_TYPE_VIDEO){
      return GestureDetector(
        onTap: (){
          if(_videoUrl != null){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsFeedVideoScreen(_videoUrl)));
          }

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
                  child: Center(child: NativeProgressIndicator()), width: double.maxFinite, height: 150.0,)),
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
    }else{
      return Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: double.maxFinite,
              height: 200,
              color: Colors.white,
            ),
            Image.asset('images/${_newsfeedContentTypeIcon(_contentType)}.png', width: 50,
                height: 50
            ),
          ],
        ),
      );
    }
  }

  String _newsfeedContentTypeIcon(String type){
    var icon = '';
    switch (type){
      case MyString.NEWS_FEED_CONTENT_TYPE_PHOTO:
        icon = 'image';
        break;
      case MyString.NEWS_FEED_CONTENT_TYPE_VIDEO:
        icon = 'video';
        break;
      case MyString.NEWS_FEED_CONTENT_TYPE_AUDIO:
        icon = 'audio';
        break;
      case MyString.NEWS_FEED_CONTENT_TYPE_PDF:
        icon = 'pdf';
        break;
    }

    return icon;

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

  _initDownload(){
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  String _pdfOrAudio(String type){
    if (type == MyString.NEWS_FEED_CONTENT_TYPE_PDF){
      return _pdfUrl;
    }else{
      return _audioUrl;
    }
  }

  _startDownload()async{
    try{
      final _directoryPath = PlatformHelper.isAndroid()? Directory('/storage/emulated/0/') : await getApplicationDocumentsDirectory();

      _localPath = _directoryPath.path + 'Myotaw download';
      final dir = Directory(_localPath);
      bool hasExist = await dir.exists();
      if (!hasExist) {
        dir.create();
      }
      //print('download dir : ${dir.path}, url : ${BaseUrl.NEWS_FEED_CONTENT_URL+ _pdfOrAudio(_contentType)}');

      var fileName = _pdfOrAudio(_contentType);
      var savePath = dir.path + Platform.pathSeparator + fileName;
      if(!await File(savePath).exists()){
        print('downloading');
        await FlutterDownloader.enqueue(
            url: BaseUrl.NEWS_FEED_CONTENT_URL+ _pdfOrAudio(_contentType),
            savedDir:  _localPath,
            showNotification: true,
            openFileFromNotification: true
        );

        FlutterDownloader.loadTasks();
      }else{
        print('already download');
        PrimaryColorSnackBarWidget(_globalKey, MyString.txt_already_download);
      }
    }catch(e){
      print(e);
      WarningSnackBar(_globalKey, MyString.txt_download_fail);
    }
  }


  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  bool _isDownloadIconShown(){
    if(_contentType == MyString.NEWS_FEED_CONTENT_TYPE_PDF || _contentType == MyString.NEWS_FEED_CONTENT_TYPE_AUDIO){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      globalKey: _globalKey,
      title: Text(_title,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(context),
      action: <Widget>[
        _isDownloadIconShown()?IconButton(icon: Icon(Icons.file_download), onPressed: (){
          _startDownload();
        }) : Container()
      ],
      trailing: _isDownloadIconShown()?GestureDetector(
        onTap: (){
          _startDownload();
        },
          child: Icon(Icons.cloud_download, size: 30,)
      ) : Container(width: 0, height: 0,),
    );
  }

}
