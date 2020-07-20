
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'helper/MyoTawConstant.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class NewsFeedVideoScreen extends StatefulWidget {
  String url;
  NewsFeedVideoScreen(this.url);
  @override
  _NewsFeedVideoScreenState createState() => _NewsFeedVideoScreenState(this.url);
}

class _NewsFeedVideoScreenState extends State<NewsFeedVideoScreen> {
  String _videoUrl;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  bool _isLoading;
  var _downloadVideo;
  ReceivePort _port = ReceivePort();
  var _localPath;
  _NewsFeedVideoScreenState(this._videoUrl);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_initDownload();
    _videoPlayerController = VideoPlayerController.network(BaseUrl.NEWS_FEED_CONTENT_URL+_videoUrl)
    ..initialize().then((_){
        setState(() {

        });
    });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      aspectRatio: 16/9,
      allowFullScreen: false,
      looping: false,
      errorBuilder: (context, errormessage){
        return Center(
          child: Text('Need internet connection to watch video', style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),),
        );
      }
    );

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  /*_initDownload()async{
    await FlutterDownloader.initialize(debug: true);
  }*/


  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: null,
      action: <Widget>[
        GestureDetector(
          onTap: ()async{
            final _directoryPath = Directory('/storage/emulated/0/');

            _localPath = _directoryPath.path + 'Myotaw download';
            final dir = Directory(_localPath);
            bool hasExist = await dir.exists();
            if (!hasExist) {
              dir.create();
            }
            print('download dir : ${dir.path}');

            _downloadVideo = await FlutterDownloader.enqueue(
                url: BaseUrl.NEWS_FEED_CONTENT_URL+_videoUrl,
                savedDir:  _localPath,
              showNotification: true,
              openFileFromNotification: true
            );

            FlutterDownloader.loadTasks();
          },

            child: Icon(Icons.file_download)
        ),
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
