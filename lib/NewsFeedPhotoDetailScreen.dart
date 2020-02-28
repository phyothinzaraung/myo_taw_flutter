import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/model/NewsFeedViewModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:photo_view/photo_view.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';

class NewsFeedPhotoDetailScreen extends StatelessWidget {
  List<PhotoLink> _photoList = new List();
  String _photoUrl;
  PageController _pageController;
  List<Widget> _photoWidget = new List();
  int _initialPage = 0;
  NewsFeedPhotoDetailScreen(this._photoList,this._photoUrl, this._initialPage);

  void addPhoto(){
    for(var i in _photoList){
      _photoWidget.add(PhotoView(
        imageProvider: NetworkImage(BaseUrl.NEWS_FEED_CONTENT_URL+i.photoUrl),
        loadingChild: _nativeProgressIndicator(),
        loadFailedChild: Image.asset('images/placeholder.jpg'),
      ),);
    }
  }

  Widget _nativeProgressIndicator(){
    return PlatformHelper.isAndroid() ?
    Center(child: CircularProgressIndicator()) :
    CupertinoTheme(
        data: CupertinoThemeData(
          brightness: Brightness.dark
        ),
        child: CupertinoActivityIndicator(radius: 15,)
    );
}

  @override
  Widget build(BuildContext context) {
    _pageController = new PageController(initialPage: _initialPage);
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
            loadingChild: _nativeProgressIndicator(),
            loadFailedChild: Image.asset('images/placeholder.jpg'),
          ),
        ),
      ),
    );
  }
}
