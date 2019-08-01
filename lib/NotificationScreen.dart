import 'package:flutter/material.dart';
import 'helper/myoTawConstant.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
                        Text('အသိပေးနှိုးဆော်ချက်', style: TextStyle(color: myColor.colorTextBlack, fontSize: fontSize.textSizeNormal),),
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
