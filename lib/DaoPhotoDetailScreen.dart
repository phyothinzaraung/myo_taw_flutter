import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/model/DaoViewModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:photo_view/photo_view.dart';
import 'helper/PlatformHelper.dart';
import 'helper/MyoTawConstant.dart';

class DaoPhotoDetailScreen extends StatelessWidget {
  List<Photo> _daoPhotoModelList = new List<Photo>();
  PageController _pageController;
  List<Widget> _photoWidget = new List();
  int _initialPage = 0;
  DaoPhotoDetailScreen(this._daoPhotoModelList, this._initialPage);

  addPhoto(){
    for(var i in _daoPhotoModelList){
      _photoWidget.add(PhotoView(
        imageProvider: NetworkImage(BaseUrl.DAO_PHOTO_URL+i.photoUrl),
        loadingChild: _nativeProgressIndicator(),
        loadFailedChild: Image.asset('images/placeholder.jpg'),
      ));
    }
  }

  Widget _nativeProgressIndicator() {
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
          child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          children: _photoWidget
          )
        ),
      )
    );
  }
}
