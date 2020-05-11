import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myotaw/model/NewsFeedViewModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:photo_view/photo_view.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/services.dart';

class NewsFeedPhotoDetailScreen extends StatelessWidget {
  List<PhotoLink> _photoList = new List();
  String _photoUrl;
  String _downloadPhotoUrl;
  PageController _pageController;
  List<Widget> _photoWidget = new List();
  int _initialPage = 0;
  NewsFeedPhotoDetailScreen(this._photoList, this._photoUrl, this._initialPage);

  void addPhoto() {
    for (var i in _photoList) {
      _photoWidget.add(Stack(children: <Widget>[
        PhotoView(
          imageProvider:
              NetworkImage(BaseUrl.NEWS_FEED_CONTENT_URL + i.photoUrl),
          loadingChild: _nativeProgressIndicator(),
          loadFailedChild: Image.asset('images/placeholder.jpg'),
        ),
        Align(
          alignment: Alignment.topRight,
          child: RaisedButton(
            onPressed: () async {
              try {
                  var imageId =
                      await ImageDownloader.downloadImage(BaseUrl.NEWS_FEED_CONTENT_URL + i.photoUrl);
                  Fluttertoast.showToast(
                      msg: "Photo has been successfully downloaded.",
                      toastLength: Toast.LENGTH_SHORT);
                  if (imageId == null) {
                    return;
                  }
              } on PlatformException catch (error) {
                print(error);
              }
            },
            //child: const Text('Save Photo', style: TextStyle(fontSize: 16)),
            child: const Icon(Icons.file_download, size: 40),
            color: Colors.black,
            textColor: MyColor.colorPrimary,
            elevation: 5,
            padding: EdgeInsets.all(16.0),
          ),
        )
      ]));
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
    return CustomScaffoldWidget(
      title: null,
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
