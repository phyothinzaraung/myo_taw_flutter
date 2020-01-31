import 'package:async_loader/async_loader.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/NumConvertHelper.dart';
import 'package:myotaw/helper/NumberFormatterHelper.dart';
import 'package:myotaw/model/TopUpLogModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';
import 'helper/ServiceHelper.dart';
import 'myWidget/EmptyViewWidget.dart';
import 'myWidget/NoConnectionWidget.dart';

class TopUpRecordListScreen extends StatefulWidget {
  UserModel model;
  TopUpRecordListScreen(this.model);
  @override
  _TopUpRecordListScreenState createState() => _TopUpRecordListScreenState(this.model);
}

class _TopUpRecordListScreenState extends State<TopUpRecordListScreen> {
  UserModel _userModel;
  TextEditingController _prepaidCodeController = TextEditingController();
  TextEditingController _pinCodeController = TextEditingController();
  bool _isLoading = false;
  bool _hasError = false;
  bool _isCon = false;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  List<TopUpLogModel> _topUpLogModelList = List();

  _TopUpRecordListScreenState(this._userModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _getTopUpList()async{
    var _response = await ServiceHelper().getTopUpLogList(_userModel.meterNo);
    if(_response.data != null && _response.data.length > 0){
      for(var i in _response.data){
        _topUpLogModelList.add(TopUpLogModel.fromJson(i));
      }
    }
  }

  _listView(){
    return ListView.builder(
        itemCount: _topUpLogModelList.length,
        itemBuilder: (context, index){
          return Card(
            margin: EdgeInsets.only(top: 15, right: 15, left: 15),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Image.asset('images/payment_history.png', width: 35, height: 35,)),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(MyString.txt_top_up_amount, style: TextStyle(fontSize: FontSize.textSizeExtraSmall),)),
                            Text('${NumConvertHelper.getMyanNumString(NumberFormatterHelper.NumberFormat(_topUpLogModelList[index].amount.toString()))} ${MyString.txt_kyat}',
                                style: TextStyle(fontSize: FontSize.textSizeNormal))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(MyString.txt_top_up_amount_before, style: TextStyle(fontSize: FontSize.textSizeExtraSmall),)),
                            Text('${NumConvertHelper.getMyanNumString(NumberFormatterHelper.NumberFormat(_topUpLogModelList[index].leftAmount.toString()))} ${MyString.txt_kyat}',
                                style: TextStyle(fontSize: FontSize.textSizeNormal))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(MyString.txt_top_up_amount_after, style: TextStyle(fontSize: FontSize.textSizeExtraSmall),)),
                            Text('${NumConvertHelper.getMyanNumString(NumberFormatterHelper.NumberFormat(_topUpLogModelList[index].totalAmount.toString()))} ${MyString.txt_kyat}',
                                style: TextStyle(fontSize: FontSize.textSizeNormal))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  /*_callWebService() async{
    _response = await ServiceHelper().getTopUp(_prepaidCodeController.text, _userModel.uniqueKey);
    if(_response.data == 'Success'){
      Navigator.of(context).pop({'isNeedRefresh' : true});
    }else if(_response.data == 'Expired Date'){
      WarningSnackBar(_scaffoldState, MyString.txt_top_up_expired);
    }else{
      WarningSnackBar(_scaffoldState, MyString.txt_top_up_already);
    }
  }*/

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
  }

