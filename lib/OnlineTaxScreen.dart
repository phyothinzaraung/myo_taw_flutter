import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserBillAmountViewModel.dart';
import 'package:dio/dio.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:async_loader/async_loader.dart';
import 'helper/ServiceHelper.dart';
import 'model/PaymentLogModel.dart';
import 'helper/NumConvertHelper.dart';
import 'Database/UserDb.dart';
import 'model/UserModel.dart';
import 'TopUpScreen.dart';
import 'PinCodeSetUpScreen.dart';
import 'PaymentScreen.dart';

class OnlineTaxScreen extends StatefulWidget {
  @override
  _OnlineTaxScreenState createState() => _OnlineTaxScreenState();
}

class _OnlineTaxScreenState extends State<OnlineTaxScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  bool _isCon;
  Response _response;
  int _amount = 0;
  String _name;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserBillAmountViewModel _amountViewModel;
  UserDb _userDb = UserDb();
  UserModel _userModel;
  List<PaymentLogModel> _paymentLogList = new List<PaymentLogModel>();
  bool _isRefresh = false;

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
    _response = await ServiceHelper().getUserBillAmount(_sharepreferenceshelper.getUniqueKey());
    _amountViewModel = UserBillAmountViewModel.formJson(_response.data);
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
        return 'ပစ္စည်းခွန် (စံငှားခွန်)';
        break;
      case MyString.BIZ_LICENSE:
        return 'လုပ်ငန်းလိုင်စင်';
        break;
      case MyString.WATER_METER:
        return 'ရေမီတာခွန်';
        break;
      case MyString.MARKET_TAX:
        return 'ဈေးဆိုင်ခန်းခွန်';
        break;
      case MyString.WHEEL_TAX:
        return 'ဘီးခွန်';
        break;
      case MyString.SIGNBOARD_TAX:
        return 'ကြော်ငြာဆိုင်းဘုတ်ခွန်';
        break;
      default:
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
    await _getUserBillAmount();
    setState(() {
      _isRefresh = false;
    });
  }

  _navigateToTopUpScreen()async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopUpScreen(_userModel)));
    if(result != null && result.containsKey('isNeedRefresh') == true){
      _handleRefresh();
    }
  }

  _navigateToPinCodeSetUpScreen()async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PinCodeSetUpScreen(_userModel)));
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
            height: 330.0,
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
                        radius: 60.0,
                      ),
                    ),
                    Container(
                        child: Text(_name, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Text(MyString.txt_user_money, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)),
                          Expanded(child: Text(NumConvertHelper().getMyanNumInt(_amount), style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 10.0),
                              height: 45.0,
                              child: RaisedButton(onPressed: ()async{
                                if(_userModel.pinCode != 0){
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopUpScreen(_userModel)));
                                  _navigateToTopUpScreen();
                                }else{
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => PinCodeSetUpScreen(_userModel)));
                                  _navigateToPinCodeSetUpScreen();
                                }
                              }, child: Text(MyString.txt_top_up, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                                color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10.0),
                              height: 45.0,
                              child: RaisedButton(onPressed: ()async{
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentScreen()));

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
                                Expanded(child: Text(NumConvertHelper().getMyanNumInt(_paymentLogList[index].useAmount)+'  '+MyString.txt_kyat, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))
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
      Fluttertoast.showToast(msg: 'Check Connection', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeSmall);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_online_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: _asyncLoader,
    );
  }
}
