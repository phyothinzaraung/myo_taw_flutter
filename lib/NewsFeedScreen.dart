import 'package:flutter/material.dart';
import 'package:myotaw/helper/myoTawConstant.dart';
import 'package:async_loader/async_loader.dart';
import 'package:dio/dio.dart';
import 'helper/serviceHelper.dart';
import 'Model/NewsFeedReactModel.dart';
import 'package:myotaw/helper/myoTawConstant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'Model/NewsFeedModel.dart';
import 'NewsFeedDetailScreen.dart';

class newsFeedScreen extends StatefulWidget {
  @override
  _newsFeedScreenState createState() => _newsFeedScreenState();
}

class _newsFeedScreenState extends State<newsFeedScreen> with AutomaticKeepAliveClientMixin {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  Response response;
  List<NewsFeedReactModel> _newsFeedReactModel = new List<NewsFeedReactModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _getNewsFeed() async{
    response = await ServiceHelper().getNewsFeed(8, 1, 10, "0fc9d06a-a622-4288-975d-b5f414a9ad73");
    var result = response.data['Results'];
    for(var model in result){
      _newsFeedReactModel.add(NewsFeedReactModel.fromJson(model));
    }
  }

  bool _isLike(String reactType){
    if(reactType != null){
      return true;
    }else{
      return false;
    }
  }


  Widget _newsFeedList(int i){
    NewsFeedModel newsFeedModel = _newsFeedReactModel[i].newsFeedModel;
    String newsFeedPhoto = newsFeedModel.photoUrl;
    String title = newsFeedModel.title;
    String date = showDateTime(newsFeedModel.accesstime);
    String like = newsFeedModel.likeCount.toString();
    bool isLike = _isLike(_newsFeedReactModel[i].reactType);
    List photoList = newsFeedModel.photoList;
    print('photolink: ${photoList }');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsFeedDetailScreen(newsFeedModel)));
              },
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(child: Text(title!=null?title:'---',style: TextStyle(fontSize: fontSize.textSizeNormal), maxLines: 2, softWrap: true,))
                        ],),
                    ),
                    Container(
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: newsFeedPhoto!=null?baseUrl.NEWS_FEED_CONTENT_URL+newsFeedPhoto:'',
                            imageBuilder: (context, image){
                              return Container(
                                width: double.maxFinite,
                                height: 150.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: image,
                                      fit: BoxFit.cover),
                                ),);
                            },
                            errorWidget: (context, url, error)=> Image.asset('images/placeholder_newsfeed.jpg'),
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10.0)),
                                  color: Colors.black.withOpacity(0.6)
                              ),
                              child: Text(date, style: TextStyle(color: Colors.white),)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Container(margin: EdgeInsets.only(right: 5.0),
                      child: Image.asset(isLike?'images/like_fill.png':'images/like.png', width: 18.0,height: 18.0,)),
                  Text('${like} ${myString.txt_like}', style: TextStyle(color: myColor.colorPrimary, fontSize: fontSize.textSizeSmall),),
                  Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end,children: <Widget>[Image.asset('images/save.png', width: 18.0,height: 18.0,),],))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _listView(){
    return ListView.builder(
        itemCount: _newsFeedReactModel.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position){
          return _newsFeedList(position);
        }
    );
  }

  Widget getNoConnectionWidget(){
    return Container(
      margin: EdgeInsets.only(top: 45.0, bottom: 10.0, left: 20.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('တောင်ကြီး', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeLarge)),
                    Text('သတင်းများ', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeNormal),),
                  ],
                ),
              ),
              CircleAvatar(child: Image.asset('images/profile_placeholder.png'), backgroundColor: myColor.colorPrimary, radius: 30.0,)
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('No Internet Connection'),
                  FlatButton(onPressed: (){
                    asyncLoaderState.currentState.reloadState();
                    }
                    , child: Text('Retry', style: TextStyle(color: Colors.white),),color: myColor.colorPrimary,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderLoad(){
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 60.0, bottom: 10.0, left: 15.0, right: 15.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('တောင်ကြီး', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeLarge)),
                      Text('သတင်းများ', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeNormal),),
                    ],
                  ),
                ),
                CircleAvatar(child: Image.asset('images/profile_placeholder.png'), backgroundColor: myColor.colorPrimary, radius: 30.0,)
              ],
            ),
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await _getNewsFeed(),
      renderLoad: () => _renderLoad(),
      renderError: ([error]) => getNoConnectionWidget(),
      renderSuccess: ({data}) => CustomScrollView(
        slivers: <Widget>[
          /*SliverAppBar(
            titleSpacing: 20.0,
            title: Row(
              children: <Widget>[
              Expanded(child: Text('သတင်းများ(တောင်ကြီး)', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeLarge),)),
              //Text('တောင်ကြီး', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeLarge),),
                CircleAvatar(child: Image.asset('images/profile_placeholder.png'), backgroundColor: myColor.colorPrimary, radius: 20.0,)
              ],
            ),
            backgroundColor: myColor.colorGrey,
          ),*/
          SliverList(delegate: SliverChildBuilderDelegate((context, i) =>
              ListTile(
                title: i==0?Container(
                  margin: EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('တောင်ကြီး', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeLarge)),
                            Text('သတင်းများ', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeNormal),),
                          ],
                        ),
                      ),
                      CircleAvatar(child: Image.asset('images/profile_placeholder.png'), backgroundColor: myColor.colorPrimary, radius: 30.0,)
                    ],
                  ),
                )
                    :Container(width: 0.0,height: 0.0,),
                subtitle: _newsFeedList(i),
              ), childCount: _newsFeedReactModel.length))
        ],
      )
    );
    return Scaffold(
      body: _asyncLoader,
    );
    /*return Scaffold(
      *//*appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text('Myo taw', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeLarge),),
            Text('တောင်ကြီး', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeNormal),)
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),*//*
      body: _asyncLoader
    );*/
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
