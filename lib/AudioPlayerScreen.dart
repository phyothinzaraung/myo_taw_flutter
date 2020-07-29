
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerScreen extends StatefulWidget {
  String url;
  AudioPlayerScreen({this.url});
  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  var duration;
  var position;
  AudioPlayerState _audioPlayerState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AudioPlayer.logEnabled = true;
   _audioPlayer.onDurationChanged.listen((d) {
     setState(() {
       duration = d;
     });
   });
   _audioPlayer.onAudioPositionChanged.listen((event) {
     setState(() {
       position = event;
     });
   });
   _audioPlayer.onPlayerStateChanged.listen((event) {
     setState(() {
       _audioPlayerState = event;
     });
   });
  }


  _play()async{
    print('audio url: ${widget.url}');
    int result = await _audioPlayer.play(widget.url);
  }

  _pause()async{
    int result = await _audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            IconButton(icon: Icon(Icons.play_arrow), onPressed: (){
              _play();
            }),
            IconButton(icon: Icon(Icons.pause), onPressed: (){
              _pause();
            }),
            Slider(
              onChanged: (value)async{
                await _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                setState(() {
                  position = Duration(milliseconds: value.toInt());
                });
              },
              value: position?.inMilliseconds?.toDouble() ?? 0.0,
              min: 0,
              max: duration?.inMilliseconds?.toDouble() ?? 0.0,
            ),
            Text('${duration!=null?toString().substring(2,7) : duration}'),
            Text('${position!=null?toString().substring(2,7) : position} ')
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audioPlayer.release();
  }
}
