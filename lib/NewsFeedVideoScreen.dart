
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'helper/MyoTawConstant.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

import 'myWidget/PrimaryColorSnackBarWidget.dart';
import 'myWidget/WarningSnackBarWidget.dart';

class NewsFeedVideoScreen extends StatefulWidget {
  final String url;
  NewsFeedVideoScreen(this.url);
  @override
  _NewsFeedVideoScreenState createState() => _NewsFeedVideoScreenState();
}

class _NewsFeedVideoScreenState extends State<NewsFeedVideoScreen> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  var _downloadVideo;
  ReceivePort _port = ReceivePort();
  var _localPath;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController = VideoPlayerController.network(BaseUrl.NEWS_FEED_CONTENT_URL+widget.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      aspectRatio: 16/9,
      allowFullScreen: true,
      looping: false,
      autoInitialize: true,
      errorBuilder: (context, errorMsg){
        return Center(
          child: Text(MyString.txt_no_internet, style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),),
        );
      }
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


  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  _startDownload()async{
    try{
      final _directoryPath = Directory('/storage/emulated/0/');

      _localPath = _directoryPath.path + 'Myotaw download';
      final dir = Directory(_localPath);
      bool hasExist = await dir.exists();
      if (!hasExist) {
        dir.create();
      }
      print('download dir : ${dir.path}');
      var fileName = widget.url;
      var savePath = dir.path + Platform.pathSeparator + fileName;

      if(!await File(savePath).exists()){
        _downloadVideo = await FlutterDownloader.enqueue(
            url: BaseUrl.NEWS_FEED_CONTENT_URL+widget.url,
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
    return CustomScaffoldWidget(
      globalKey: _globalKey,
      title: null,
      action: <Widget>[
        IconButton(icon: Icon(Icons.file_download), onPressed: (){
          _startDownload();
        })
      ],
      body: Container(
        color: Colors.black,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Chewie(controller: _chewieController,),
              ],
            )
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
}
