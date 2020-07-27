import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myotaw/model/NewsFeedPhotoModel.dart';
import 'package:myotaw/model/NewsFeedViewModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/services.dart';

import 'myWidget/PrimaryColorSnackBarWidget.dart';
import 'myWidget/WarningSnackBarWidget.dart';

class NewsFeedPhotoDetailScreen extends StatelessWidget {
  List<NewsFeedPhotoModel> _photoList = new List();
  String _photoUrl;
  PageController _pageController;
  List<Widget> _photoWidget = new List();
  int _initialPage = 0;
  ReceivePort _port = ReceivePort();
  var _localPath;
  var _downloadVideo;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  NewsFeedPhotoDetailScreen(this._photoList, this._photoUrl, this._initialPage);

  void addPhoto() {
    for (var i in _photoList) {
      _photoWidget.add(PhotoView(
        imageProvider:
        NetworkImage(BaseUrl.NEWS_FEED_CONTENT_URL + i.photoUrl),
        loadingChild: _nativeProgressIndicator(),
        loadFailedChild: Image.asset('images/placeholder.jpg'),
      ));
    }
  }

  Widget _nativeProgressIndicator() {
    return PlatformHelper.isAndroid()
        ? Center(child: CircularProgressIndicator())
        : CupertinoTheme(
            data: CupertinoThemeData(brightness: Brightness.dark),
            child: CupertinoActivityIndicator(
              radius: 15,
            ));
  }

  _initDownload(){
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    /*_port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });*/

    FlutterDownloader.registerCallback(downloadCallback);
  }


  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
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
      print('download dir : ${dir.path}');
      var fileName = _photoList.isNotEmpty?_photoList[_initialPage].photoUrl : _photoUrl;
      var savePath = dir.path + Platform.pathSeparator + fileName;

      if(!await File(savePath).exists()){
        _downloadVideo = await FlutterDownloader.enqueue(
            url: BaseUrl.NEWS_FEED_CONTENT_URL+'${_photoList.isNotEmpty?_photoList[_initialPage].photoUrl : _photoUrl}',
            savedDir:  _localPath,
            showNotification: true,
            openFileFromNotification: true
        );

        FlutterDownloader.loadTasks();
      }else{
        PrimaryColorSnackBarWidget(_globalKey, MyString.txt_already_download);
      }
    }catch(e){
      print(e);
      WarningSnackBar(_globalKey, MyString.txt_download_fail);
    }

  }

  @override
  Widget build(BuildContext context) {
    _pageController = new PageController(initialPage: _initialPage);
    addPhoto();
    _pageController.addListener(() {
      _initialPage = _pageController.page.toInt();
    });
    return CustomScaffoldWidget(
      globalKey: _globalKey,
      title: null,
      trailing: GestureDetector(
          onTap: (){
            _startDownload();
          },
          child: Icon(Icons.cloud_download, size: 30,)
      ),
      action: <Widget>[
        IconButton(icon: Icon(Icons.file_download), onPressed: ()async{
          _startDownload();
          /*try {
            var imageId =
            await ImageDownloader.downloadImage(BaseUrl.NEWS_FEED_CONTENT_URL + '${_photoList.isNotEmpty?_photoList[_initialPage].photoUrl : _photoUrl}',);
            Fluttertoast.showToast(
                msg: MyString.txt_save_newsFeed_success,
                toastLength: Toast.LENGTH_SHORT);
            print('imageid : $imageId');
            if (imageId == null) {
              return;
            }
          } on PlatformException catch (error) {
            print(error);
          }*/
        })
      ],
      body: Container(
        color: Colors.black,
        child: Center(
          child: _photoList.isNotEmpty
              ? PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  children: _photoWidget)
              : PhotoView(
                  imageProvider:
                      NetworkImage(BaseUrl.NEWS_FEED_CONTENT_URL + _photoUrl),
                  loadingChild: _nativeProgressIndicator(),
                  loadFailedChild: Image.asset('images/placeholder.jpg'),
                ),
        ),
      ),
    );
  }
}
