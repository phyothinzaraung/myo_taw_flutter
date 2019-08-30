import 'dart:io';
import 'package:async_loader/async_loader.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'helper/MyoTawConstant.dart';
import 'model/ApplyBizLicenseModel.dart';
import 'model/ApplyBizLicensePhotoModel.dart';
import 'helper/SharePreferencesHelper.dart';
import 'helper/ServiceHelper.dart';
import 'PhotoDetailScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  Response _response;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  List<ApplyBizLicensePhotoModel> _applyBizLicensePhotoModelList = new List<ApplyBizLicensePhotoModel>();
  TextEditingController _fileTitleController = TextEditingController();
  File _image;
  _ApplyBizLicensePhotoListScreenState(this._applyBizLicenseModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = false;
  }

  Future gallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 1024, maxHeight: 768);

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
    if(_response.data != null){
      var applyBizLicensePhotoList = _response.data;
      for(var i in applyBizLicensePhotoList){
        setState(() {
          _applyBizLicensePhotoModelList.add(ApplyBizLicensePhotoModel.fromJson(i));
        });
      }
    }
  }

  _listView(){
    return Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhotoDetailScreen(BaseUrl.APPLY_BIZ_LICENSE_PHOTO_URL+_applyBizLicensePhotoModelList[index].photoUrl)));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Image.network(BaseUrl.APPLY_BIZ_LICENSE_PHOTO_URL+_applyBizLicensePhotoModelList[index].photoUrl
                      , width: 160.0, height: 160.0, fit: BoxFit.cover,),
                    ),
                  );
                },childCount: _applyBizLicensePhotoModelList.length),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    crossAxisSpacing: 0.0))
          ],
        )
    );
  }

  Widget getNoConnectionWidget(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
    await _checkCon();
    if(_isCon){
      setState(() {
        _applyBizLicensePhotoModelList.clear();
      });
      _getAllBizLicense();
    }else{
      Fluttertoast.showToast(msg: 'Check Connection', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeSmall);
    }
    return null;
  }

  _uploadPhoto()async{
    _response = await ServiceHelper().uploadApplyBizPhoto(_image.path, _applyBizLicenseModel.id.toString(), _fileTitleController.text);
    setState(() {
      _isLoading = false;
    });
    _handleRefresh();
    setState(() {
      _image = null;
      _fileTitleController.clear();
    });
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
                  child: Text('Loading......',style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack))),
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
        initState: () async => await _getAllBizLicense(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => getNoConnectionWidget(),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: _applyBizLicensePhotoModelList.isNotEmpty?Column(
                children: <Widget>[
                  Expanded(child: _listView()),
                  _applyBizLicenseModel.isValid==true?Container():Row(
                    children: <Widget>[
                      Flexible(
                          flex: 2,
                          child: GestureDetector(
                            onTap: (){
                              gallery();
                            },
                            child: _image==null?Image.asset('images/add_image_placeholder.png', width: 60.0, height: 60.0,):
                      Image.file(_image, width: 50.0, height: 50.0, fit: BoxFit.cover,),
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
                                _uploadPhoto();
                              }
                            }else{
                              Fluttertoast.showToast(msg: 'Check internet connection', backgroundColor: Colors.black.withOpacity(0.7));
                            }
                            if(_image == null){
                              Fluttertoast.showToast(msg: 'Need to choose photo', backgroundColor: Colors.black.withOpacity(0.7));
                            }

                            if(_fileTitleController.text.isEmpty){
                              Fluttertoast.showToast(msg: 'Need to fill photo name', backgroundColor: Colors.black.withOpacity(0.7));
                            }
                          },
                            child: Text('Upload', style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,),
                        ),
                      )
                    ],
                  )
                ],
              ) :
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[CircularProgressIndicator()],),
              )
          ),
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_apply_biz_license_photo, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ModalProgressHUD(inAsyncCall: _isLoading,progressIndicator: modalProgressIndicator(),child: _asyncLoader),
    );
  }
}
