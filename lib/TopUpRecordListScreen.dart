import 'package:async_loader/async_loader.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/NumConvertHelper.dart';
import 'package:myotaw/helper/NumberFormatterHelper.dart';
import 'package:myotaw/model/TopUpLogModel.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'package:myotaw/myWidget/NativePullRefresh.dart';
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




  Widget _renderLoad(){
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[NativeProgressIndicator()],)
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
          child: NativePullRefresh(
            onRefresh: _handleRefresh,
            child: _topUpLogModelList.isNotEmpty?_listView() : emptyView(asyncLoaderState,MyString.txt_no_top_up_record),
          ),
        )
    );
    return CustomScaffoldWidget(
      title: Text(MyString.txt_top_up_record,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _asyncLoader,
      globalKey: _scaffoldState,
    );
  }
}
