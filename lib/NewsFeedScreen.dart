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
import 'helper/MyLoadMore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';

class newsFeedScreen extends StatefulWidget {
  @override
  _newsFeedScreenState createState() => _newsFeedScreenState();
}

class _newsFeedScreenState extends State<newsFeedScreen> with AutomaticKeepAliveClientMixin {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  Response response;
  List<NewsFeedReactModel> _newsFeedReactModel = new List<NewsFeedReactModel>();
  ScrollController _scrollController = new ScrollController();
  bool _isEnd , _isCon= false;
  int page = 1;
  int pageCount = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkCon();
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

  _getNewsFeed(int p) async{
    response = await ServiceHelper().getNewsFeed(8, p, pageCount, "0fc9d06a-a622-4288-975d-b5f414a9ad73");
    List result = response.data['Results'];
    print('loadmore: ${p}');
    Fluttertoast.showToast(msg: 'page: ${p}', backgroundColor: Colors.black.withOpacity(0.6));
    if(response.data != null){
      if(result.length > 0){
        for(var model in result){
          _newsFeedReactModel.add(NewsFeedReactModel.fromJson(model));
        }
        setState(() {
          _isEnd = false;
        });
      }else{
        setState(() {
          _isEnd = true;
        });
      }
    }else{
      setState(() {
        _isEnd = true;
      });
    }
    print('isEnd: ${_isEnd}');
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
    //print('photolink: ${photoList }');

    return Card(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewsFeedDetailScreen(newsFeedModel, photoList)));
              },
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
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
                            placeholder: (context, url) => Center(child: Container(
                              child: Center(child: new CircularProgressIndicator(strokeWidth: 2.0,)), width: double.maxFinite, height: 150.0,)),
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
                  Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end,children: <Widget>[Image.asset('images/save.png', width: 20.0,height: 20.0,),],))
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
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int position){
          return position==0?Container(
            margin: EdgeInsets.only(top: 24.0, bottom: 20.0, left: 15.0, right: 15.0),
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
                    CircleAvatar(child: Image.asset('images/profile_placeholder.png'), backgroundColor: myColor.colorGrey, radius: 25.0,)
                  ],
                ),
              ],
            ),
          ):_newsFeedList(position);
        }
    );
  }

  Widget getNoConnectionWidget(){
    return Container(
      margin: EdgeInsets.only(top: 48.0, bottom: 20.0, left: 15.0, right: 15.0),
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
              CircleAvatar(child: Image.asset('images/profile_placeholder.png'), backgroundColor: myColor.colorGrey, radius: 25.0,)
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
                    _checkCon();
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

  Future<bool> _loadMore() async {
    await _checkCon();
    if(_isCon){
      page++;
      await _getNewsFeed(page);
      //Fluttertoast.showToast(msg: 'call loadmore');
    }
    return _isCon;
  }

  Widget _renderLoad(){
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 48.0, bottom: 20.0, left: 15.0, right: 15.0),
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
                CircleAvatar(child: Image.asset('images/profile_placeholder.png'), backgroundColor: myColor.colorGrey, radius: 25.0,)
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

  Future<Null> _handleRefresh() async {
    await _checkCon();
   if(_isCon){
     _newsFeedReactModel.clear();
     page = 0;
     page++;
     await _getNewsFeed(page);
   }else{
     Fluttertoast.showToast(msg: 'Check Connection', backgroundColor: Colors.black.withOpacity(0.7), fontSize: fontSize.textSizeSmall);
   }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await _getNewsFeed(page),
      renderLoad: () => _renderLoad(),
      renderError: ([error]) => getNoConnectionWidget(),
      renderSuccess: ({data}) => Container(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: LoadMore(
            isFinish: _isEnd,
            onLoadMore: _loadMore,
            delegate: DefaultLoadMoreDelegate(),
            textBuilder: DefaultLoadMoreTextBuilder.english,
            child: _listView()
            /*CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverList(delegate: SliverChildBuilderDelegate((context, i) =>
                    Container(
                      child: Column(
                        children: <Widget>[
                          i==0?Container(
                            margin: EdgeInsets.only(top: 50.0, bottom: 20.0, left: 15.0, right: 15.0),
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
                                    CircleAvatar(child: Image.asset('images/profile_placeholder.png'), backgroundColor: myColor.colorGrey, radius: 25.0,)
                                  ],
                                ),
                              ],
                            ),
                          ):Container(width: 0.0,height: 0.0,),
                          _newsFeedList(i)
                        ],
                      )
                    )
                    , childCount: _newsFeedReactModel.length))
              ],
            ),*/
          ),
        ),
      )
    );
    return Scaffold(
      body: _asyncLoader,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
