import 'package:async_loader/async_loader.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/EmptyViewWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:dio/dio.dart';
import 'model/ApplyBizLicenseModel.dart';
import 'helper/ServiceHelper.dart';
import 'ApplyBizLicenseDetailScreen.dart';

class ApplyBizLicenseListScreen extends StatefulWidget {
  @override
  _ApplyBizLicenseListScreenState createState() => _ApplyBizLicenseListScreenState();
}

class _ApplyBizLicenseListScreenState extends State<ApplyBizLicenseListScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  bool _isCon;
  var _response;
  String display;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  List<ApplyBizLicenseModel> _applyBizLicenseModelList = new List<ApplyBizLicenseModel>();

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

  _getAllApplyBizLicense()async{
     await _sharepreferenceshelper.initSharePref();
     _response = await ServiceHelper().getAllApplyBizLicenseByUser(_sharepreferenceshelper.getRegionCode(), _sharepreferenceshelper.getUserUniqueKey());
     List applyBizLicenseList = _response.data;
     //List applyBizLicenseList = [];
     if(applyBizLicenseList != null && applyBizLicenseList.length > 0){
       for(var i in applyBizLicenseList){
         setState(() {
           _applyBizLicenseModelList.add(ApplyBizLicenseModel.fromJson(i));
         });
       }
     }
  }

  _listView(){
    return ListView.builder(
        itemCount: _applyBizLicenseModelList.length,
        itemBuilder: (context, i){
          return Column(
            children: <Widget>[
              //header
              i==0? headerTitleWidget(MyString.txt_apply_biz_license, 'business_license_nocircle') : Container(),
              GestureDetector(
                onTap: (){
                  /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => ApplyBizLicenseDetailScreen(_applyBizLicenseModelList[i]),
                    settings: RouteSettings(name: ScreenName.APPLY_BIZ_LICENSE_DETAIL_SCREEN)
                  ));*/
                  NavigatorHelper().MyNavigatorPush(context, ApplyBizLicenseDetailScreen(_applyBizLicenseModelList[i]), ScreenName.APPLY_BIZ_LICENSE_DETAIL_SCREEN);
                },
                child: Card(
                  margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                  child: Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //image valid
                        Container(
                            margin: EdgeInsets.only(right: 15.0),
                            child: Image.asset(_applyBizLicenseModelList[i].isValid==true?'images/isvalid.png':'images/pending.png', width: 20.0, height: 20.0,)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //biz name
                              Text(_applyBizLicenseModelList[i].bizName.isNotEmpty? _applyBizLicenseModelList[i].bizName:'---',
                                style: TextStyle(fontSize: FontSize.textSizeExtraSmall),overflow: TextOverflow.ellipsis,maxLines: 1,),
                              //license type
                              Text(_applyBizLicenseModelList[i].licenseType,
                                style: TextStyle(fontSize: FontSize.textSizeExtraSmall),overflow: TextOverflow.ellipsis,maxLines: 1,)
                            ],
                          ),
                        ),
                        //image arrow
                        Image.asset('images/arrow.png',width: 15.0, height: 15.0,)
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
    _applyBizLicenseModelList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getAllApplyBizLicense(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: _applyBizLicenseModelList.isNotEmpty? _listView() :
              emptyView(asyncLoaderState,  MyString.txt_no_data)
          ),
        )
    );
    return CustomScaffoldWidget(
        title : MyString.txt_apply_biz_license,
        body: _asyncLoader
    );
    /*return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_apply_biz_license, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: _asyncLoader,
    );*/
  }
}
