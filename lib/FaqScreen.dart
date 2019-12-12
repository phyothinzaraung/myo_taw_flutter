import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/EmptyViewWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'package:dio/dio.dart';
import 'helper/ServiceHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/FaqModel.dart';
import 'package:async_loader/async_loader.dart';
import 'package:connectivity/connectivity.dart';
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
  bool _isCon, _isLoading = false;
  List faqModelList = new List();
  String _dropDownCategory = 'အားလုံး';
  List<String> _categoryList = new List<String>();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryList = [_dropDownCategory];
  }

  _getAllFaq(String category)async{
    await _sharepreferenceshelper.initSharePref();
    _regionCode = await _sharepreferenceshelper.getRegionCode();
    _response = await ServiceHelper().getAllFaq(_regionCode, page, pageSize, category);
    faqModelList = _response.data['FAQwithPaging']['Results'];
    //faqModelList = [];
    if(faqModelList != null && faqModelList.length > 0){
      var categoryList = _response.data['CategoryList'];
      for(var i in categoryList){
        if(i != null){
          setState(() {
            //_categoryList.add(model);
            _categoryList.add(i);
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
    faqModelList = _response.data['FAQwithPaging']['Results'];
    if(_response.data != null){

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
                      //image question
                      Container(margin: EdgeInsets.only(right: 15.0),child: Image.asset('images/question_mark.png', width: 30.0, height: 30.0,)),
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10.0),
                                //text question
                                child: Text(_faqList[i].question, style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                            //text answer
                            _faqList[i].isVisible?Text(_faqList[i].answer, style: TextStyle(fontSize: FontSize.textSizeSmall),):
                                Container(width: 0.0,height: 0.0,)
                      ],)),
                      //image arrow
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

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
    print('isCon : ${_isCon}');
  }

  Widget _renderLoad(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          headerTitleWidget(MyString.title_faq),
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
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => Container(
          child: Column(
            children: <Widget>[
              headerTitleWidget(MyString.title_faq),
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
                          items: _categoryList.map<DropdownMenuItem<String>>((String str){
                            return DropdownMenuItem<String>(
                              value: str,
                              child: Text(str),
                            );
                          }).toList(),
                        ),
                      ),
                    ),)),
              Expanded(child: !_isLoading?
              _faqList.isNotEmpty? _listView() : emptyView(asyncLoaderState, MyString.txt_no_data) : Container())
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
