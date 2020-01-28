import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/helper/FloodLevelFtInHelper.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/helper/NumConvertHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';

class GetFloodLevelScreen extends StatefulWidget {
  @override
  _GetFloodLevelScreenState createState() => _GetFloodLevelScreenState();
}

class _GetFloodLevelScreenState extends State<GetFloodLevelScreen> {
  double _floodLevel = 0;
  double _waterLevel = 0;
  GlobalKey _globalKey = GlobalKey();
  String _convertFloodLevel = '';
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(MyString.txt_get_flood_level, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: Center(
          child: Container(
            margin: EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                      key: _globalKey,
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Image.asset('images/myotaw_man.png')),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: AnimatedContainer(
                                width: double.maxFinite,
                                height: _waterLevel,
                                duration: Duration(milliseconds: 700),
                                color: MyColor.colorPrimary.withOpacity(0.2),
                                curve: Curves.bounceOut,
                              )),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.only(right: 35, top: 30, bottom: 30),
                              child: FlutterSlider(
                                handler: FlutterSliderHandler(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.transparent
                                    ),
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: MyColor.colorPrimary
                                      ),
                                    )
                                ),
                                values: [0],
                                tooltip: FlutterSliderTooltip(
                                    textStyle: TextStyle(fontSize: 17, color: Colors.redAccent),
                                    custom: (value) {
                                      return Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: MyColor.colorPrimary,
                                              borderRadius: BorderRadius.all(Radius.circular(30))
                                          ),
                                          child: Text(_convertFloodLevel, style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.white),));
                                    },
                                    boxStyle: FlutterSliderTooltipBox(
                                        decoration: BoxDecoration(
                                            color: MyColor.colorPrimary,
                                            borderRadius: BorderRadius.all(Radius.circular(30))
                                        )
                                    )
                                ),
                                trackBar: FlutterSliderTrackBar(
                                  activeTrackBar: BoxDecoration(
                                    color: MyColor.colorPrimary
                                  ),
                                  inactiveTrackBar: BoxDecoration(
                                    color: MyColor.colorGreyDark
                                  )
                                ),
                                hatchMark: FlutterSliderHatchMark(
                                  distanceFromTrackBar: 25,
                                  smallLine: FlutterSliderSizedBox(height: 10, width: 10, ),
                                  density: 1, // means 50 lines, from 0 to 100 percent
                                  labels: [
                                    FlutterSliderHatchMarkLabel(percent: 0, label: Text('၀ ${MyString.txt_feet}')),
                                    FlutterSliderHatchMarkLabel(percent: 17, label: Text('၁ ${MyString.txt_feet}')),
                                    FlutterSliderHatchMarkLabel(percent: 33, label: Text('၂ ${MyString.txt_feet}')),
                                    FlutterSliderHatchMarkLabel(percent: 50, label: Text('၃ ${MyString.txt_feet}')),
                                    FlutterSliderHatchMarkLabel(percent: 67, label: Text('၄ ${MyString.txt_feet}')),
                                    FlutterSliderHatchMarkLabel(percent: 83, label: Text('၅ ${MyString.txt_feet}')),
                                    FlutterSliderHatchMarkLabel(percent: 100, label: Text('၆ ${MyString.txt_feet}')),
                                  ],
                                ),
                                selectByTap: false,
                                axis: Axis.vertical,
                                rtl: true,
                                min: 0,
                                max: 72,
                                handlerAnimation: FlutterSliderHandlerAnimation(
                                    curve: Curves.elasticOut,
                                    reverseCurve: Curves.bounceIn,
                                    duration: Duration(milliseconds: 500),
                                    scale: 1.5
                                ),
                                onDragging: (index,lowerValue, higherValue){

                                  setState(() {
                                    _floodLevel = lowerValue;
                                    _waterLevel = _globalKey.currentContext.size.height * _floodLevel / 72;
                                    _convertFloodLevel = FloodLevelFtInHelper().getFtInFromWaterLevel(lowerValue);
                                  });
                                  print(_convertFloodLevel);
                                },

                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                Container(
                  height: 10,
                  width: double.maxFinite,
                  color: MyColor.colorPrimary,
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  height: 50,
                  width: double.maxFinite,
                  child: RaisedButton(onPressed: ()async{
                    await _sharepreferenceshelper.initSharePref();
                    FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.GET_FLOOD_LEVEL_SCREEN, ClickEvent.GET_FLOOD_LEVEL_CLICK_EVENT, _sharepreferenceshelper.getUserUniqueKey());
                    Navigator.of(context).pop({'FloodLevel' : _floodLevel});
                  },child: Text(MyString.txt_get_flood_level,
                    style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    color: MyColor.colorPrimary,elevation: 5.0,
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
