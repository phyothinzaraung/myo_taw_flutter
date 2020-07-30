
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/LoginScreen.dart';
import 'package:myotaw/PhotoDetailScreen.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/EmptyViewWidget.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'package:myotaw/myWidget/NativePullRefresh.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';
import 'model/UserModel.dart';
import 'helper/NumConvertHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:myotaw/Database/UserDb.dart';
import 'Database/SaveNewsFeedDb.dart';
import 'package:async_loader/async_loader.dart';
import 'helper/ServiceHelper.dart';
import 'package:connectivity/connectivity.dart';
import 'model/TaxRecordModel.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'ProfileFormScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'ProfilePhotoUploadScreen.dart';
import 'NewTaxRecordScreen.dart';
import 'ApplyBizLicenseListScreen.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/CustomProgressIndicator.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel _userModel;
  UserDb _userDb = UserDb();
  SaveNewsFeedDb _saveNewsFeedDb = SaveNewsFeedDb();
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  bool _isEnd , _isCon, _isLoading = false;
  int page = 1;
  int pageCount = 100;
  var response;
  ImageProvider _profilePhoto;
  List<TaxRecordModel> _taxRecordModelList = new List<TaxRecordModel>();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  GlobalKey<SliverAnimatedListState> _animatedListKey = GlobalKey();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkCon();
  }

  _getAllTaxRecord(int p)async{
    response = await ServiceHelper().getAllTaxRecord(p, pageCount, _userModel.currentRegionCode, _userModel.uniqueKey);
    var result = response.data['Results'];
    //var result = [];
    if(result != null){
      if(result.length > 0){
        for(var model in result){
          _taxRecordModelList.add(TaxRecordModel.fromJson(model));
        }
        //prevent set state is called after profilescreen is disposed
        if(this.mounted){
          setState(() {
            _isEnd = false;
          });
        }
      }else{
        if(this.mounted){
          setState(() {
            _isEnd = true;
          });
        }
      }
    }else{
      if(this.mounted){
        setState(() {
          _isEnd = true;
        });
      }
    }
  }

  _getUser()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userDb.closeUserDb();
    setState(() {
      _userModel = model;
    });
    _profilePhoto = _userModel.photoUrl!=null?
    new CachedNetworkImageProvider(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl) :
    AssetImage('images/profile_placeholder.png');
    if(_userModel != null){
      if(_userModel.currentRegionCode != MyString.HLY_REGION_CODE){
        await _getAllTaxRecord(page);
      }
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

  _logOutClear()async{
    setState(() {
      _isLoading = true;
    });
    await _firebaseMessaging.unsubscribeFromTopic('all');
    await _firebaseMessaging.deleteInstanceID();
    await _sharepreferenceshelper.initSharePref();
    _sharepreferenceshelper.logOutSharePref();

    await _userDb.openUserDb();
    await _userDb.deleteUser();
    _userDb.closeUserDb();

    await _saveNewsFeedDb.openSaveNfDb();
    await _saveNewsFeedDb.deleteSavedNewsFeed();
     _saveNewsFeedDb.closeSaveNfDb();
    setState(() {
      _isLoading = false;
    });
    NavigatorHelper.myNavigatorPushAndRemoveUntil(context, LoginScreen(), ScreenName.LOGIN_SCREEN);
  }

  void _deleteTaxRecord(int id, int i)async{
    try{
      response = await ServiceHelper().deleteTaxRecord(id);
      //await _handleRefresh();
      Future.delayed(Duration(milliseconds: 200),(){
        setState(() {
          var model = _taxRecordModelList.removeAt(i);
          _animatedListKey.currentState.removeItem(i, (context, animation){
            return _taxRecordList(model, animation);
          },duration: Duration(milliseconds: 500));
        });
      });
    }catch(e){
      print(e);
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _taxRecordList(TaxRecordModel model, Animation animation,[int i]){
    TaxRecordModel taxRecordModel = model;
    return GestureDetector(
      onTap: (){
        NavigatorHelper.myNavigatorPush(context, PhotoDetailScreen(BaseUrl.TAX_RECORD_PHOTO_URL+taxRecordModel.photoUrl),
            ScreenName.PHOTO_DETAIL_SCREEN);
      },
      child: ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Interval(0.2, 1)),
        child: FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Interval(0.2, 1)),
          child: Card(
            margin: EdgeInsets.only(bottom: 1.0),
            elevation: 0.5,
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Image.asset('images/tax_record.png', width: 50.0, height: 50.0,),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(margin: EdgeInsets.only(bottom: 5.0),
                              child: Text(taxRecordModel.subject,style: TextStyle(fontSize: FontSize.textSizeNormal,color: MyColor.colorTextBlack),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                          Text(ShowDateTimeHelper.showDateTimeDifference(taxRecordModel.accessTime), style: TextStyle(fontSize: FontSize.textSizeSmall,color: MyColor.colorTextBlack),)
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(PlatformHelper.isAndroid()?Icons.delete :CupertinoIcons.delete_solid, color: Colors.red,),
                      onPressed: (){
                        CustomDialogWidget().customConfirmDialog(
                            context: context,
                            img: PlatformHelper.isAndroid()? 'bin.png' : 'iosbin.png',
                            content: MyString.txt_are_u_sure,
                            textYes: MyString.txt_delete,
                            textNo: MyString.txt_delete_cancel,
                            onPress: ()async{
                              Navigator.of(context).pop();
                              setState(() {
                                _isLoading = true;
                              });
                              _deleteTaxRecord(taxRecordModel.id, i);
                              await _sharepreferenceshelper.initSharePref();
                              FireBaseAnalyticsHelper.trackClickEvent(ScreenName.PROFILE_SCREEN, ClickEvent.TAX_RECORD_DELETE_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                            }
                        );
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }

  _navigateToProfileScreen()async{
    Map result = await NavigatorHelper.myNavigatorPush(context, ProfileFormScreen(_sharepreferenceshelper.isWardAdmin()), ScreenName.PROFILE_FORM_SCREEN);
    if(result != null && result.containsKey('isNeedRefresh') == true){
      await _handleRefresh();
    }
  }

  _navigateToProfilePhotoScreen()async{
    Map result = await NavigatorHelper.myNavigatorPush(context, ProfilePhotoUploadScreen(), ScreenName.PROFILE_PHOTO_SCREEN);
    if(result != null && result.containsKey('isNeedRefresh') == true){
      //await _getUser();
      await _handleRefresh();
    }
  }

  _navigateToNewTaxRecordScreen()async{
    Map result = await NavigatorHelper.myNavigatorPush(context, NewTaxRecordScreen(), ScreenName.NEW_TAX_RECORD_SCREEN);
    if(result != null && result.containsKey('isNeedRefresh') == true){
      await _handleRefresh();
    }
  }

  Widget _headerProfile(){
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
          child: Row(
            children: <Widget>[
              Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/profile.png', width: 30.0, height: 30.0,)),
              Text(MyString.title_profile, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          _navigateToProfilePhotoScreen();
                        },
                        child: Stack(
                          children: <Widget>[
                            Hero(
                              tag: 'profile',
                              child: CircleAvatar(backgroundImage: _profilePhoto,
                                backgroundColor: MyColor.colorGrey, radius: 50.0,),
                            ),
                            Image.asset('images/photo_edit.png', width: 25.0, height: 25.0,)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(margin: EdgeInsets.only(bottom: 10.0),
                                child: Text(_userModel!=null?_userModel.name!=null?_userModel.name:'':'', style: TextStyle(fontSize: FontSize.textSizeExtraSmall,color: MyColor.colorTextBlack),)),
                            Text(NumConvertHelper.getMyanNumString(_userModel!=null?_userModel.phoneNo!=null?_userModel.phoneNo:'':''),
                              style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorTextBlack),),
                          ],
                        ),
                      )
                    ],
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(margin: EdgeInsets.only(bottom: 5.0),child: Text(MyString.txt_setting, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorPrimary),)),
                    GestureDetector(
                      onTap: (){
                        _navigateToProfileScreen();
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/edit_profile.png',width: 30.0, height: 38.0,)),
                            Text(MyString.txt_edit_profile, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: MyColor.colorPrimary,),
                    _userModel != null?
                    _userModel.currentRegionCode != MyString.HLY_REGION_CODE?GestureDetector(
                      onTap: (){

                        NavigatorHelper.myNavigatorPush(context, ApplyBizLicenseListScreen(), ScreenName.APPLY_BIZ_LICENSE_LIST_SCREEN);
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/apply_biz_list.png',width: 30.0, height: 38.0,)),
                            Text(MyString.txt_apply_biz_license, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                          ],
                        ),
                      ),
                    ) : Container() : Container(),
                    _userModel !=null?
                    _userModel.currentRegionCode != MyString.HLY_REGION_CODE?Divider(color: MyColor.colorPrimary,) : Container() : Container(),
                    GestureDetector(
                      onTap: (){
                        //_dialogLogOut();
                        CustomDialogWidget().customConfirmDialog(
                          context: context,
                          content: MyString.txt_are_u_sure,
                          textNo: MyString.txt_log_out_cancel,
                          textYes: MyString.txt_log_out,
                          img: 'logout_icon.png',
                          onPress: ()async{
                            Navigator.pop(context);
                            await _sharepreferenceshelper.initSharePref();
                            FireBaseAnalyticsHelper.trackClickEvent(ScreenName.PROFILE_SCREEN, ClickEvent.USER_LOG_OUT_CLICK_EVENT,
                                _sharepreferenceshelper.getUserUniqueKey());
                            _logOutClear();
                          }
                        );
                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/log_out.png',width: 30.0, height: 38.0,)),
                            Text(MyString.txt_log_out, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        _userModel != null? _userModel.currentRegionCode != MyString.HLY_REGION_CODE? Container(
          margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 10.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(MyString.txt_tax_record, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorPrimary),)),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                width: double.maxFinite,
                //new tax record
                child: CustomButtonWidget(onPress: (){
                  _navigateToNewTaxRecordScreen();
                },child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(margin: EdgeInsets.only(right: 10.0),child: Text(MyString.txt_tax_new_record, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),),
                    Icon(Icons.add, color: Colors.white,)
                  ],
                ),color: MyColor.colorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  borderRadius: BorderRadius.circular(8),
                ),
              )
            ],
          ),
        ) : Container() : Container(),
      ],
    );
  }

  Widget _headerProfileRefresh(){
    return ListView(
      children: <Widget>[
        _headerProfile(),
        Column(
          children: <Widget>[
            NativeProgressIndicator()
          ],
        )
      ],
    );
  }


  /*Widget _listView(){
    return ListView.builder(
        itemCount: _taxRecordModelList.length,
        itemBuilder: (context, i){
          return Column(
            children: <Widget>[
              i==0?Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _headerProfile(),
                  ],
                ),
              ): Container(width: 0.0, height: 0.0,),
              _taxRecordList(i)
            ],
          );
        });

  }*/

  Widget getNoConnectionWidget(){
    return ListView(
      children: <Widget>[
        _headerProfile(),
        noConnectionWidget(asyncLoaderState)
      ],
    );
  }

  Widget _renderLoad(){
    return Container(
        child: _headerProfileRefresh()
    );
  }

  Future<Null> _handleRefresh() async {
   setState(() {
     page = 0;
     page ++;
     _taxRecordModelList.clear();
   });
   asyncLoaderState.currentState.reloadState();
    return null;
  }

  Future<bool> _loadMore() async {
    await _checkCon();
    if(_isCon){
      page++;
      await _getAllTaxRecord(page);
    }
    return _isCon;
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getUser(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => getNoConnectionWidget(),
        renderSuccess: ({data}) => NativePullRefresh(
          onRefresh: _handleRefresh,
          child: _userModel.currentRegionCode != MyString.HLY_REGION_CODE?_taxRecordModelList.isNotEmpty?
          CustomScrollView(
            slivers: <Widget>[
              SliverList(delegate: SliverChildBuilderDelegate((context, i){
                return _headerProfile();
              }, childCount: 1)),
              SliverAnimatedList(itemBuilder: (context, i, animation){
                return _taxRecordList(_taxRecordModelList[i], animation, i);
              }, initialItemCount: _taxRecordModelList.length,key: _animatedListKey,)
            ],
          ) : ListView(children: <Widget>[_headerProfile(), emptyView(asyncLoaderState, MyString.txt_no_data)],) :
          CustomScrollView(
            slivers: <Widget>[
              SliverList(delegate: SliverChildBuilderDelegate((context, i){
                return _headerProfile();
              }, childCount: 1)),
              /*SliverAnimatedList(itemBuilder: (context, i, animation){
                return _taxRecordList(_taxRecordModelList[i], animation, i);
              }, initialItemCount: _taxRecordModelList.length,key: _animatedListKey,)*/
            ],
          )
        )
    );
    return CustomScaffoldWidget(
      title: Text(MyString.txt_profile,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          progressIndicator: CustomProgressIndicatorWidget(),
          child: _asyncLoader),
      globalKey: _globalKey,
    );
  }
}
