import 'package:flutter/material.dart';
import 'helper/ServiceHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'package:dio/dio.dart';
import 'package:async_loader/async_loader.dart';
import 'package:connectivity/connectivity.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/DaoModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'model/DaoViewModel.dart';
import 'DaoDetailScreen.dart';
import 'DepartmentListScreen.dart';

class DaoScreen extends StatefulWidget {
  String str;
  DaoScreen(this.str);
  @override
  _DaoScreenState createState() => _DaoScreenState(this.str);
}

class _DaoScreenState extends State<DaoScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  bool _isCon;
  Response _response;
  int page = 1;
  int pageSize = 100;
  String display;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  List<DaoViewModel> _daoViewModelList = new List<DaoViewModel>();
  _DaoScreenState(this.display);

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

  _getAllDao()async{
    await _sharepreferenceshelper.initSharePref();
    _response = await ServiceHelper().getDao(page, pageSize, _sharepreferenceshelper.getRegionCode(), display);
    if(_response.data != null){
      var daoViewModelList = _response.data['Results'];
      for(var i in daoViewModelList){
        _daoViewModelList.add(DaoViewModel.fromJson(i));
        print('daoviewmodel :${_daoViewModelList}');
      }
    }
  }

  _listView(){
    return Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index){
                  return GestureDetector(
                    onTap: (){
                      if(_daoViewModelList[index].daoModel.title.contains('ဌာနများ')){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DepartmentListScreen(_daoViewModelList[index])));
                      }else{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DaoDetailScreen(_daoViewModelList[index])));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: <Widget>[
                          Flexible(flex: 4,child: Image.network(BaseUrl.DAO_PHOTO_URL+_daoViewModelList[index].daoModel.icon, width: 120,)),
                          Flexible(flex: 1,child: Text(_daoViewModelList[index].daoModel.title,textAlign: TextAlign.center,style: TextStyle(fontSize: FontSize.textSizeSmall),))],),),
                  );
                },childCount: _daoViewModelList.length),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    crossAxisSpacing: 30.0))
          ],
        )
    );
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
      _daoViewModelList.clear();
      await _getAllDao();
    }else{
      Fluttertoast.showToast(msg: 'Check Connection', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeSmall);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getAllDao(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => getNoConnectionWidget(),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: _listView()
          ),
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(display.isEmpty?MyString.txt_municipal:MyString.txt_tax, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: _asyncLoader,
    );
  }
}
