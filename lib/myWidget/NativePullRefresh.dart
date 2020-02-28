import 'package:custom_refresh_indicator/custom_refresh_indicator.dart' as custom;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as materialRefresh;
import 'package:myotaw/helper/PlatformHelper.dart';

class NativePullRefresh extends StatelessWidget {
  final Widget child;
  final RefreshCallback onRefresh;

  NativePullRefresh({@required this.child, @required this.onRefresh});

  Widget _materialPullRefresh(){
    return materialRefresh.RefreshIndicator(
        child: child,
        onRefresh: onRefresh
    );
  }

  Widget _cupertinoPullRefresh(){
    return custom.CustomRefreshIndicator(
        child: child,
        indicatorBuilder: (context, data){
          if(data.isIdle){
            return Container();
          }else{
            return Align(
                alignment: Alignment.topCenter,
                child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: CupertinoActivityIndicator(radius: 13,)));
          }
        },
        onRefresh: onRefresh
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformHelper.isAndroid()? _materialPullRefresh() : _cupertinoPullRefresh();
  }
}
