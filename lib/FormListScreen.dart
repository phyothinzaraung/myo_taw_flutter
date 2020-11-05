import 'package:flutter/material.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/model/FormModel.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/helper/MyoTawCitySetUpHelper.dart';
import 'package:async_loader/async_loader.dart';
import 'package:myotaw/myWidget/NoConnectionWidget.dart';
import 'package:myotaw/myWidget/NativePullRefresh.dart';
import 'package:myotaw/myWidget/EmptyViewWidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:myotaw/myWidget/CustomProgressIndicator.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'Database/UserDb.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'FormWebViewScreen.dart';
import 'myWidget/CustomScaffoldWidget.dart';

class FormListScreen extends StatefulWidget{
  FormListScreen();
  @override
  _FormListScreenState createState() => _FormListScreenState();

}

class _FormListScreenState extends State<FormListScreen> with AutomaticKeepAliveClientMixin<FormListScreen>{

  List<FormModel> _formList = new List<FormModel>();
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  bool _isLoading = false;
  Sharepreferenceshelper _sharepreferenceshelper = new Sharepreferenceshelper();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _getAllForm() async {
    await _sharepreferenceshelper.initSharePref();
    var response = await ServiceHelper().getFormList();
    if(response.data != null || response.data.length > 0){
      for(var i in response.data) {
        _formList.add(FormModel.fromJson(i));
      }
    }
  }

  _listView(){
    return ListView.builder(
        itemCount: _formList.length,
        itemBuilder: (BuildContext context, int i){
          return _formListWidget(i);
        }
    );
  }

  Widget _formListWidget(int i){
    FormModel model = _formList[i];
    String _formName = model.FormName;
    String _formURL = model.FormUrl;
    String _uniquekey = _sharepreferenceshelper.getUserUniqueKey();

    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(top: i == _formList.length? 0 : 1, left: 0, right: 0, bottom: 0),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        leading: Image.asset("images/form.png", width: 30.0, height: 30.0,),
        title: Text(_formName,
          style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorBlackSemiTransparent), maxLines: 2,
          overflow: TextOverflow.ellipsis,),
        onTap: (){
          NavigatorHelper.myNavigatorPush(context, FormWebViewScreen(_formURL, _uniquekey, _formName), ScreenName.FORM_SCREEN);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => _getAllForm(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => NativePullRefresh(
          onRefresh: _handleRefresh,
          child: _formList.isNotEmpty?_listView() : emptyView(asyncLoaderState,MyString.txt_no_data),
        )
    );
    return CustomScaffoldWidget(
        title: Text(MyString.txt_form,maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),
        ),
        body: ModalProgressHUD(
            inAsyncCall: _isLoading,
            progressIndicator: CustomProgressIndicatorWidget(),
            child: _asyncLoader
        ),);
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
    _formList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}