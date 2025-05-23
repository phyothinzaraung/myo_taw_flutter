
import 'package:async_loader/async_loader.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/helper/PlatformHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'helper/NavigatorHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/DaoViewModel.dart';
import 'helper/MyoTawConstant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'DaoPhotoDetailScreen.dart';
import 'helper/NumConvertHelper.dart';
import 'helper/ServiceHelper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'DaoDetailScreen.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/CustomProgressIndicator.dart';
import 'myWidget/EmptyViewWidget.dart';

class DepartmentListScreen extends StatefulWidget {
  DaoViewModel model;
  DepartmentListScreen(this.model);
  @override
  _DepartmentListScreenState createState() => _DepartmentListScreenState(this.model);
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  DaoViewModel _daoViewModel;
  int index = 0;
  List<Widget> _photoWidgetList = List();
  List<Widget> _indicatorWidgetList = List();
  int _currentPhoto = 0;
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  var _response;
  int page = 1;
  int pageSize = 100;
  String deptType = 'Manager';
  bool _isManager, _isEngineer, _isLoading;
  List<DaoViewModel> _daoViewModelList = new List<DaoViewModel>();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();

  final Map<int, Widget> _cupertinoSliderChildren = const <int, Widget>{
    0: Text(MyString.txt_dept_manager, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
    1: Text(MyString.txt_dept_engineer, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),)
  };

  int _currentSegment = 0;

  _DepartmentListScreenState(this._daoViewModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  _init(){
    _isManager = true;
    _isEngineer = false;
    _isLoading = false;
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

  _getDaoByDeptType(int p) async{
    await _sharepreferenceshelper.initSharePref();
    _response = await ServiceHelper().getDaoByDeptType(page, pageSize, _sharepreferenceshelper.getRegionCode(), deptType);
    if(_response.data != null){
      var daoViewModelList = _response.data['Results'];
      for(var i in daoViewModelList){
        setState(() {
          _daoViewModelList.add(DaoViewModel.fromJson(i));
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _cupertinoSliderControl(){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: CupertinoSlidingSegmentedControl(
        children: _cupertinoSliderChildren,
        thumbColor: Colors.white,
        padding: EdgeInsets.all(3),
        onValueChanged: (i)async{
          setState(() {
            _currentSegment = i;
            _isLoading = true;
            _isManager = i==0?true:false;
            _isEngineer = i==0?false:true;
            deptType = i==0?'Manager':'Engineer';
            _daoViewModelList.clear();
            _getDaoByDeptType(page);
          });
          await _sharepreferenceshelper.initSharePref();
          FireBaseAnalyticsHelper.trackClickEvent(ScreenName.DEPARTMENT_LIST_SCREEN, ClickEvent.MANAGEMENT_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
        },
        groupValue: _currentSegment,
      ),
    );
  }

  Widget _header(){
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          _imageView(),
          SizedBox(height: 20,),
          PlatformHelper.isAndroid()?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              CustomButtonWidget(
                onPress: ()async{
                    setState(() {
                      _isLoading = true;
                      _isManager = true;
                      _isEngineer = false;
                      deptType = 'Manager';
                      _daoViewModelList.clear();
                      _getDaoByDeptType(page);
                    });
                    await _sharepreferenceshelper.initSharePref();
                    FireBaseAnalyticsHelper.trackClickEvent(ScreenName.DEPARTMENT_LIST_SCREEN, ClickEvent.MANAGEMENT_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());

                  },child: Text(MyString.txt_dept_manager, style: TextStyle(color: _isManager?Colors.white:MyColor.colorPrimary),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                color: _isManager?MyColor.colorPrimary:Colors.white,
                elevation: 1.0,
                //padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0, bottom: 7.0),
              ),

              CustomButtonWidget(
                onPress: ()async{
                  setState(() {
                    _isLoading = true;
                    _isManager = false;
                    _isEngineer = true;
                    deptType = 'Engineer';
                    _daoViewModelList.clear();
                    _getDaoByDeptType(page);
                  });
                  await _sharepreferenceshelper.initSharePref();
                  FireBaseAnalyticsHelper.trackClickEvent(ScreenName.DEPARTMENT_LIST_SCREEN, ClickEvent.ENGINEER_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());

                },child: Text(MyString.txt_dept_engineer, style: TextStyle(color: _isEngineer?Colors.white:MyColor.colorPrimary),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                color: _isEngineer?MyColor.colorPrimary:Colors.white,
                elevation: 1.0,
                //padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0, bottom: 7.0),
              ),
            ],
          ) : _cupertinoSliderControl()
        ],
      ),
    );
  }

  Widget _listView(){
    return ListView.builder(
        itemCount: _daoViewModelList.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int i){
          return GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DaoDetailScreen(_daoViewModelList[i])));
            },
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                      flex: 1,
                      child: _daoViewModelList[i].dAO.icon!=null?
                      Image.network(BaseUrl.DAO_PHOTO_URL+_daoViewModelList[i].dAO.icon, width: 50.0, height: 50.0,) :
                          CircleAvatar(
                            backgroundImage: AssetImage('images/placeholder.jpg'),
                            radius: 25,
                          )
                  ),
                  Flexible(
                      flex: 4,
                      child: Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(_daoViewModelList[i].dAO.title, style: TextStyle(fontSize: FontSize.textSizeSmall),)))
                ],
              ),
            ),
          );
        }
    );
  }

  Widget _renderLoad(){
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: NativeProgressIndicator(),
          )
        ],
      ),
    );
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
        height: 200.0,
        child: Column(
          children: <Widget>[
            CarouselSlider(
              items: _photoWidgetList,
              options: CarouselOptions(
                height: 170.0,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _indicatorWidgetList,
              ),
            )
          ],
        )
    ) :
    Center(
      child: Container(
        width: double.maxFinite,
        height: 180.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _daoViewModel.dAO.icon!=null?
            Image.network(BaseUrl.DAO_PHOTO_URL+_daoViewModel.dAO.icon, width: 100.0, height: 100.0,fit: BoxFit.cover) :
            Image.asset('images/placeholder.jpg', width: double.maxFinite, height: 180,fit: BoxFit.cover,)
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, AsyncLoader asyncLoader){
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CustomProgressIndicatorWidget(),
      child: Container(
        child: Column(
          children: <Widget>[
            _header(),
            Expanded(child: asyncLoader),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getDaoByDeptType(page),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => Container(
          child: _daoViewModelList.isNotEmpty? _listView() :
          !_isLoading?emptyView(asyncLoaderState, MyString.txt_no_data) : Container(),
        )
    );
    return CustomScaffoldWidget(
      title: Text(_daoViewModel.dAO.title,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(context, _asyncLoader),
      globalKey: _globalKey,
    );
  }
}
