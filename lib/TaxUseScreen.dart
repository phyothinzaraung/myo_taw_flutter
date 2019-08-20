import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'package:pie_chart/pie_chart.dart';

class TaxUserScreen extends StatefulWidget {
  @override
  _TaxUserScreenState createState() => _TaxUserScreenState();
}

class _TaxUserScreenState extends State<TaxUserScreen> {
  Map<String, double> dataMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataMap = new Map();
    dataMap.putIfAbsent("Flutter", () => 5);
    dataMap.putIfAbsent("React", () => 3);
    dataMap.putIfAbsent("Xamarin", () => 2);
    dataMap.putIfAbsent("Ionic", () => 2);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_tax_use, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: Center(
        child: PieChart(
          dataMap: dataMap, //Required parameter
          legendFontColor: Colors.blueGrey[900],
          legendFontSize: FontSize.textSizeSmall,
          legendFontWeight: FontWeight.w500,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 10.0,
          chartRadius: MediaQuery
              .of(context)
              .size
              .width / 1.5,
          showChartValuesInPercentage: true,
          showChartValues: true,
          showChartValuesOutside: false,
          chartValuesColor: Colors.blueGrey[900].withOpacity(0.9),
          showLegends: true,
        ),
      ),
    );
  }
}
