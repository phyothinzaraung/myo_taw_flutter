import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:photo_view/photo_view.dart';
import 'helper/MyoTawConstant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'model/NewsFeedPhotoModel.dart';

class NewsFeedPhotoDetailScreen extends StatelessWidget {
  List _photoList = new List();
  String _photoUrl;
  PageController _pageController = new PageController(initialPage: 0);
  List<Widget> _photoWidget = new List();
  NewsFeedPhotoDetailScreen(this._photoList,this._photoUrl);

  void addPhoto(){
    var photoModelList = _photoList.map((i) => NewsFeedPhotoModel.fromJson(i));
    for(var i in photoModelList){
      _photoWidget.add(PhotoView(
        imageProvider: NetworkImage(BaseUrl.NEWS_FEED_CONTENT_URL+i.photoUrl),
        loadingChild: Center(child: CircularProgressIndicator(),),
        loadFailedChild: Image.asset('images/placeholder.jpg'),
      ),);
    }
  }
  @override
  Widget build(BuildContext context) {
    addPhoto();
    return CustomScaffoldWidget(
      title: null,
      body: Container(
        color: Colors.black,
        child: Center(
          child: _photoList.isNotEmpty?
          PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              children: _photoWidget
          ) :
          PhotoView(
            imageProvider: NetworkImage(BaseUrl.NEWS_FEED_CONTENT_URL+_photoUrl),
            loadingChild: Center(child: CircularProgressIndicator(),),
            loadFailedChild: Image.asset('images/placeholder.jpg'),
          ),
        ),
      ),
    );
    /*return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: ,
    );*/
  }
}
