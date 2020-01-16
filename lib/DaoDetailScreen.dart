import 'package:flutter/material.dart';
import 'model/DaoViewModel.dart';
import 'helper/MyoTawConstant.dart';
import 'model/DaoPhotoModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'helper/NumConvertHelper.dart';
import 'DaoPhotoDetailScreen.dart';
import 'ContributionScreen.dart';
import 'BizLicenseScreen.dart';
import 'package:flutter_html/flutter_html.dart';

class DaoDetailScreen extends StatefulWidget {
  DaoViewModel model;
  DaoDetailScreen(this.model);
  @override
  _DaoDetailScreenState createState() => _DaoDetailScreenState(this.model);
}

class _DaoDetailScreenState extends State<DaoDetailScreen> {
  DaoViewModel _daoViewModel;
  List<DaoPhotoModel> _daoPhotoModelList = new List();
  int index = 0;
  List<Widget> _photoWidget = List();
  int _currentPhoto = 0;
  _DaoDetailScreenState(this._daoViewModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  _init(){
    for(var i in _daoViewModel.photoList){
      _daoPhotoModelList.add(DaoPhotoModel.fromJson(i));
    }
    for(var i in _daoPhotoModelList){
      index++;
      _photoWidget.add(
          GestureDetector(
            onTap: (){
              if(_daoPhotoModelList.isNotEmpty){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DaoPhotoDetailScreen(_daoPhotoModelList)));
              }
            },
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                //image
                CachedNetworkImage(
                  imageUrl: i.photoUrl!=null?BaseUrl.DAO_PHOTO_URL+i.photoUrl:'',
                  imageBuilder: (context, image){
                    return Container(
                      width: double.maxFinite,
                      height: 200.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: image,
                            fit: BoxFit.cover),
                      ),);
                  },
                  placeholder: (context, url) => Center(child: Container(
                    child: Center(child: new CircularProgressIndicator(strokeWidth: 2.0,)), width: double.maxFinite, height: 200.0,)),
                  errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg'),
                ),
                Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6)
                    ),
                    //text image title
                    child: Text('${NumConvertHelper().getMyanNumInt(index)}${'.'} ${_daoViewModel.daoModel.title}  ',
                      style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeSmall),)),
              ],
            ),));
    }
  }


  Widget _imageView(){
    return _daoViewModel.photoList.isNotEmpty?
    Container(
      width: double.maxFinite,
      height: 230.0,
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: _photoWidget,
            height: 200.0,
            initialPage: 0,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.decelerate,
            pauseAutoPlayOnTouch: Duration(seconds: 1),
            scrollDirection: Axis.horizontal,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (i){
              setState(() {
                _currentPhoto = i;
              });
            },),
          Container(
            //slide indicator
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for(int i=0; i<index;i++)
                  Container(
                    width: _currentPhoto==i?10.0:8.0,
                    height: _currentPhoto==i?10.0:8.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPhoto==i?MyColor.colorPrimaryDark:Colors.grey
                    ),
                  )
              ],
            ),
          )
        ],
      )
    ) :
        //photo list is empty
    Center(
      child: Container(
        color: MyColor.colorGrey,
        width: double.maxFinite,
        height: 180.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(BaseUrl.DAO_PHOTO_URL+_daoViewModel.daoModel.icon, width: 100.0, height: 100.0,)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_daoViewModel.daoModel.title, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _imageView(),
                      //text body
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(30.0),
                        child: Html(data: _daoViewModel.daoModel.description,),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 50.0,
              child: FlatButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => _daoViewModel.daoModel.title.contains('လိုင်စင်')?
                    BizLicenseScreen() : ContributionScreen()));
                  },
                  child: Text(_daoViewModel.daoModel.title.contains('လိုင်စင်')?MyString.txt_biz_license:MyString.txt_suggestion,
                    style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),),color: MyColor.colorPrimary,),
            )
          ],
        ),
      )
    );
  }
}
