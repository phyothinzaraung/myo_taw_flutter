import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/NumberFormatterHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserBillAmountViewModel.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:async_loader/async_loader.dart';
import 'helper/ServiceHelper.dart';
import 'model/PaymentLogModel.dart';
import 'helper/NumConvertHelper.dart';
import 'Database/UserDb.dart';
import 'model/UserModel.dart';
import 'TopUpRecordListScreen.dart';
import 'PinCodeSetUpScreen.dart';
import 'PaymentScreen.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class OnlineTaxScreen extends StatefulWidget {
  @override
  _OnlineTaxScreenState createState() => _OnlineTaxScreenState();
}

class _OnlineTaxScreenState extends State<OnlineTaxScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  bool _isCon;
  var _response;
  int _amount = 0;
  String _name;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserBillAmountViewModel _amountViewModel;
  UserDb _userDb = UserDb();
  UserModel _userModel;
  List<PaymentLogModel> _paymentLogList = new List<PaymentLogModel>();
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

  _getUserBillAmount()async{
    await _sharepreferenceshelper.initSharePref();
    _response = await ServiceHelper().getUserBillAmount(_sharepreferenceshelper.getUserUniqueKey());
    _amountViewModel = UserBillAmountViewModel.fromJson(_response.data);
    if(_amountViewModel != null){
      _name = _amountViewModel.name;
      _amount = _amountViewModel.totalAmount;
      var list = _response.data['Log'];
      for(var i in list){
        setState(() {
          _paymentLogList.add(PaymentLogModel.fromJson(i));
        });
      }
    }
  }

  String _taxType(String str){
    switch(str){
      case MyString.PROPERTY_TAX:
        return MyString.MYAN_PROPERTY_TAX;
        break;
      case MyString.BIZ_LICENSE:
        return MyString.MYAN_BIZ_LICENSE;
        break;
      case MyString.WATER_METER:
        return MyString.MYAN_WATER_METER;
        break;
      case MyString.MARKET_TAX:
        return MyString.MYAN_MARKET_TAX;
        break;
      case MyString.WHEEL_TAX:
        return MyString.MYAN_WHEEL_TAX;
        break;
      case MyString.SIGNBOARD_TAX:
        return MyString.MYAN_SIGNBOARD_TAX;
        break;
      default:
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
    await _getUserBillAmount();
    setState(() {
      _isRefresh = false;
    });
  }


  _navigateToPaymentScreen()async{
    Map result = await NavigatorHelper().MyNavigatorPush(context, PaymentScreen(), ScreenName.ONLINE_TAX_PAYMENT_SCREEN);
    if(result != null && result.containsKey('isNeedRefresh') == true){
      _handleRefresh();
    }
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
                Text(MyString.txt_online_tax, style: TextStyle(fontSize: FontSize.textSizeSmall),)
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 370.0,
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
                          Text(NumConvertHelper.getMyanNumString(NumberFormatterHelper.NumberFormat(_amount.toString())) +' '+MyString.txt_kyat, style: TextStyle(fontSize: FontSize.textSizeLarge, color: Colors.white),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 2.5),
                              height: 45.0,
                              child: RaisedButton(onPressed: ()async{

                                /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopUpRecordListScreen(_userModel),
                                  settings: RouteSettings(name: ScreenName.TOP_UP_RECORD_LIST_SCREEN)
                                ));*/
                                NavigatorHelper().MyNavigatorPush(context, TopUpRecordListScreen(_userModel), ScreenName.TOP_UP_RECORD_LIST_SCREEN);

                                }, child: Text(MyString.txt_top_up_record, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                                color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 2.5),
                              height: 45.0,
                              child: RaisedButton(onPressed: ()async{
                                _navigateToPaymentScreen();

                                }, child: Text(MyString.txt_pay_tax, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                                color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                            ),
                          ),
                        ],
                      ),
                    )

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
        itemCount: _paymentLogList.length,
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
                                Expanded(child: Text(MyString.txt_tax_type, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                                Expanded(child: Text(_taxType(_paymentLogList[index].taxType), style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(child: Text(MyString.txt_tax_bill_amount, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                                Expanded(child: Text(NumConvertHelper.getMyanNumString(NumberFormatterHelper.NumberFormat(_paymentLogList[index].useAmount.toString()))+'  '+MyString.txt_kyat, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))
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
    setState(() {
      _isRefresh = true;
    });
    if(_isCon){
      setState(() {
        _paymentLogList.clear();
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
        renderError: ([error]) => getNoConnectionWidget(),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: _isRefresh == false?_paymentLogList.isNotEmpty?_listView() :
                  ListView(children: <Widget>[_header()],) :
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[CircularProgressIndicator()],),
              )
          ),
        )
    );
    return CustomScaffoldWidget(
      title: MyString.txt_online_tax,
      body: _asyncLoader,
      globalKey: _globalKey,
    );
    /*return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(MyString.txt_online_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: _asyncLoader,
    );*/
  }
}