  /*_dialogConfirm(){
    return showDialog(context: context, builder: (context){
      return WillPopScope(
          child: SimpleDialog(
            contentPadding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
            children: <Widget>[
              Column(
                children: <Widget>[
                  //image
                  Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Image.asset('images/online_tax_no_circle.png', width: 60.0, height: 60.0,)),
                  //text are u sure
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(MyString.txt_are_u_sure,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack,),textAlign: TextAlign.center,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //btn top up
                    RaisedButton(onPressed: (){
                      Navigator.of(context).pop();
                      _callWebService();

                      },child: Text(MyString.txt_top_up,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),),
                    //btn out
                    RaisedButton(onPressed: (){
                      Navigator.pop(context);

                      },child: Text(MyString.txt_log_out,
                      style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),color: MyColor.colorGrey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),)
                  ],)
                ],
              )
            ],), onWillPop: (){});
    }, barrierDismissible: false);
  }*/

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
    _topUpLogModelList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  @override
  Widget build(BuildContext context) {

    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getTopUpList(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: _topUpLogModelList.isNotEmpty?_listView() : emptyView(asyncLoaderState,MyString.txt_no_top_up_record),
          ),
        )
    );
    return CustomScaffoldWidget(
      title: MyString.txt_top_up_record,
      body: _asyncLoader,
      globalKey: _scaffoldState,
    );
    /*return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(MyString.txt_top_up_record, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: _asyncLoader,
      *//*body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: modalProgressIndicator(),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
              child: Row(
                children: <Widget>[
                  Container(margin: EdgeInsets.only(right: 10.0),
                      child: Image.asset('images/online_tax_no_circle.png', width: 30.0, height: 30.0,)),
                  Text(MyString.txt_online_tax, style: TextStyle(fontSize: FontSize.textSizeSmall),)
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 480.0,
              child: Card(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                color: MyColor.colorPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //profile photo
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: CircleAvatar(
                          backgroundImage: _userModel.photoUrl==null?AssetImage('images/profile_placeholder.png'):
                          NetworkImage(BaseUrl.USER_PHOTO_URL+_userModel.photoUrl),
                          backgroundColor: MyColor.colorGrey,
                          radius: 60.0,
                        ),
                      ),
                      //text name
                      Container(
                        alignment: Alignment.center,
                          child: Text(_userModel.name, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),)),
                      //text prepaid code
                      Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(MyString.txt_prepaid_code, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),)),
                      //text field prepaid code
                      Container(
                        margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.white, style: BorderStyle.solid, width: 0.80),
                            color: Colors.white
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Image.asset('images/top_up_card.png', scale: 2.5,),
                          ),
                          keyboardType: TextInputType.number,
                          controller: _prepaidCodeController,
                          style: TextStyle(fontSize: FontSize.textSizeNormal),
                        ),
                      ),
                      //text pin code
                      Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(MyString.txt_pin_code, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),)),
                      //pin code text field
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        alignment: Alignment.center,
                        child: PinCodeTextField(
                          pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.scalingTransition,
                          pinTextAnimatedSwitcherDuration: Duration(milliseconds: 100),
                          pinBoxHeight: 40,
                          pinBoxWidth: 40,
                          defaultBorderColor: Colors.white,
                          hideCharacter: true,
                          maskCharacter: '*',
                          hasTextBorderColor: Colors.white,
                          hasError: _hasError,
                          errorBorderColor: Colors.red,
                          controller: _pinCodeController,
                          pinTextStyle: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),
                          onDone: (str){
                            if(str == _userModel.pinCode.toString()){
                              print('pin correct');
                              setState(() {
                                _hasError = false;
                              });
                            }else{
                              setState(() {
                                _hasError = true;
                              });
                              _pinCodeController.clear();
                            }
                          },
                        ),
                      ),
                      //btn out
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 10.0),
                                height: 45.0,
                                child: RaisedButton(onPressed: ()async{
                                  Navigator.of(context).pop();
                                  }, child: Text(MyString.txt_top_up_cancel, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
                                  color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                              ),
                            ),
                            //btn top up
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10.0),
                                height: 45.0,
                                child: RaisedButton(onPressed: ()async{
                                  if(_prepaidCodeController.text.isNotEmpty && _pinCodeController.text.isNotEmpty){
                                    if(_hasError == false){
                                      await _checkCon();
                                      if(_isCon){
                                        _dialogConfirm();
                                      }else{
                                        _scaffoldState.currentState.showSnackBar(SnackBar(
                                          content: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(margin: EdgeInsets.only(right: 20.0),child: Image.asset('images/no_connection.png', width: 30.0, height: 30.0,)),
                                              Text(MyString.txt_check_internet, style: TextStyle(fontSize: FontSize.textSizeNormal),),
                                            ],
                                          ),duration: Duration(seconds: 2),backgroundColor: Colors.red,));
                                      }
                                    }else{
                                      WarningSnackBar(_scaffoldState, MyString.txt_wrong_pin_code);
                                    }
                                  }else if(_prepaidCodeController.text.isEmpty){
                                    WarningSnackBar(_scaffoldState, MyString.txt_need_prepaid_code);
                                  }else if(_pinCodeController.text.isEmpty){
                                    WarningSnackBar(_scaffoldState, MyString.txt_need_pin_code);
                                  }

                                  }, child: Text(MyString.txt_top_up, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),),
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
      ),*//*
    );*/
  }
}
