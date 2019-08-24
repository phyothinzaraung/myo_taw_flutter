import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/ServiceHelper.dart';
import 'package:dio/dio.dart';
import 'model/BizLicenseModel.dart';
import 'package:async_loader/async_loader.dart';
import 'helper/SharePreferencesHelper.dart';
import 'BizLicenseDetailScreen.dart';
import 'ApplyBizLicenseListScreen.dart';

class BizLicenseScreen extends StatefulWidget {
  @override
  _BizLicenseScreenState createState() => _BizLicenseScreenState();
}

class _BizLicenseScreenState extends State<BizLicenseScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  bool _isCon;
  Response _response;
  String display;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  List<BizLicenseModel> _bizLicenseModelList = new List<BizLicenseModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    _response = await ServiceHelper().getBizLicense(_sharepreferenceshelper.getRegionCode());
    if(_response.data != null){
      var bizLicenseList = _response.data;
      for(var i in bizLicenseList){
        setState(() {
          _bizLicenseModelList.add(BizLicenseModel.fromJson(i));
        });
      }
    }
  }

  _listView(){
    return ListView.builder(
        itemCount: _bizLicenseModelList.length,
        itemBuilder: (context, i){
          return Column(
            children: <Widget>[
              i==0?Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
                child: Row(
                  children: <Widget>[
                    Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/business_license_nocircle.png', width: 30.0, height: 30.0,)),
                    Text(MyString.title_biz_license, style: TextStyle(fontSize: FontSize.textSizeSmall),)
                  ],
                ),
              ):Container(),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BizLicenseDetailScreen(_bizLicenseModelList[i])));
                },
                child: Card(
                  margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                  child: Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(_bizLicenseModelList[i].licenseType,
                            style: TextStyle(fontSize: FontSize.textSizeExtraSmall),overflow: TextOverflow.ellipsis,maxLines: 2,),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15.0),
                            child: Image.asset(_bizLicenseModelList[i].isApplyAllow==true?'images/isvalid.png':'images/pending.png', width: 20.0, height: 20.0,))
                      ],
                    ),
                  ),
                ),
              )
            ],
          );

        });
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
        _bizLicenseModelList.clear();
      });
      _getAllBizLicense();
    }else{
      Fluttertoast.showToast(msg: 'Check Connection', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeSmall);
    }
    return null;
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
              child: _bizLicenseModelList.isNotEmpty?_listView() :
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
                    child: Row(
                      children: <Widget>[
                        Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/business_license_nocircle.png', width: 30.0, height: 30.0,)),
                        Text(MyString.title_biz_license, style: TextStyle(fontSize: FontSize.textSizeSmall),)
                      ],
                    ),
                  ),
                  CircularProgressIndicator()
                ],
              )
          ),
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_business_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ApplyBizLicenseListScreen()));
            },
            child: Container(
                margin: EdgeInsets.only(right: 10.0),
                child: Image.asset('images/history.png', width: 30.0, height: 30.0,)),
          )
        ],
      ),
      body: _asyncLoader,
    );
  }
}
