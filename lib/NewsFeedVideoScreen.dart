import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

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
  _NewsFeedVideoScreenState(this._videoUrl);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
  }
  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: null,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Chewie(controller: _chewieController,),
            ],
          )
      ),
    );
    /*return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: ,
    );*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
