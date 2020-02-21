import 'dart:io';
import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/EmptyViewWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/NavigatorHelper.dart';
import 'model/ApplyBizLicenseModel.dart';
import 'model/ApplyBizLicensePhotoModel.dart';
import 'helper/SharePreferencesHelper.dart';
import 'helper/ServiceHelper.dart';
import 'PhotoDetailScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'myWidget/CustomProgressIndicator.dart';
import 'myWidget/NoConnectionWidget.dart';

class ApplyBizLicensePhotoListScreen extends StatefulWidget {
  ApplyBizLicenseModel model;
  ApplyBizLicensePhotoListScreen(this.model);
  @override
  _ApplyBizLicensePhotoListScreenState createState() => _ApplyBizLicensePhotoListScreenState(this.model);
}

class _ApplyBizLicensePhotoListScreenState extends State<ApplyBizLicensePhotoListScreen> {
  ApplyBizLicenseModel _applyBizLicenseModel;
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  bool _isCon, _isLoading;
  var _response;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  List<ApplyBizLicensePhotoModel> _applyBizLicensePhotoModelList = new List<ApplyBizLicensePhotoModel>();
  TextEditingController _fileTitleController = TextEditingController();
  File _image;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  _ApplyBizLicensePhotoListScreenState(this._applyBizLicenseModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
  }

  Future gallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: MyString.PHOTO_MAX_WIDTH, maxHeight: MyString.PHOTO_MAX_HEIGHT);

    setState(() {
      _image = image;
    });
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

  _getAllBizLicense()async{
    await _sharepreferenceshelper.initSharePref();
    _response = await ServiceHelper().getApplyBizPhotoList(_applyBizLicenseModel.id);
    List applyBizLicensePhotoList = _response.data;
    //List applyBizLicensePhotoList = [];
    if(applyBizLicensePhotoList != null && applyBizLicensePhotoList.length > 0){
      for(var i in applyBizLicensePhotoList){
        setState(() {
          _applyBizLicensePhotoModelList.add(ApplyBizLicensePhotoModel.fromJson(i));
        });
      }
    }
  }

  _listView(){
    return _applyBizLicensePhotoModelList.isNotEmpty?
    Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index){
                  return GestureDetector(
                    onTap: (){
                      NavigatorHelper.MyNavigatorPush(context, PhotoDetailScreen(BaseUrl.APPLY_BIZ_LICENSE_PHOTO_URL+_applyBizLicensePhotoModelList[index].photoUrl),
                          ScreenName.PHOTO_DETAIL_SCREEN);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CachedNetworkImage(
                        imageUrl: BaseUrl.APPLY_BIZ_LICENSE_PHOTO_URL+_applyBizLicensePhotoModelList[index].photoUrl,
                        imageBuilder: (context, image){
                          return Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: image,
                                  fit: BoxFit.cover),
                            ),);
                        },
                        placeholder: (context, url) => Center(child: Container(
                          child: Center(child: new CircularProgressIndicator(strokeWidth: 2.0,)), width: double.maxFinite, height: 130.0,)),
                        errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg', width: 160,
                          height: 160, fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },childCount: _applyBizLicensePhotoModelList.length),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    crossAxisSpacing: 0.0))
          ],
        )
    ) : emptyView(asyncLoaderState,MyString.txt_no_photo);
  }

  Widget _renderLoad(){
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[CircularProgressIndicator()],)
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    _applyBizLicensePhotoModelList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  _uploadPhoto()async{
    try{
      _response = await ServiceHelper().uploadApplyBizPhoto(_image.path, _applyBizLicenseModel.id.toString(), _fileTitleController.text);
      if(_response.data != null){
        _handleRefresh();
        setState(() {
          _image = null;
          _fileTitleController.clear();
        });
      }else{
        WarningSnackBar(_globalKey, MyString.txt_try_again);
      }
    }catch(e){
      print(e);
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }

    setState(() {
      _isLoading = false;
    });

  }
  
  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getAllBizLicense(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: Column(
                children: <Widget>[
                  Expanded(child: _listView()),
                  _applyBizLicenseModel.isValid?Container():Row(
                    children: <Widget>[
                      Flexible(
                          flex: 2,
                          child: GestureDetector(
                            onTap: ()async{
                              gallery();
                              await _sharepreferenceshelper.initSharePref();
                              FireBaseAnalyticsHelper.TrackClickEvent(ScreenName.APPLY_BIZ_LICENSE_PHOTO_LIST_SCREEN, ClickEvent.GALLERY_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                            },
                            child: _image==null?Image.asset('images/add_image_placeholder.png', width: double.maxFinite, height: 50.0,):
                            Image.file(_image, width: double.maxFinite, height: 50.0, fit: BoxFit.cover,),
                          )),
                      Flexible(
                          flex: 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(5.0),
                                width: double.maxFinite,
                                color: Colors.white,
                                height: 50.0,
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:'Type attach photo file name',
                                  ),
                                  cursorColor: MyColor.colorPrimary,
                                  controller: _fileTitleController,
                                  style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorTextBlack),
                                ),
                              ),
                            ],
                          )
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          height: 50.0,
                          width: double.maxFinite,
                          child: FlatButton(onPressed: ()async{
                            await _checkCon();
                            if(_isCon){
                              if(_image != null && _fileTitleController.text.isNotEmpty){
                                setState(() {
                                  _isLoading = true;
                                });
                                await _sharepreferenceshelper.initSharePref();
                                FireBaseAnalyticsHelper.TrackClickEvent(ScreenName.APPLY_BIZ_LICENSE_PHOTO_LIST_SCREEN, ClickEvent.APPLY_BIZ_LICENSE_PHOTO_UPLOAD_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                                _uploadPhoto();
                              }
                            }else{
                              WarningSnackBar(_globalKey, MyString.txt_check_internet);
                            }
                            if(_image == null){
                              WarningSnackBar(_globalKey, MyString.txt_need_suggestion_photo);
                            }

                            if(_fileTitleController.text.isEmpty){
                              WarningSnackBar(_globalKey, MyString.txt_need_apply_biz_photo_name);
                            }
                          },
                            child: Text(MyString.txt_send, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,),
                        ),
                      )
                    ],
                  )
                ],
              )
          ),
        )
    );

    return CustomScaffoldWidget(
        title: Text(MyString.txt_apply_biz_license_photo,maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
        body: ModalProgressHUD(inAsyncCall: _isLoading,progressIndicator: CustomProgressIndicatorWidget(),child: _asyncLoader),
        globalKey: _globalKey,
    );
  }
}
