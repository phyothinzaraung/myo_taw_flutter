import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';

Widget noConnectionWidget(GlobalKey<AsyncLoaderState> asyncLoaderState){
  return Container(
    child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: FlatButton(onPressed: (){
                asyncLoaderState.currentState.reloadState();
              }
                  , child: Image.asset('images/refresh.png', width: 50, height: 50,)),
            ),
            Text(MyString.txt_no_internet, style: TextStyle(fontSize: FontSize.textSizeNormal),)
          ],
        )
    ),
  );
}