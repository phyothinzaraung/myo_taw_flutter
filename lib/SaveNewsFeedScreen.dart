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
                          ClipRRect(
                            child: Hero(
                              tag: model.photoUrl,
                              child: model.photoUrl!=null?Image.network(BaseUrl.NEWS_FEED_CONTENT_URL+model.photoUrl, width: 75.0, height: 70.0, fit: BoxFit.cover,):
                              Image.asset('images/placeholder_newsfeed.jpg', width: 75.0, height: 70.0, fit: BoxFit.cover,),
                            ),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(margin: EdgeInsets.only(bottom: 5.0),child: Text(model.title,style: TextStyle(fontSize: FontSize.textSizeSmall),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                  Text(showDateTime(model.accessTime))
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(onTap: (){
                            _deleteNewsFeed(model.id);
                            _saveNewsFeedList.clear();
                            _getSaveNewsFeed();
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
        child: _listView()
      ),
    );
  }
}
