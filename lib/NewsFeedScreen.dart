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

    return new  Container(
      margin: EdgeInsets.only(bottom: 10.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          /*newsFeedPhoto!=null?Image.network(baseUrl.NEWS_FEED_CONTENT_URL+newsFeedPhoto,
            fit: BoxFit.cover, height: 150.0,width: double.maxFinite,) :
              Image.asset('images/placeholder_newsfeed.jpg'),*/
          GestureDetector(
            onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NewsFeedDetailScreen(newsFeedModel)));
            },
            child: Container(
              child: Column(
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
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 25.0, right: 25.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            children: <Widget>[
                              Image.asset('images/calendar.png',width: 18.0,height: 15.0,),
                              Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10.0),
                                      child: Text(date, style: TextStyle(color: myColor.colorTextGrey, fontSize: fontSize.textSizeSmall),)))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(child: Text(title!=null?title:'---',style: TextStyle(fontSize: fontSize.textSizeLarge)))
                            ],),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width: 70,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20.0),
                                    topRight: const Radius.circular(20.0),
                                    bottomRight: const Radius.circular(20.0),
                                    bottomLeft: const Radius.circular(20.0),
                                  ),
                                  color: myColor.colorPrimary
                              ),
                              child: Text('${like} Like', style: TextStyle(color: Colors.white, fontSize: fontSize.textSizeSmall),),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 0.0,
            color: myColor.colorGreyDark,
          ),
          Card(
            margin: EdgeInsets.all(0.0),
            elevation: 5.0,
            child: Container(
              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(onPressed: (){

                  },
                      child: Row(
                        children: <Widget>[
                          Container(margin: EdgeInsets.only(right: 10.0),
                              child: Image.asset(isLike?'images/like_fill.png':'images/like.png', width: 23.0, height: 23.0,)),
                          Text(myString.txt_like, style: TextStyle(color: myColor.colorPrimary),)
                        ],
                      )),
                  FlatButton(onPressed: (){

                  },
                      child: Row(
                        children: <Widget>[
                          Container(margin: EdgeInsets.only(right: 10.0),
                              child: Image.asset('images/save.png', width: 23.0, height: 23.0,)),
                          Text(myString.txt_save, style: TextStyle(color: myColor.colorPrimary),)
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("No Internet Connection"),
          new FlatButton(
              color: Colors.red,
              child: new Text("Retry", style: TextStyle(color: Colors.white),),
              onPressed: () => asyncLoaderState.currentState.reloadState())
        ],
      ),
    );
  }

  Widget _renderLoad(){
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: myColor.colorGrey,
        title: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Myo taw', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeLarge),),
                  Text('တောင်ကြီး', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeNormal),)
                ],
              ),
            ),
            CircleAvatar(child: Image.asset('images/profile_placeholder.png'), backgroundColor: myColor.colorPrimary, radius: 20.0,)
          ],
        ),
      ),
      body: Center(child: CircularProgressIndicator(),)
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
          SliverAppBar(
            titleSpacing: 20.0,
            title: Row(
              children: <Widget>[
              Expanded(child: Text('သတင်းများ(တောင်ကြီး)', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeLarge),)),
              //Text('တောင်ကြီး', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeLarge),),
                CircleAvatar(child: Image.asset('images/profile_placeholder.png'), backgroundColor: myColor.colorPrimary, radius: 20.0,)
              ],
            ),
            backgroundColor: myColor.colorGrey,
          ),
          SliverList(delegate: SliverChildBuilderDelegate((context, i) => _newsFeedList(i), childCount: _newsFeedReactModel.length))
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
