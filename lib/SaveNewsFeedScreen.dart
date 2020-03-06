import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/PlatformHelper.dart';
import 'model/SaveNewsFeedModel.dart';
import 'Database/SaveNewsFeedDb.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'SaveNewsFeedDetailScreen.dart';

class SaveNewsFeedScreen extends StatefulWidget {
  @override
  _SaveNewsFeedScreenState createState() => _SaveNewsFeedScreenState();
}

class _SaveNewsFeedScreenState extends State<SaveNewsFeedScreen> {
  SaveNewsFeedDb _saveNewsFeedDb = SaveNewsFeedDb();
  List _saveNewsFeedList = new List();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  GlobalKey<SliverAnimatedListState> _globalKey = GlobalKey();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSaveNewsFeed();
  }

  _getSaveNewsFeed()async{
    await _saveNewsFeedDb.openSaveNfDb();
    var list = await _saveNewsFeedDb.getSaveNewsFeed();
    for(var i in list){
      setState(() {
        _saveNewsFeedList.add(i);
      });
    }
  }

  _deleteNewsFeed(String id)async{
    await _saveNewsFeedDb.openSaveNfDb();
    await _saveNewsFeedDb.deleteSavedNewsFeedById(id);
    _saveNewsFeedDb.closeSaveNfDb();
  }

  _saveNewsFeedWidgetList(SaveNewsFeedModel model, animation, [int i]){
    return GestureDetector(
      onTap: (){

        NavigatorHelper.MyNavigatorPush(context, SaveNewsFeedDetailScreen(model), ScreenName.SAVED_NEWS_FEED_DETAIL_SCREEN);
      },
      child: ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Interval(0.2, 1)),
        child: FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Interval(0.2, 1)),
          child: Card(
            margin: EdgeInsets.only(bottom: 1.0),
            elevation: 0.5,
            child: Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  model.contentType==MyString.NEWS_FEED_CONTENT_TYPE_PHOTO?
                  Hero(
                    tag: model.id,
                    child: ClipRRect(
                      child: model.photoUrl!=null?
                      Image.network(BaseUrl.NEWS_FEED_CONTENT_URL+model.photoUrl, width: 75.0, height: 70.0, fit: BoxFit.cover,):
                      Image.asset('images/placeholder_newsfeed.jpg', width: 75.0, height: 70.0, fit: BoxFit.cover,),
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ):
                  ClipRRect(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        model.thumbNail != null?Image.network(model.thumbNail,width: 75.0, height: 70.0, fit: BoxFit.cover,):
                        Image.asset('images/placeholder_newsfeed.jpg', width: 75.0, height: 70.0, fit: BoxFit.cover,),
                        Container(
                          width: 75.0,
                          height: 70.0,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        Image.asset('images/video_play.png', width: 25.0, height: 25.0,)

                      ],
                    ),borderRadius: BorderRadius.circular(7.0),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(margin: EdgeInsets.only(bottom: 5.0),child: Text(model.title,style: TextStyle(fontSize: FontSize.textSizeSmall),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                          Text(ShowDateTimeHelper.showDateTimeDifference(model.accessTime), style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(PlatformHelper.isAndroid()?Icons.delete :CupertinoIcons.delete_solid, color: Colors.red,),
                      onPressed: (){
                        CustomDialogWidget().customConfirmDialog(
                            context: context,
                            content: MyString.txt_are_u_sure,
                            img: PlatformHelper.isAndroid()? 'bin.png' : 'iosbin.png',
                            textNo: MyString.txt_delete_cancel,
                            textYes: MyString.txt_delete,
                            onPress: ()async{
                              _deleteNewsFeed(model.id);
                              /*setState(() {
                                _saveNewsFeedList.removeAt(i);
                              });*/
                              Navigator.of(context).pop();
                              await _sharepreferenceshelper.initSharePref();
                              FireBaseAnalyticsHelper.TrackClickEvent(ScreenName.SAVED_NEWS_FEED_SCREEN, ClickEvent.DELETE_SAVED_NEWS_FEED_CLICK_EVENT,
                                  _sharepreferenceshelper.getUserUniqueKey());
                              Future.delayed(Duration(milliseconds: 200),(){
                                setState(() {
                                  var model = _saveNewsFeedList.removeAt(i);
                                  _globalKey.currentState.removeItem(i, (context, animation){
                                    return _saveNewsFeedWidgetList(model, animation);
                                  },duration: Duration(milliseconds: 500));
                                });
                              });
                            }
                        );
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  /*Widget _listView(){
    return AnimatedList(
        key: _globalKey,
        initialItemCount: _saveNewsFeedList.length,
        itemBuilder: (context, i, animation){
          SaveNewsFeedModel model = _saveNewsFeedList[i];
          return Container(
            child: Column(
              children: <Widget>[
                i==0?headerTitleWidget(MyString.title_save_nf, 'save_file_no_circle') : Container(width: 0.0, height: 0.0,),
                _saveNewsFeedWidgetList(model, animation, i)
              ],
            ),
          );
        });
  }*/


  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(MyString.title_save_nf,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: Container(
          child: _saveNewsFeedList.isNotEmpty?
          CustomScrollView(
            slivers: <Widget>[
              SliverList(delegate: SliverChildBuilderDelegate((context, i){
                return headerTitleWidget(MyString.title_save_nf, 'save_file_no_circle');
              }, childCount: 1)),
              SliverAnimatedList(itemBuilder: (context, i, animation){
                return _saveNewsFeedWidgetList(_saveNewsFeedList[i], animation, i);
              }, initialItemCount: _saveNewsFeedList.length,key: _globalKey,)
            ],
          ):
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                headerTitleWidget(MyString.title_save_nf, 'save_file_no_circle'),
                Expanded(
                  child: Center(
                    child: Image.asset('images/empty_box.png', width: 70.0, height: 70.0,),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
