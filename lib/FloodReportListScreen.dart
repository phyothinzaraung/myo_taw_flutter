import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/NewFloodReportScreen.dart';
import 'package:myotaw/helper/FloodLevelFtInHelper.dart';
import 'package:myotaw/helper/ServiceHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/model/ContributionModel.dart';
import 'helper/MyoTawConstant.dart';
import 'helper/ShowDateTimeHelper.dart';
import 'myWidget/EmptyViewWidget.dart';
import 'myWidget/NoConnectionWidget.dart';

class FloodReportListScreen extends StatefulWidget {
  @override
  _FloodReportListScreenState createState() => _FloodReportListScreenState();
}

class _FloodReportListScreenState extends State<FloodReportListScreen> {
  final GlobalKey<AsyncLoaderState> asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  List<ContributionModel> _floodLevelReportModelList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _getFloodReportList()async{
    await _sharepreferenceshelper.initSharePref();
    var response = await ServiceHelper().getFloodLevelReportList(_sharepreferenceshelper.getRegionCode(), _sharepreferenceshelper.getUserUniqueKey());
    if(response.data != null && response.data.length > 0){
      for(var i in response.data){
        _floodLevelReportModelList.add(ContributionModel.fromJson(i));
      }
    }
  }

  _listView(){
    return ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: _floodLevelReportModelList.length,
        itemBuilder: (context, index){
          return Container(
            child: Card(
              margin: EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 3,
                    height: 130,
                    color: MyColor.colorPrimaryDark,
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Image.asset('images/flood_nocircle.png', width: 30, height: 30,)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(bottom: 10, right: 10),
                                    child: Text(MyString.txt_flood_level_inch + ' '+FloodLevelFtInHelper().getFtInFromWaterLevel(_floodLevelReportModelList[index].floodLevel), style: TextStyle(color: MyColor.colorTextBlack, fontSize: FontSize.textSizeSmall),)),
                                Row(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Image.asset('images/calendar.png', width: 15, height: 15, color: MyColor.colorPrimary,)),
                                    Text(ShowDateTimeHelper().showDateTimeFromServer(_floodLevelReportModelList[index].accesstime), style: TextStyle(fontSize: FontSize.textSizeSmall),)
                                  ],
                                )
                              ],
                            ),
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              child: CachedNetworkImage(
                                  imageUrl: BaseUrl.CONTRIBUTE_PHOTO_URL+_floodLevelReportModelList[index].photoUrl,
                                imageBuilder: (context, image){
                                  return Container(
                                    width: 90,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: image,
                                          fit: BoxFit.cover),
                                    ),);
                                },
                                placeholder: (context, url) => Center(child: Container(
                                  child: Center(child: new CircularProgressIndicator(strokeWidth: 2.0,)), width: 90, height: 90.0,)),
                                errorWidget: (context, url, error)=> Image.asset('images/placeholder.jpg',width: 90,
                                  height: 90, fit: BoxFit.cover,),
                              )
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  Widget _renderLoad(){
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[CircularProgressIndicator()],)
        ],
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    _floodLevelReportModelList.clear();
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  _navigateToNewFloodReportScreen()async{
    Map result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewFloodReportScreen()));
    if(result != null && result.containsKey('isNeedRefresh')){
      _handleRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
        key: asyncLoaderState,
        initState: () async => await _getFloodReportList(),
        renderLoad: () => _renderLoad(),
        renderError: ([error]) => noConnectionWidget(asyncLoaderState),
        renderSuccess: ({data}) => Container(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: _floodLevelReportModelList.isNotEmpty?_listView() : emptyView(asyncLoaderState,MyString.txt_flood_level_no_record),
          ),
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_flood_level, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){

        _navigateToNewFloodReportScreen();

      }, label: Text(MyString.txt_add_flood_level_record, style: TextStyle(color: Colors.white),),
        icon: Icon(Icons.add_circle_outline, color: Colors.white,), backgroundColor: MyColor.colorPrimary,),
      body: _asyncLoader
    );
  }
}
