import 'package:flutter/material.dart';
import 'helper/myoTawConstant.dart';
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
    _videoPlayerController = VideoPlayerController.network(baseUrl.NEWS_FEED_CONTENT_URL+_videoUrl)
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
          child: Text(errormessage, style: TextStyle(color: Colors.white),),
        );
      }
    );
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
            Chewie(controller: _chewieController,),
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
                  IconButton(icon: Icon(_videoPlayerController.value.isPlaying?_icon=Icons.pause:_icon=Icons.play_arrow,
                    color: Colors.white, size: 40.0,),
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
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
