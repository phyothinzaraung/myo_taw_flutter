import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/FaqModel.dart';
import 'package:async_loader/async_loader.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'model/FaqCategoryModel.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  Response _response;
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  String _regionCode, _category = '';
  int page = 1;
  int pageSize = 100;
  List<FaqModel> _faqList = new List<FaqModel>();
  List<dynamic> _categoryList = new List<dynamic>();
  List<FaqCategoryModel> _list = new List<FaqCategoryModel>();
  bool _isCon, _isVisible;
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isVisible = false;
  }

  _getAllFaq(int p, String category)async{
    await _sharepreferenceshelper.initSharePref();
    _regionCode = await _sharepreferenceshelper.getRegionCode();
    _response = await ServiceHelper().getAllFaq(_regionCode, p, pageSize, category);
    if(_response.data != null){
      var categoryList = _response.data['CategoryList'];
      var faqModelList = _response.data['FAQwithPaging']['Results'];
      for(var i in categoryList){
        if(i != null){
          _categoryList.add(i);
        }
      }
      for(var i in faqModelList){
        setState(() {
          _faqList.add(FaqModel.fromJson(i));
        });
      }
    }
  }

  _getFaqByCategory(String category){
    _faqList.clear();
    _categoryList.clear();
    _getAllFaq(page, category);
  }

  _categoryListView(){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categoryList.length,
        itemBuilder: (context, i){
          return GestureDetector(
            onTap: (){
              _getFaqByCategory(_categoryList[i].toString());
            },
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Text(_categoryList[i].toString(), style: TextStyle(fontSize: FontSize.textSizeSmall),),
            ),
          );
        });
  }

  _listView(){
    return ListView.builder(
        itemCount: _faqList.length,
        itemBuilder: (context, i){
          return Container(
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
              margin: EdgeInsets.all(0.0),
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(margin: EdgeInsets.only(right: 15.0),child: Image.asset('images/question_mark.png', width: 30.0, height: 30.0,)),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(_faqList[i].question, style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                          _faqList[i].isVisible?Text(_faqList[i].answer, style: TextStyle(fontSize: FontSize.textSizeSmall),):
                              Container(width: 0.0,height: 0.0,)
                    ],)),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                         if(_faqList[i].isVisible){
                           _faqList[i].isVisible = false;
                         }else{
                           _faqList[i].isVisible = true;
                         }
                        });
                      },
                        child: Container(
                          margin: EdgeInsets.only(left: 5.0),
                          child: RotatedBox(quarterTurns: _faqList[i].isVisible?6:0,
                              child: Image.asset('images/down_arrow.png', width: 17.0, height: 17.0,)),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  _headerFaq(){
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
      child: Row(
        children: <Widget>[
          Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/profile.png', width: 30.0, height: 30.0,)),
          Text(MyString.title_profile, style: TextStyle(fontSize: FontSize.textSizeSmall),)
        ],
      ),
    );
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

  Widget getNoConnectionWidget(){
    return Container(
      child: Column(
        children: <Widget>[
          _headerFaq(),
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

  Future<Null> _handleRefresh() async {
    await _checkCon();
    if(_isCon){
      _categoryList.clear();
      _faqList.clear();
      _category = '';
      await _getAllFaq(page, _category);
    }else{
      Fluttertoast.showToast(msg: 'Check Connection', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeSmall);
    }
    return null;
  }

  Widget _renderLoad(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _headerFaq(),
          Container(margin: EdgeInsets.only(top: 10.0),child: CircularProgressIndicator())
        ],
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getAllFaq(page, _category),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => getNoConnectionWidget(),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: Column(
              children: <Widget>[
                _headerFaq(),
                Card(
                  margin: EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      height: 50.0,width: double.maxFinite,child: _categoryListView(),)),
                Divider(color: MyColor.colorPrimary,height: 1.0,),
                Expanded(child: _listView())
              ],
            )
          ),
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.title_faq, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: _asyncLoader
    );
  }
}
