import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:photo_view/photo_view.dart';
import 'model/DaoPhotoModel.dart';
import 'helper/MyoTawConstant.dart';

class DaoPhotoDetailScreen extends StatelessWidget {
  List<DaoPhotoModel> _daoPhotoModelList = new List<DaoPhotoModel>();
  PageController _pageController;
  List<Widget> _photoWidget = new List();
  int _initialPage = 0;
  DaoPhotoDetailScreen(this._daoPhotoModelList, this._initialPage);

  addPhoto(){
    for(var i in _daoPhotoModelList){
      _photoWidget.add(PhotoView(
        imageProvider: NetworkImage(BaseUrl.DAO_PHOTO_URL+i.photoUrl),
        loadingChild: Center(child: CircularProgressIndicator(),),
        loadFailedChild: Image.asset('images/placeholder.jpg'),
      ));
    }

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
