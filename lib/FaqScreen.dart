import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/EmptyViewWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/ServiceHelper.dart';
import 'helper/SharePreferencesHelper.dart';
import 'model/FaqModel.dart';
import 'package:async_loader/async_loader.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'myWidget/CustomProgressIndicator.dart';
import 'myWidget/DropDownWidget.dart';
import 'myWidget/IosPickerWidget.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  var _response;
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();
  String _regionCode, _userUniqueKey, _category = '';
  int page = 1;
  int pageSize = 100;
  List<FaqModel> _faqList = new List<FaqModel>();
  bool _isLoading = false;
  List faqModelList = new List();
  String _dropDownCategory = MyString.txt_faq_category_all;
  List<String> _categoryList = new List<String>();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();

  List<Widget> _categoryPickerWidgetList = List();
  int _categoryPickerIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoryList = [_dropDownCategory];
  }

  _initCategroyPickerWidgetList(){
    for(var i in _categoryList){
      _categoryPickerWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _getAllFaq(String category)async{
    await _sharepreferenceshelper.initSharePref();
    _regionCode = _sharepreferenceshelper.getRegionCode();
    _userUniqueKey = _sharepreferenceshelper.getUserUniqueKey();
    try{
      _response = await ServiceHelper().getAllFaq(_regionCode, page, pageSize, category);
      faqModelList = _response.data['FAQwithPaging']['Results'];
      if(faqModelList != null && faqModelList.length > 0){
        var categoryList = _response.data['CategoryList'];
        for(var i in categoryList){
          if(i != null){
            _categoryList.add(i);
          }
        }

        _initCategroyPickerWidgetList();
        if(_response.data != null){
          faqModelList = _response.data['FAQwithPaging']['Results'];
          for(var i in faqModelList){
            setState(() {
              _faqList.add(FaqModel.fromJson(i));
            });
          }
        }
      }
    }catch(e){
      print(e);
    }
  }

  _getAllFaqByCategory(String category)async{
    await _sharepreferenceshelper.initSharePref();
    _regionCode = _sharepreferenceshelper.getRegionCode();
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
                FireBaseAnalyticsHelper.TrackClickEvent(ScreenName.FAQ_SCREEN, ClickEvent.FAQ_ANSWER_CLICK_EVENT, _userUniqueKey);
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
                                Container()
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


  Widget _renderLoad(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          headerTitleWidget(MyString.title_faq, 'questions_mark_no_circle'),
          Container(margin: EdgeInsets.only(top: 10.0),child: CircularProgressIndicator())
        ],
      )
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
              headerTitleWidget(MyString.title_faq, 'questions_mark_no_circle'),
              Card(
                margin: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    height: 50.0,width: double.maxFinite,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                              color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.80
                          )
                      ),
                      child: Platform.isAndroid?

                      DropDownWidget(
                        value: _dropDownCategory,
                        onChange: (value){
                          setState(() {
                            _dropDownCategory = value;
                            _isLoading = true;
                          });
                          if(_dropDownCategory == MyString.txt_faq_category_all){
                            _getFaqByCategory('');
                          }else{
                            _getFaqByCategory(_dropDownCategory);
                          }
                          FireBaseAnalyticsHelper.TrackClickEvent(ScreenName.FAQ_SCREEN, ClickEvent.FAQ_BY_CATEGORY_CLICK_EVENT, _userUniqueKey);
                        },
                        list: _categoryList,
                      ) :
                      IosPickerWidget(
                        onPress: (){
                          setState(() {
                            _dropDownCategory = _categoryList[_categoryPickerIndex];
                            _isLoading = true;
                          });
                          if(_dropDownCategory == MyString.txt_faq_category_all){
                            _getFaqByCategory('');
                          }else{
                            _getFaqByCategory(_dropDownCategory);
                          }
                          FireBaseAnalyticsHelper.TrackClickEvent(ScreenName.FAQ_SCREEN, ClickEvent.FAQ_BY_CATEGORY_CLICK_EVENT, _userUniqueKey);
                          Navigator.pop(context);
                        },
                        onSelectedItemChanged: (index){
                          _categoryPickerIndex = index;
                        },
                        fixedExtentScrollController: FixedExtentScrollController(initialItem: _categoryPickerIndex),
                        text: _dropDownCategory,
                        children: _categoryPickerWidgetList,
                      ),
                    ),)),
              Expanded(child: !_isLoading?
              _faqList.isNotEmpty? _listView() : emptyView(asyncLoaderState, MyString.txt_no_data) : Container())
            ],
          ),
        )
    );
    return CustomScaffoldWidget(
      title: Text(MyString.title_faq,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: ModalProgressHUD(inAsyncCall: _isLoading,progressIndicator: CustomProgressIndicatorWidget(),child: _asyncLoader),
    );
  }
}
