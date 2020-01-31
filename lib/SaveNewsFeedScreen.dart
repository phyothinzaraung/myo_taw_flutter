import 'package:flutter/material.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/helper/NavigatorHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/HeaderTitleWidget.dart';
import 'helper/MyoTawConstant.dart';
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
    await _saveNewsFeedDb.closeSaveNfDb();
  }

  _dialogDelete(String id, int i){
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            child: Container(
              margin: EdgeInsets.all(10.0),
              height: 160.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(margin: EdgeInsets.only(bottom: 10.0),child: Image.asset('images/confirm_icon.png', width: 60.0, height: 60.0,)),
                  Text(MyString.txt_are_u_sure, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(onPressed: ()async{
                            _deleteNewsFeed(id);
                            setState(() {
                              _saveNewsFeedList.removeAt(i);
                            });
                            Navigator.of(context).pop();
                            await _sharepreferenceshelper.initSharePref();
                            FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.SAVED_NEWS_FEED_SCREEN, ClickEvent.DELETE_SAVED_NEWS_FEED_CLICK_EVENT,
                                _sharepreferenceshelper.getUserUniqueKey());
                        },child: Text(MyString.txt_delete,
                          style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                          color: MyColor.colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))
                          ),
                        ),
                        RaisedButton(onPressed: (){
                            Navigator.of(context).pop();
                        },child: Text(MyString.txt_delete_cancel, style: TextStyle(fontSize: FontSize.textSizeSmall),),color: MyColor.colorGrey,)
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _listView(){
    return ListView.builder(
        itemCount: _saveNewsFeedList.length,
        itemBuilder: (context, i){
          SaveNewsFeedModel model = _saveNewsFeedList[i];
          return Container(
            child: Column(
              children: <Widget>[
                i==0?headerTitleWidget(MyString.title_save_nf, 'save_file_no_circle') : Container(width: 0.0, height: 0.0,),
                GestureDetector(
                  onTap: (){
                    /*Navigator.of(context).push(MaterialPageRoute(builder: (context) => SaveNewsFeedDetailScreen(model),
                      settings: RouteSettings(name: ScreenName.SAVED_NEWS_FEED_DETAIL_SCREEN)
                    ));*/
                    NavigatorHelper().MyNavigatorPush(context, SaveNewsFeedDetailScreen(model), ScreenName.SAVED_NEWS_FEED_DETAIL_SCREEN);
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: 1.0),
                    elevation: 0.5,
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                      child: Row(
                        children: <Widget>[
                          model.contentType==MyString.NEWS_FEED_CONTENT_TYPE_PHOTO?ClipRRect(
                            child: model.photoUrl!=null?
                            Image.network(BaseUrl.NEWS_FEED_CONTENT_URL+model.photoUrl, width: 75.0, height: 70.0, fit: BoxFit.cover,):
                            Image.asset('images/placeholder_newsfeed.jpg', width: 75.0, height: 70.0, fit: BoxFit.cover,),
                            borderRadius: BorderRadius.circular(7.0),
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
                                  Text(ShowDateTimeHelper().showDateTimeDifference(model.accessTime), style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(onTap: (){
                            _dialogDelete(model.id, i);
                          },child: Icon(Icons.delete, color: MyColor.colorPrimary,))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: MyString.title_save_nf,
      body: Container(
          child: _saveNewsFeedList.isNotEmpty?_listView():
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
    /*return Scaffold(
      appBar: AppBar(
        title: Text(MyString.title_save_nf, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ,
    );*/
  }
}
