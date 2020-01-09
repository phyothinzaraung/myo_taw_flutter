import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'helper/ServiceHelper.dart';
import 'helper/MyoTawConstant.dart';
import 'package:dio/dio.dart';
import 'package:async_loader/async_loader.dart';
import 'package:connectivity/connectivity.dart';
import 'helper/SharePreferencesHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'model/DaoViewModel.dart';
import 'DaoDetailScreen.dart';
import 'DepartmentListScreen.dart';
import 'myWidget/EmptyViewWidget.dart';

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
    try{
      _response = await ServiceHelper().getDao(page, pageSize, _sharepreferenceshelper.getRegionCode(), display);
      var daoViewModelList = _response.data['Results'];
      if(daoViewModelList != null && daoViewModelList.length > 0){
        for(var i in daoViewModelList){
          setState(() {
            _daoViewModelList.add(DaoViewModel.fromJson(i));
          });
        }
      }
    }catch(e){
      print(e);
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
                      margin: EdgeInsets.only(top: 7, bottom: 7),
                      child: Column(
                        children: <Widget>[
                          //image dao
                          Flexible(flex: 2,child: Image.network(BaseUrl.DAO_PHOTO_URL+_daoViewModelList[index].daoModel.icon,)),
                          //text title
                          Flexible(flex: 1,child: Text(_daoViewModelList[index].daoModel.title,textAlign: TextAlign.center,
                            style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))],),),
                  );
                },childCount: _daoViewModelList.length),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    crossAxisSpacing: 10.0,))
          ],
        )
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
    _daoViewModelList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getAllDao(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: _daoViewModelList.isNotEmpty?_listView() : emptyView(asyncLoaderState,MyString.txt_no_data),
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
