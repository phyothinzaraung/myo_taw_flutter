import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/FaqModel.dart';
import 'package:async_loader/async_loader.dart';
import 'package:connectivity/connectivity.dart';
import 'model/FaqCategoryModel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
  List<FaqCategoryModel> _categoryList = new List<FaqCategoryModel>();
  bool _isCon, _isLoading = false;
  var faqModelList;
  String _dropDownCategory = 'အားလုံး';
  List<String> _categoList = new List<String>();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoList = [_dropDownCategory];
  }

  _getAllFaq(String category)async{
    await _sharepreferenceshelper.initSharePref();
    _regionCode = await _sharepreferenceshelper.getRegionCode();
    _response = await ServiceHelper().getAllFaq(_regionCode, page, pageSize, category);
    if(_response.data != null){
      var categoryList = _response.data['CategoryList'];
      faqModelList = _response.data['FAQwithPaging']['Results'];
      /*FaqCategoryModel model = FaqCategoryModel();
      model.category = 'all';
      setState(() {
        _categoryList.add(model);
      });*/
      for(var i in categoryList){
        if(i != null){
         /* FaqCategoryModel model = FaqCategoryModel();
          model.category = i;*/
          setState(() {
            //_categoryList.add(model);
            _categoList.add(i);
          });
        }
      }
      if(_response.data != null){
        faqModelList = _response.data['FAQwithPaging']['Results'];
        for(var i in faqModelList){
          setState(() {
            _faqList.add(FaqModel.fromJson(i));
          });
        }
      }
    }
  }

  _getAllFaqByCategory(String category)async{
    await _sharepreferenceshelper.initSharePref();
    _regionCode = await _sharepreferenceshelper.getRegionCode();
    _response = await ServiceHelper().getAllFaq(_regionCode, page, pageSize, category);
    if(_response.data != null){
      faqModelList = _response.data['FAQwithPaging']['Results'];
      for(var i in faqModelList){
        setState(() {
          _faqList.add(FaqModel.fromJson(i));
          _isLoading = false;
        });
      }
    }
  }

  _getFaqByCategory(String category){
    _faqList.clear();
    _getAllFaqByCategory(category);
  }

  /*_categoryListView(){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categoryList.length,
        itemBuilder: (context, i){
          return GestureDetector(
            onTap: (){
              *//*setState(() {
                _categoryList[i].isSelect = true;
              });*//*

              if(_categoryList[i].category == 'all'){
                _getFaqByCategory('');
              }
              _getFaqByCategory(_categoryList[i].category);

            },
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Row(
                children: <Widget>[
                  Container(margin: EdgeInsets.only(right: 5.0),
                      child: Text(_categoryList[i].category, style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                  _categoryList[i].isSelect?Image.asset('images/tick.png', width: 15.0, height: 15.0,):
                      Container(width: 0.0, height: 0.0,)
                ],
              ),
            ),
          );
        });
  }*/

  _listView(){
    return ListView.builder(
        itemCount: _faqList.length,
        itemBuilder: (context, i){
          return GestureDetector(
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
                      Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: RotatedBox(quarterTurns: _faqList[i].isVisible?6:0,
                            child: Image.asset('images/down_arrow.png', width: 17.0, height: 17.0,)),
                      )
                    ],
                  ),
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
          Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/questions_mark_no_circle.png', width: 30.0, height: 30.0,)),
          Text(MyString.title_faq, style: TextStyle(fontSize: FontSize.textSizeSmall),)
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

  /*Future<Null> _handleRefresh() async {
    await _checkCon();
    if(_isCon){
      setState(() {
        _faqList.clear();
        _categoryList.clear();
      });
      _category = '';
      await _getAllFaq(_category);
    }else{
      Fluttertoast.showToast(msg: 'Check Connection', backgroundColor: Colors.black.withOpacity(0.7), fontSize: FontSize.textSizeSmall);
    }
    return null;
  }*/

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

  Widget modalProgressIndicator(){
    return Center(
      child: Card(
        child: Container(
          width: 220.0,
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(margin: EdgeInsets.only(right: 30.0),
                  child: Text('Loading......',style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.black))),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColor.colorPrimary))
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getAllFaq(_category),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => getNoConnectionWidget(),
        renderSuccess: ({data}) => Container(
          child: Column(
            children: <Widget>[
              _headerFaq(),
              Card(
                margin: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    height: 50.0,width: double.maxFinite,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                              color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.80
                          )
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          style: new TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.black87),
                          isExpanded: true,
                          iconEnabledColor: MyColor.colorPrimary,
                          value: _dropDownCategory,
                          onChanged: (String value){
                            setState(() {
                              _dropDownCategory = value;
                              _isLoading = true;
                            });
                            if(_dropDownCategory == 'အားလုံး'){
                              _getFaqByCategory('');
                            }else{
                              _getFaqByCategory(_dropDownCategory);
                            }

                          },
                          items: _categoList.map<DropdownMenuItem<String>>((String str){
                            return DropdownMenuItem<String>(
                              value: str,
                              child: Text(str),
                            );
                          }).toList(),
                        ),
                      ),
                    ),)),
              //Divider(color: MyColor.colorPrimary,height: 1.0,),
              Expanded(child: _listView())
            ],
          ),
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.title_faq, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ModalProgressHUD(inAsyncCall: _isLoading,progressIndicator: modalProgressIndicator(),child: _asyncLoader)
    );
  }
}
