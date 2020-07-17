import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myotaw/model/NewsFeedPhotoModel.dart';
import 'package:myotaw/model/NewsFeedViewModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:photo_view/photo_view.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/services.dart';

class NewsFeedPhotoDetailScreen extends StatelessWidget {
  List<NewsFeedPhotoModel> _photoList = new List();
  String _photoUrl;
  PageController _pageController;
  List<Widget> _photoWidget = new List();
  int _initialPage = 0;
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

  @override
  Widget build(BuildContext context) {
    _pageController = new PageController(initialPage: _initialPage);
    addPhoto();
    _pageController.addListener(() {
      _initialPage = _pageController.page.toInt();
    });
    return CustomScaffoldWidget(
      title: null,
      action: <Widget>[
        IconButton(icon: Icon(Icons.file_download), onPressed: ()async{
          try {
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
          }
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
