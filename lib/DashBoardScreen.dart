import 'package:flutter/material.dart';
import 'helper/myoTawConstant.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
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
                      Text('ကဏ္ဍများ', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeNormal),),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
