import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myotaw/OnlineTaxScreen.dart';
import 'package:myotaw/database/UserDb.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/model/DashBoardModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'package:myotaw/myWidget/OnlineTaxPinRequestDialogWidget.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'PinCodeSetUpScreen.dart';
import 'helper/MyoTawConstant.dart';
import 'SmartWaterMeterScreen.dart';
import 'helper/ServiceHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/UserModel.dart';
import 'myWidget/NoConnectionWidget.dart';
import 'myWidget/PrimaryColorSnackBarWidget.dart';
import 'myWidget/WarningSnackBarWidget.dart';

class OnlineTaxChooseScreen extends StatefulWidget {
  @override
  _OnlineTaxChooseScreenState createState() => _OnlineTaxChooseScreenState();
}

class _OnlineTaxChooseScreenState extends State<OnlineTaxChooseScreen> {
  UserModel _userModel;
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  List<DashBoardModel> _widgetList = new List();
  UserDb _userDb = UserDb();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _initOnlineTaxChooseWidget(){
    DashBoardModel model1 = new DashBoardModel();
    model1.image = 'images/online_tax.png';
    model1.title = MyString.title_online_tax_payment;

    DashBoardModel model2 = new DashBoardModel();
    model2.image = 'images/smart_water_meter.png';
    model2.title = MyString.title_smart_water_meter;

    _widgetList.add(model1);
    _widgetList.add(model2);
  }

  void _getUser()async{
    await _sharepreferenceshelper.initSharePref();
    var response = await ServiceHelper().getUserInfo(_sharepreferenceshelper.getUserUniqueKey());
    print(response.data);
    if(response.data != null){
      _userModel = UserModel.fromJson(response.data);
      await _userDb.openUserDb();
      await _userDb.insert(_userModel);
      await _userDb.closeUserDb();
      if(mounted){
        setState(() {
          _initOnlineTaxChooseWidget();
        });
      }
    }
  }

  _dialogPinRequest(String type){
    return showDialog(context: context, builder: (context){
      return OnlineTaxPinRequestDialogWidget(type, _userModel);
    }, barrierDismissible: false);
  }

  _navigateToPinCodeSetupScreen()async{
    Map result = await NavigatorHelper().MyNavigatorPush(context, PinCodeSetUpScreen(_userModel), ScreenName.PIN_CODE_SET_UP_SCREEN);
    if(result != null && result.containsKey('isNeedRefresh')){
      _handleRefresh();
    }
  }

  _listView(){
    return Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    //margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
                    child: headerTitleWidget(MyString.txt_online_tax, 'online_tax_no_circle'),
                  )
                ])),
            SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index){
                  return GestureDetector(
                    onTap: (){
                      if(_userModel.pinCode != null){
                        if(_userModel.currentRegionCode == MyString.TGY_REGIONCODE){
                          _dialogPinRequest(index==0?'OnlineTax':'SmartWm');
                          OnlineTaxPinRequestDialogWidget(index==0?'OnlineTax':'SmartWm', _userModel);
                        }else{
                          PrimaryColorSnackBarWidget(_globalKey, MyString.txt_coming_soon);
                        }

                      }else{
                       _navigateToPinCodeSetupScreen();
                      }

                    },
                    child: Container(
                      //margin: EdgeInsets.only(top: 7, bottom: 7),
                      child: Column(
                        children: <Widget>[
                          //image dao
                          Flexible(flex: 2,child: Image.asset(_widgetList[index].image,)),
                          //text title
                          Flexible(flex: 1,child: Text(_widgetList[index].title,textAlign: TextAlign.center,
                            style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: MyColor.colorTextBlack),))],),),
                  );
                },childCount: _widgetList.length),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250.0,
                  crossAxisSpacing: 0.0,))
          ],
        )
    );
  }

  Future<Null> _handleRefresh() async {
    _widgetList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
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
            child: _listView(),
          ),
        )
    );
    return CustomScaffoldWidget(
      title: MyString.txt_online_payment_tax,
      body: _asyncLoader,
      globalKey: _globalKey,
    );
    /*return Scaffold(
      key: _globalKey,
      appBar: AppBar(
          title: Text(MyString.txt_online_payment_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),)
      ),
      body: _asyncLoader,
    );*/
  }
}


