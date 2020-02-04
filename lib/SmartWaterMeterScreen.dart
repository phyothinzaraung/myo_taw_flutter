import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/NumberFormatterHelper.dart';
import 'package:myotaw/model/SmartWaterMeterUnitModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'model/SmartWaterMeterUnitModel.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:async_loader/async_loader.dart';
import 'helper/ServiceHelper.dart';
import 'helper/NumConvertHelper.dart';
import 'Database/UserDb.dart';
import 'model/UserModel.dart';
import 'TopUpRecordListScreen.dart';
import 'model/SmartWaterMeterLogModel.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'myWidget/CustomButtonWidget.dart';

class SmartWaterMeterScreen extends StatefulWidget {
  UserModel _userModel;
  SmartWaterMeterScreen(this._userModel);
  @override
  _SmartWaterMeterScreenState createState() => _SmartWaterMeterScreenState();
}

class _SmartWaterMeterScreenState extends State<SmartWaterMeterScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  bool _isCon;
  var _responseWaterMeterUnit, _responseWaterMeterLog;
  int _amount,_finalUnit = 0;
  String _name, _meterNo;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  SmartWaterMeterUnitModel _smartWaterMeterUnitModel;
  UserDb _userDb = UserDb();
  UserModel _userModel;
  List<SmartWaterMeterLogModel> _smartWaterMeterLogList = new List<SmartWaterMeterLogModel>();
  bool _isRefresh = false;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();

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

  _getWaterMeterUnit()async{
    _responseWaterMeterUnit = await ServiceHelper().getSmartWaterMeterUnit(widget._userModel.meterNo);
    if(_responseWaterMeterUnit.data != null){
      _finalUnit = _responseWaterMeterUnit.data;
      _meterNo = widget._userModel.meterNo;
    }
  }

  _getSmartWaterMeterLog()async{
    _responseWaterMeterLog = await ServiceHelper().getSmartWaterMeterLog(widget._userModel.meterNo);
    _amount = _responseWaterMeterLog.data['Amount'];
    var list = _responseWaterMeterLog.data['Log'];
    for(var i in list){
      setState(() {
        _smartWaterMeterLogList.add(SmartWaterMeterLogModel.fromJson(i));
      });
    }
  }

  _getUser()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    await _userDb.closeUserDb();
    setState(() {
      _userModel = model;
    });
    _name = _userModel.name;
    await _getWaterMeterUnit();
    await _getSmartWaterMeterLog();
    setState(() {
      _isRefresh = false;
    });
  }

  Widget _header(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
            child: Row(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: Image.asset('images/online_tax_no_circle.png', width: 30.0, height: 30.0,)),
                Text(MyString.txt_smart_water_meter, style: TextStyle(fontSize: FontSize.textSizeSmall),)
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 520.0,
            child: Card(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              color: MyColor.colorPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: CircleAvatar(
                        backgroundImage: _userModel.photoUrl==null?AssetImage('images/profile_placeholder.png'):
                        NetworkImage(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl),
                        backgroundColor: MyColor.colorGrey,
                        radius: 45.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                        child: Text(_name, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Divider(
                        height: 1,
                        color: Colors.white,
                        thickness: 1.5,
                      ),
                    ),
                    Text(MyString.txt_user_money, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10),
                              child: Image.asset('images/money.png', width: 35, height: 35,)),
                          Text(NumConvertHelper.getMyanNumString(NumberFormatterHelper.NumberFormat(_amount.toString()))+' '+MyString.txt_kyat, style: TextStyle(fontSize: FontSize.textSizeLarge, color: Colors.white),),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                        child: Text(MyString.txt_water_meter_unit, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(_finalUnit.toString(),
                        style: TextStyle(fontSize: FontSize.textSizeLarge, color: Colors.white),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Divider(
                        height: 1,
                        color: Colors.white,
                        thickness: 1.5,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(MyString.txt_water_meter_no,
                              style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),),
                          ),
                          Expanded(
                            child: Text(_meterNo,
                              style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: Colors.white),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 2.5),
                      height: 45.0,
                      width: double.maxFinite,
                      child: CustomButtonWidget(onPress: ()async{

                        /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopUpRecordListScreen(_userModel),
                          settings: RouteSettings(name: ScreenName.TOP_UP_RECORD_LIST_SCREEN)
                        ));*/
                        NavigatorHelper().MyNavigatorPush(context, TopUpRecordListScreen(_userModel), ScreenName.TOP_UP_RECORD_LIST_SCREEN);

                        }, child: Text(MyString.txt_top_up_record, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                        color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                    ),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }

  _listView(){
    return ListView.builder(
        itemCount: _smartWaterMeterLogList.length,
        itemBuilder: (context, index){
          return Column(children: <Widget>[
            index == 0? _header() : Container(),
            Card(
              margin: EdgeInsets.all(0.5),
              elevation: 0,
              child: Container(
                padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Image.asset('images/payment_history.png', width: 30.0, height: 30.0,)),
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(child: Text(MyString.txt_smart_wm_date, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                                Expanded(child: Text(ShowDateTimeHelper().showDateTimeFromServer(_smartWaterMeterLogList[index].date), style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(child: Text(MyString.txt_smart_wm_unit, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                                Expanded(child: Text(_smartWaterMeterLogList[index].unit.toString(), style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(child: Text(MyString.txt_smart_wm_amount, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                                Expanded(child: Text(_smartWaterMeterLogList[index].amount.toString()+'  '+MyString.txt_kyat, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )
              ),
            )
          ],);
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
    await _checkCon();
    setState(() {
      _isRefresh = true;
    });
    if(_isCon){
      setState(() {
        _smartWaterMeterLogList.clear();
      });
      _getUser();
    }else{
      WarningSnackBar(_globalKey, MyString.txt_no_internet);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getUser(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: widget._userModel.meterNo!=null?_isRefresh == false?_smartWaterMeterLogList.isNotEmpty?_listView() :
                  ListView(children: <Widget>[_header()],) :
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[CircularProgressIndicator()],),
              ) : Container(
                padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                          child: Image.asset('images/warning.png', width: 70, height: 70,)),
                      Text(MyString.txt_smart_wm_not_register, style: TextStyle(fontSize: FontSize.textSizeNormal,),textAlign: TextAlign.center,)
                ],
              ))
          ),
        )
    );
    return CustomScaffoldWidget(
      title: Text(MyString.txt_smart_water_meter,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _asyncLoader,
      globalKey: _globalKey,
    );
    /*return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(MyString.txt_smart_water_meter, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: _asyncLoader,
    );*/
  }
}
