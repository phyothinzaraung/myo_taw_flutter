import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/Helper/MyoTawConstant.dart';

Widget emptyView(GlobalKey<AsyncLoaderState> asyncLoaderState, String text){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: FlatButton(onPressed: () async{
            asyncLoaderState.currentState.reloadState();
          }
              , child: Image.asset('images/refresh.png', width: 50, height: 50,)),
        ),
        Text(text, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ],
    ),
  );
}