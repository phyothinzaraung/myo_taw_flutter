import 'package:flutter/material.dart';
import 'model/DaoPhotoModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'helper/MyoTawConstant.dart';

class DaoPhotoDetailScreen extends StatelessWidget {
  List<DaoPhotoModel> _daoPhotoModelList = new List<DaoPhotoModel>();
  PageController _pageController = new PageController(initialPage: 0);
  List<Widget> _photoWidget = new List();

  DaoPhotoDetailScreen(this._daoPhotoModelList);

  addPhoto(){
    for(var i in _daoPhotoModelList){
      _photoWidget.add(CachedNetworkImage(
        width: double.maxFinite,
        imageUrl: i.photoUrl!=null?BaseUrl.DAO_PHOTO_URL+i.photoUrl:'',
        imageBuilder: (context, image){
          return Container(
            width: double.maxFinite,
            height: 300.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image,),
            ),);
        },
        errorWidget: (context, url, error)=> Container(
          width: double.maxFinite,
          height: 300.0,
          decoration: BoxDecoration(
              image: DecorationImage(image: Image.asset('images/placeholder_newsfeed.jpg').image, fit: BoxFit.cover)
          ),
        ),
      ));
    }

  }
  @override
  Widget build(BuildContext context) {
    addPhoto();
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Center(
        child: PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: _photoWidget
        )
      ),
    );
  }
}
