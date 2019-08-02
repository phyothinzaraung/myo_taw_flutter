import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Model/NewsFeedPhotoModel.dart';

class NewsFeedPhotoDetail extends StatelessWidget {
  List _photoList = new List();
  String _photoUrl;
  PageController _pageController = new PageController(initialPage: 0);
  List<Widget> _photoWidget = new List();
  NewsFeedPhotoDetail(this._photoList,this._photoUrl);

  void addPhoto(){
    var photoModelList = _photoList.map((i) => NewsFeedPhotoModel.fromJson(i));
    for(var i in photoModelList){
      _photoWidget.add(CachedNetworkImage(
        width: double.maxFinite,
        imageUrl: i.photoUrl!=null?baseUrl.NEWS_FEED_CONTENT_URL+i.photoUrl:'',
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
        child: _photoList.isNotEmpty?
        PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          children: _photoWidget
        ) :
        CachedNetworkImage(
          width: double.maxFinite,
          imageUrl: _photoUrl!=null?baseUrl.NEWS_FEED_CONTENT_URL+_photoUrl:'',
          imageBuilder: (context, image){
            return Container(
              width: double.maxFinite,
              height: 300.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: image,
                    fit: BoxFit.cover),
              ),);
          },
          errorWidget: (context, url, error)=> Container(
            width: double.maxFinite,
            height: 300.0,
            decoration: BoxDecoration(
                image: DecorationImage(image: Image.asset('images/placeholder_newsfeed.jpg').image, fit: BoxFit.cover)
            ),
          ),
        ),
      ),
    );
  }
}
