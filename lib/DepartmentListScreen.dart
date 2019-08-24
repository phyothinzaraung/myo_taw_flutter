import 'package:async_loader/async_loader.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/DaoViewModel.dart';
import 'helper/MyoTawConstant.dart';
import 'model/DaoPhotoModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'DaoPhotoDetailScreen.dart';
import 'helper/NumConvertHelper.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'DaoDetailScreen.dart';

class DepartmentListScreen extends StatefulWidget {
  DaoViewModel model;
  DepartmentListScreen(this.model);
  @override
  _DepartmentListScreenState createState() => _DepartmentListScreenState(this.model);
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  DaoViewModel _daoViewModel;
  List<DaoPhotoModel> _daoPhotoModelList = new List();
  int index = 0;
  List<Widget> _photoWidget = List();
  int _currentPhoto = 0;
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  bool _isCon;
  Response _response;
  int page = 1;
  int pageSize = 100;
  String deptType = 'Manager';
  bool _isManager, _isEngineer, _isLoading;
  List<DaoViewModel> _daoViewModelList = new List<DaoViewModel>();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
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
                    child: Text('${NumConvertHelper().getMyanNumInt(index)}${'.'} ${_daoViewModel.daoModel.title}  ',
                      style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeSmall),)),
              ],
            ),));
    }
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
    print('isCon : ${_isCon}');
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
        print('daoviewmodel :${_daoViewModelList}');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _header(){
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          _imageView(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                  onPressed: (){
                    setState(() {
                      _isLoading = true;
                      _isManager = true;
                      _isEngineer = false;
                      deptType = 'Manager';
                      _daoViewModelList.clear();
                      _getDaoByDeptType(page);
                    });

                  },child: Text(MyString.txt_dept_manager, style: TextStyle(color: _isManager?Colors.white:MyColor.colorPrimary),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                color: _isManager?MyColor.colorPrimary:Colors.white,
                elevation: 1.0,
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0, bottom: 7.0),),
              RaisedButton(
                onPressed: (){
                  setState(() {
                    _isLoading = true;
                    _isManager = false;
                    _isEngineer = true;
                    deptType = 'Engineer';
                    _daoViewModelList.clear();
                    _getDaoByDeptType(page);
                  });

                },child: Text(MyString.txt_dept_engineer, style: TextStyle(color: _isEngineer?Colors.white:MyColor.colorPrimary),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                color: _isEngineer?MyColor.colorPrimary:Colors.white,
                elevation: 1.0,
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 7.0, bottom: 7.0),),
            ],
          )
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
                      child: Image.network(BaseUrl.DAO_PHOTO_URL+_daoViewModelList[i].daoModel.icon, width: 50.0, height: 50.0,)),
                  Flexible(
                      flex: 4,
                      child: Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(_daoViewModelList[i].daoModel.title, style: TextStyle(fontSize: FontSize.textSizeSmall),)))
                ],
              ),
            ),
          );
        }
    );
  }

  Widget getNoConnectionWidget(){
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('No Internet Connection'),
                  FlatButton(onPressed: (){
                    asyncLoaderState.currentState.reloadState();
                    _checkCon();
                  }
                    , child: Text('Retry', style: TextStyle(color: Colors.white),),color: MyColor.colorPrimary,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderLoad(){
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await _checkCon();
    if(_isCon){
      setState(() {
        _daoViewModelList.clear();
      });
      await _getDaoByDeptType(page);
    }else{
      Fluttertoast.showToast(msg: 'Check Connection', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeSmall);
    }
    return null;
  }


  Widget _imageView(){
    return _daoViewModel.photoList.isNotEmpty?
    Container(
        width: double.maxFinite,
        height: 200.0,
        child: Column(
          children: <Widget>[
            CarouselSlider(
              items: _photoWidget,
              height: 170.0,
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
    Center(
      child: Container(
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

  Widget modalProgressIndicator(){
    return Center(
      child: Card(
        child: Container(
          width: 220.0,
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(margin: EdgeInsets.only(right: 30.0),
                  child: Text('Loading......',style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.black))),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColor.colorPrimary))
            ],
          ),
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
        renderError: ([error]) => getNoConnectionWidget(),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: _listView(),
          ),
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(_daoViewModel.daoModel.title, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: modalProgressIndicator(),
        child: Container(
          child: Column(
            children: <Widget>[
              _header(),
              Expanded(child: _asyncLoader),
            ],
          ),
        ),
      ),
    );
  }
}
