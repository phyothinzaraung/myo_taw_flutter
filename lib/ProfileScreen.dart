import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';
import 'helper/NumConvertHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:myotaw/Database/UserDb.dart';
import 'SplashScreen.dart';
import 'Database/SaveNewsFeedDb.dart';
import 'package:dio/dio.dart';
import 'package:async_loader/async_loader.dart';
import 'helper/ServiceHelper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helper/MyLoadMore.dart';
import 'model/TaxRecordModel.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'ProfileFormScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'ProfilePhotoUploadScreen.dart';
import 'NewTaxRecordScreen.dart';

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
  int pageCount = 10;
  Response response;
  ImageProvider _profilePhoto;
  List<TaxRecordModel> _taxRecordModelList = new List<TaxRecordModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkCon();
  }

  _getAllTaxRecord(int p)async{
    _profilePhoto = new CachedNetworkImageProvider(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl);
    response = await ServiceHelper().getAllTaxRecord(p, pageCount, _userModel.currentRegionCode, _userModel.uniqueKey);
    var result = response.data['Results'];
    if(response.statusCode == 200){
      if(result != null){
        if(result.length > 0){
          for(var model in result){
            _taxRecordModelList.add(TaxRecordModel.fromJson(model));
          }
          //prevent set state is called after NewsFeedScreen is disposed
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
    }else{
      Fluttertoast.showToast(msg: 'နောက်တစ်ကြိမ်လုပ်ဆောင်ပါ။', backgroundColor: Colors.black.withOpacity(0.7));
    }
  }

  _getUser()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUniqueKey());
    await _userDb.closeUserDb();
    setState(() {
      _userModel = model;
    });
    await _getAllTaxRecord(page);
    //print('userphoto; ${_userModel.photoUrl}');
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
    await _sharepreferenceshelper.initSharePref();
    await _sharepreferenceshelper.logOutSharePref();
    await _userDb.openUserDb();
    await _userDb.deleteUser();
    await _userDb.closeUserDb();
    await _saveNewsFeedDb.openSaveNfDb();
    await _saveNewsFeedDb.deleteSavedNewsFeed();
    await _saveNewsFeedDb.closeSaveNfDb();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SplashScreen()),(Route<dynamic>route) => false);
  }

  _dialogLogOut(){
    showDialog(context: (context),
      builder: (context){
        return SimpleDialog(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(margin: EdgeInsets.only(bottom: 10.0),child: Image.asset('images/logout_icon.png', width: 50.0, height: 50.0,)),
                Container(margin: EdgeInsets.only(bottom: 10.0),child: Text(MyString.txt_are_u_sure,
                  style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: 90.0,
                      child: RaisedButton(onPressed: (){
                        _logOutClear();
                        },child: Text(MyString.txt_log_out,style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                        color: MyColor.colorPrimary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                    ),
                    Container(
                      height: 40.0,
                      width: 90.0,
                      child: RaisedButton(onPressed: (){
                          Navigator.of(context).pop();
                        },child: Text(MyString.txt_log_out_cancel,style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
                        color: MyColor.colorGrey,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                    )

                  ],
                )
              ],
            )
          ],
        );
      }
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
                  child: Text('Loading......',style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack))),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColor.colorPrimary))
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTaxRecord(int id)async{
    response = await ServiceHelper().deleteTaxRecord(id);
    await _handleRefresh();
    setState(() {
      _isLoading = false;
    });
  }

  _dialogDelete(int id){
    showDialog(
        context: context,
        builder: (ctxt){
          return Dialog(
            child: Container(
              margin: EdgeInsets.all(10.0),
              height: 160.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(margin: EdgeInsets.only(bottom: 10.0),child: Image.asset('images/confirm_icon.png', width: 60.0, height: 60.0,)),
                  Text(MyString.txt_are_u_sure, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(onPressed: (){
                          Navigator.of(context).pop();
                          setState(() {
                            _isLoading = true;
                          });
                          _deleteTaxRecord(id);
                          },child: Text(MyString.txt_delete,
                          style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,),
                        RaisedButton(onPressed: (){
                          Navigator.of(context).pop();
                          },child: Text(MyString.txt_delete_cancel, style: TextStyle(fontSize: FontSize.textSizeSmall),),color: MyColor.colorGrey,)
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _taxRecordList(int i){
    TaxRecordModel taxRecordModel = _taxRecordModelList[i];
    return Card(
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
                    Text(showDateTime(taxRecordModel.accessTime), style: TextStyle(fontSize: FontSize.textSizeSmall,color: MyColor.colorTextBlack),)
                  ],
                ),
              ),
            ),
            GestureDetector(onTap: (){
              _dialogDelete(taxRecordModel.id);
              },child: Icon(Icons.delete, color: MyColor.colorPrimary,))
          ],
        ),
      ),
    );

  }

  _navigateToProfileScreen()async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileFormScreen()));
    if(result != null && result.containsKey('isNeedRefresh') == true){
      //await _getUser();
      await _handleRefresh();
    }
  }

  _navigateToProfilePhotoScreen()async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePhotoUploadScreen()));
    if(result != null && result.containsKey('isNeedRefresh') == true){
      //await _getUser();
      await _handleRefresh();
    }
  }

  _navigateToNewTaxRecordScreen()async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewTaxRecordScreen()));
    if(result != null && result.containsKey('isNeedRefresh') == true){
      //await _getUser();
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
                            CircleAvatar(backgroundImage: _userModel!=null?
                            _profilePhoto:AssetImage('images/profile_placeholder.png'),
                              backgroundColor: MyColor.colorGrey, radius: 50.0,),
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
                                child: Text(_userModel!=null?_userModel.name:'', style: TextStyle(fontSize: FontSize.textSizeSmall,color: MyColor.colorTextBlack),)),
                            Text(NumConvertHelper().getMyanNumString(_userModel!=null?_userModel.phoneNo:''), style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
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
                    GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/apply_biz_list.png',width: 30.0, height: 38.0,)),
                            Text(MyString.txt_apply_biz_license, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: MyColor.colorPrimary,),
                    GestureDetector(
                      onTap: (){
                        _dialogLogOut();
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
        Container(
          margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(margin: EdgeInsets.only(bottom: 5.0),
                  child: Text(MyString.txt_tax_record, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorPrimary),)),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                height: 50.0,
                width: 300.0,
                //new tax record
                child: RaisedButton(onPressed: (){
                  _navigateToNewTaxRecordScreen();
                  },child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Container(margin: EdgeInsets.only(right: 10.0),child: Text(MyString.txt_tax_new_record, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),),
                    Icon(Icons.add, color: Colors.white,)
                  ],
                ),color: MyColor.colorPrimary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerProfileRefresh(){
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
                            CircleAvatar(backgroundImage: _userModel!=null?
                            _profilePhoto:AssetImage('images/profile_placeholder.png'),
                              backgroundColor: MyColor.colorGrey, radius: 50.0,),
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
                                child: Text(_userModel!=null?_userModel.name:'', style: TextStyle(fontSize: FontSize.textSizeSmall,color: MyColor.colorTextBlack),)),
                            Text(NumConvertHelper().getMyanNumString(_userModel!=null?_userModel.phoneNo:''), style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
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
                    GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/apply_biz_list.png',width: 30.0, height: 38.0,)),
                            Text(MyString.txt_apply_biz_license, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: MyColor.colorPrimary,),
                    GestureDetector(
                      onTap: (){
                        _dialogLogOut();
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
        Container(
          margin: EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0, bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(margin: EdgeInsets.only(bottom: 5.0),
                  child: Text(MyString.txt_tax_record, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorPrimary),)),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                height: 50.0,
                width: 300.0,
                //new tax record
                child: RaisedButton(onPressed: (){
                  _navigateToNewTaxRecordScreen();
                },child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(margin: EdgeInsets.only(right: 10.0),child: Text(MyString.txt_tax_new_record, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),),
                    Icon(Icons.add, color: Colors.white,)
                  ],
                ),color: MyColor.colorPrimary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
              )
            ],
          ),
        ),
        CircularProgressIndicator()
      ],
    );
  }


  Widget _listView(){
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

  }

  Widget getNoConnectionWidget(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _headerProfile(),
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
      child: ListView(
        children: <Widget>[
          _headerProfile(),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[CircularProgressIndicator()],)
        ],
      )
    );
  }

  Future<Null> _handleRefresh() async {
    await _checkCon();
    if(_isCon){
      _taxRecordModelList.clear();
      page = 0;
      page++;
      _getUser();
    }else{
      Fluttertoast.showToast(msg: 'Check Connection', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeSmall);
    }
    return null;
  }

  Future<bool> _loadMore() async {
    await _checkCon();
    if(_isCon){
      page++;
      await _getAllTaxRecord(page);
      //Fluttertoast.showToast(msg: 'call loadmore');
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
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: LoadMore(
                isFinish: _isEnd,
                onLoadMore: _loadMore,
                delegate: DefaultLoadMoreDelegate(),
                textBuilder: DefaultLoadMoreTextBuilder.english,
                child: _taxRecordModelList.isNotEmpty?_listView(): _headerProfileRefresh()
            ),
          ),
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_profile, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ModalProgressHUD(inAsyncCall: _isLoading,progressIndicator: modalProgressIndicator(),child: _asyncLoader),
    );
  }
}
