import 'package:async_loader/async_loader.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/EmptyViewWidget.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'package:myotaw/myWidget/NativePullRefresh.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'package:pie_chart/pie_chart.dart';
import 'helper/PieChartColorHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'helper/ServiceHelper.dart';
import 'model/TaxUseModel.dart';
import 'helper/TaxUseBudgetYearHelper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'myWidget/CustomProgressIndicator.dart';

class TaxUserScreen extends StatefulWidget {
  @override
  _TaxUserScreenState createState() => _TaxUserScreenState();
}

class _TaxUserScreenState extends State<TaxUserScreen> {
  Map<String, double> dataMap;
  bool _isLoading = false;
  var _response;
  List<TaxUserModel> _taxUserModelList = new List<TaxUserModel>();
  List<Widget> _legendList = new List<Widget>();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  int _year;
  Icon _greyArrow;
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataMap = new Map();
    _year = DateTime.now().year;
    _greyArrow = Icon(Icons.arrow_forward_ios, color: MyColor.colorGreyDark);
  }


  _getTaxUse(int year)async{
    await _sharepreferenceshelper.initSharePref();
    _response = await ServiceHelper().getTaxUser(_sharepreferenceshelper.getRegionCode(), TaxUseBudgetYearHelper.getBudgetYear(year));
    List list = _response.data;
    //List list = [];
    if(list != null && list.length > 0){
      for(var i in list){
        setState(() {
          _taxUserModelList.add(TaxUserModel.fromJson(i));
        });
        dataMap.putIfAbsent(TaxUserModel.fromJson(i).taxTitle, () => TaxUserModel.fromJson(i).amount);
        print(i);
      }
      for(int i=0; i<_taxUserModelList.length; i++){
        _legendList.add(Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 20.0,
                height: 20.0,
                color: PieChartColorHelper.defaultColorList[i],
              ),
              Container(margin: EdgeInsets.only(left: 10.0),
                child: Text(_taxUserModelList[i].taxTitle, style: TextStyle(fontSize: FontSize.textSizeSmall),),),
            ],
          ),
        ),);
      }
    }
  }

  _listView(){
    return Container(
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50.0),
            child: PieChart(
              dataMap: dataMap, //Required parameter
              animationDuration: Duration(milliseconds: 800),
              chartRadius: MediaQuery
                  .of(context)
                  .size
                  .width / 1.5,
              legendOptions: LegendOptions(
                showLegends: false
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValuesInPercentage: true,
                showChartValues: true,
                showChartValuesOutside: true,
                showChartValueBackground: true,
                chartValueStyle: TextStyle(color: Colors.white),
                chartValueBackgroundColor: Colors.blueGrey[900].withOpacity(0.9),
              ),

              colorList: PieChartColorHelper.defaultColorList,
            ),
          ),
          Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                  children: _legendList
              )
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
          Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[NativeProgressIndicator()],)
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    _taxUserModelList.clear();
    _legendList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  Widget _body(AsyncLoader asyncLoader){
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CustomProgressIndicatorWidget(),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 5.0, bottom: 5.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: MyColor.colorPrimary),
                    onPressed: (){
                      setState(() {
                        _isLoading = true;
                        _year--;
                        _taxUserModelList.clear();
                        _legendList.clear();
                        _greyArrow = Icon(Icons.arrow_forward_ios, color: MyColor.colorPrimary);
                        dataMap.clear();
                      });
                      //await _getTaxUse(_year);
                      asyncLoaderState.currentState.reloadState();
                      print('year : $_year');
                      setState(() {
                        _isLoading = false;
                      });
                    }
                ),
                Expanded(
                    child: Text(TaxUseBudgetYearHelper.getBudgetYear(_year),
                      textAlign: TextAlign.center, style: TextStyle(fontSize: FontSize.textSizeNormal),)),
                IconButton(
                    icon: _greyArrow,
                    onPressed: (){
                      if(_year != DateTime.now().year){
                        setState(() {
                          _isLoading = true;
                          _year++;
                          _taxUserModelList.clear();
                          _legendList.clear();
                          dataMap.clear();
                        });
                        //await _getTaxUse(_year);
                        asyncLoaderState.currentState.reloadState();
                        print('year : $_year');
                        setState(() {
                          _isLoading = false;
                        });
                      }
                      if(_year == DateTime.now().year){
                        setState(() {
                          _greyArrow = Icon(Icons.arrow_forward_ios, color: MyColor.colorGreyDark);
                        });
                      }
                    }
                )
              ],
            ),
          ),
          Expanded(child: asyncLoader)
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getTaxUse(_year),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => NativePullRefresh(
            onRefresh: _handleRefresh,
            child: _taxUserModelList.isNotEmpty? _listView() :
            !_isLoading?emptyView(asyncLoaderState, MyString.txt_no_data) : Container()
        )
    );
    return CustomScaffoldWidget(
      title: Text(MyString.txt_tax_use,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _body(_asyncLoader),
    );
  }
}
