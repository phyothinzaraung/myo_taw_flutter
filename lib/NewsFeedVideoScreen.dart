import 'package:flutter/material.dart';
import 'helper/myoTawConstant.dart';
import 'package:custom_chewie/custom_chewie.dart';
import 'package:video_player/video_player.dart';

class NewsFeedVideoScreen extends StatefulWidget {
  String url;
  NewsFeedVideoScreen(this.url);
  @override
  _NewsFeedVideoScreenState createState() => _NewsFeedVideoScreenState(this.url);
}

class _NewsFeedVideoScreenState extends State<NewsFeedVideoScreen> {
  String _videoUrl;
  //VideoPlayerController _videoPlayerController;
  _NewsFeedVideoScreenState(this._videoUrl);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*_videoPlayerController = VideoPlayerController.network(baseUrl.NEWS_FEED_CONTENT_URL+_videoUrl)
    ..initialize().then((_){
        setState(() {

        });
    });*/
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Chewie(VideoPlayerController.network(baseUrl.NEWS_FEED_CONTENT_URL+_videoUrl),
            autoPlay: true,
            aspectRatio: 16/9,
            showControls: true,)
            /*_videoPlayerController.value.initialized?
            AspectRatio(aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),):Container(child: CircularProgressIndicator(),),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.skip_previous, color: Colors.white, size: 40.0,),
                  onPressed: (){
                    print('position: ${_videoPlayerController.value.position}');
                  },),
                  IconButton(icon: Icon(_videoPlayerController.value.isPlaying?Icons.pause:Icons.play_arrow,color: Colors.white, size: 40.0,),
                    onPressed: (){
                    setState(() {
                      _videoPlayerController.value.isPlaying?_videoPlayerController.pause():_videoPlayerController.play();
                    });
                    },),
                  IconButton(icon: Icon(Icons.skip_next,color: Colors.white, size: 40.0,)),
                ],
              ),
            )*/
          ],
        )
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //_videoPlayerController.dispose();
  }
}
