import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'model/SaveNewsFeedModel.dart';
import 'Database/SaveNewsFeedDb.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SaveNewsFeedDetailScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SaveNewsFeedScreen extends StatefulWidget {
  @override
  _SaveNewsFeedScreenState createState() => _SaveNewsFeedScreenState();
}

class _SaveNewsFeedScreenState extends State<SaveNewsFeedScreen> {
  SaveNewsFeedDb _saveNewsFeedDb = SaveNewsFeedDb();
  List _saveNewsFeedList = new List();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();


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
        builder: (ctxt){
          return Dialog(
            child: Container(
              margin: EdgeInsets.all(10.0),
              height: 160.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(margin: EdgeInsets.only(bottom: 10.0),child: Image.asset('images/confirm_icon.png', width: 60.0, height: 60.0,)),
                  Text(MyString.txt_are_u_sure, style: TextStyle(fontSize: FontSize.textSizeSmall),),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(onPressed: (){
                            _deleteNewsFeed(id);
                            _saveNewsFeedList.removeAt(i);
                            setState(() {
                            });
                            Navigator.of(context).pop();
                        },child: Text(MyString.txt_delete,
                          style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),color: MyColor.colorPrimary,),
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
                i==0?Container(
                  margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
                  child: Row(
                    children: <Widget>[
                      Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/file_save.png', width: 30.0, height: 30.0,)),
                      Text(MyString.title_save_nf, style: TextStyle(fontSize: FontSize.textSizeSmall),)
                    ],
                  ),
                ):Container(width: 0.0, height: 0.0,),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SaveNewsFeedDetailScreen(model)));
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
                                  Text(showDateTime(model.accessTime), style: TextStyle(fontSize: FontSize.textSizeSmall),)
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
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.title_save_nf, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: Container(
        child: _saveNewsFeedList.isNotEmpty?_listView():
        Container(
          margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/file_save.png', width: 30.0, height: 30.0,)),
                  Text(MyString.title_save_nf, style: TextStyle(fontSize: FontSize.textSizeSmall),)
                ],
              ),
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
