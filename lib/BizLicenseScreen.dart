import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/ServiceHelper.dart';
import 'package:dio/dio.dart';
import 'model/BizLicenseModel.dart';
import 'package:async_loader/async_loader.dart';
import 'helper/SharePreferencesHelper.dart';
import 'BizLicenseDetailScreen.dart';
import 'ApplyBizLicenseListScreen.dart';
import 'myWidget/EmptyViewWidget.dart';

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
    List bizLicenseList = _response.data;
    //var bizLicenseList = [];
    if(bizLicenseList != null && bizLicenseList.length > 0){
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
              //header
              i==0? headerTitleWidget(MyString.title_biz_license) : Container(),
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
                        //text license type
                        Expanded(
                          child: Text(_bizLicenseModelList[i].licenseType,
                            style: TextStyle(fontSize: FontSize.textSizeExtraSmall),overflow: TextOverflow.ellipsis,maxLines: 2,),
                        ),
                        //text valid image
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
    _bizLicenseModelList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
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
              child: _bizLicenseModelList.isNotEmpty? _listView() :
                  Column(
                    children: <Widget>[
                      headerTitleWidget(MyString.title_biz_license),
                      Expanded(child: emptyView(asyncLoaderState,MyString.txt_no_data)),
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
