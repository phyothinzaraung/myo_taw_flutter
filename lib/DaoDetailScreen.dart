import 'package:flutter/material.dart';
import 'package:myotaw/WardAdminContributionScreen.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'model/DaoViewModel.dart';
import 'helper/MyoTawConstant.dart';
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
  int index = 0;
  List<Widget> _photoWidgetList = List();
  List<Widget> _indicatorWidgetList = List();
  int _currentPhoto = 0;
  _DaoDetailScreenState(this._daoViewModel);
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  _init(){
    for(var i in _daoViewModel.photo){
      index++;
      _photoWidgetList.add(
          GestureDetector(
            onTap: (){
              if(_daoViewModel.photo.isNotEmpty){

                NavigatorHelper.myNavigatorPush(context, DaoPhotoDetailScreen(_daoViewModel.photo, _currentPhoto), ScreenName.PHOTO_DETAIL_SCREEN);
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
                    child: Center(child: NativeProgressIndicator()), width: double.maxFinite, height: 200.0,)),
                  errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg'),
                ),
                Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6)
                    ),
                    //text image title
                    child: Text('${NumConvertHelper.getMyanNumInt(index)}${'.'} ${_daoViewModel.dAO.title}  ',
                      style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeSmall),)),
              ],
            ),));
    }
  }

  _indicatorList(){
    for(int i=0; i<index;i++){
      _indicatorWidgetList.add(Container(
        width: _currentPhoto==i?10.0:8.0,
        height: _currentPhoto==i?10.0:8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPhoto==i?MyColor.colorPrimaryDark:Colors.grey
        ),
      ));
    }
  }


  Widget _imageView(){
    _indicatorWidgetList.clear();
    _indicatorList();
    return _daoViewModel.photo.isNotEmpty?
    Container(
      width: double.maxFinite,
      height: 230.0,
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: _photoWidgetList,
            options: CarouselOptions(
              height: 200.0,
              initialPage: 0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              autoPlayCurve: Curves.decelerate,
              pauseAutoPlayOnTouch: true,
              scrollDirection: Axis.horizontal,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              onPageChanged: (i, str){
                setState(() {
                  _currentPhoto = i;
                });
              },
            ),

          ),
          Container(
            //slide indicator
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _indicatorWidgetList,
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
            _daoViewModel.dAO.icon!=null?
            Image.network(BaseUrl.DAO_PHOTO_URL+_daoViewModel.dAO.icon, width: 100.0, height: 100.0,) :
                Image.asset('images/placeholder.jpg', height: 180, width: double.maxFinite, fit: BoxFit.cover,)
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context){
    return Container(
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
                      child: Html(data: _daoViewModel.dAO.description,),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              onPressed: ()async{
                await _sharepreferenceshelper.initSharePref();
                NavigatorHelper.myNavigatorPush(context,
                    //screen
                    _daoViewModel.dAO.title.contains('လိုင်စင်')?
                    BizLicenseScreen() : _sharepreferenceshelper.isWardAdmin()?WardAdminContributionScreen():ContributionScreen(),
                    //screenName
                    _daoViewModel.dAO.title.contains('လိုင်စင်')?ScreenName.BIZ_LICENSE_SCREEN :
                    _sharepreferenceshelper.isWardAdmin()?ScreenName.WARD_ADMIN_CONTRIBUTION_SCREEN : ScreenName.CONTRIBUTION_SCREEN);
              },
              child: Text(_daoViewModel.dAO.title.contains('လိုင်စင်')?MyString.txt_biz_license:MyString.txt_suggestion,
                style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),),color: MyColor.colorPrimary,),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(_daoViewModel.dAO.title,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(context),
    );
  }
}
