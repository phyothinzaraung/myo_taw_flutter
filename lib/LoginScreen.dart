import 'package:flutter/material.dart';
import 'helper/myoTawConstant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> _cityList;
  String _dropDownCity = 'နေရပ်ရွေးပါ';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cityList = [_dropDownCity,'တောင်ကြီးမြို့','မော်လမြိုင်မြို့'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            margin: EdgeInsets.only(left: 70.0, right: 70.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("images/myo_taw_splash_screen.jpg"),
                Padding(padding: EdgeInsets.only(bottom: 5.0),
                    child: Text('Myo Taw', style: TextStyle(fontSize: fontSize.textSizeNormal, color: myColor.colorPrimary),)),
                Text("Version 1.0", style: TextStyle(fontSize: fontSize.textSizeSmall, color: myColor.colorTextGrey),),
                Container(
                  width: 300.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: myColor.colorPrimary, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  padding: EdgeInsets.only(left:10.0, right: 10.0),
                  margin: EdgeInsets.only(top: 70.0,bottom: 30.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      style: new TextStyle(fontSize: 13.0, color: Colors.black87),
                      isExpanded: true,
                      icon: Icon(Icons.location_city),
                      iconEnabledColor: myColor.colorPrimary,
                      value: _dropDownCity,
                      onChanged: (String value){
                        setState(() {
                          _dropDownCity = value;
                        });
                      },
                      items: _cityList.map<DropdownMenuItem<String>>((String str){
                        return DropdownMenuItem<String>(
                          value: str,
                          child: Text(str),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  width: 300.0,
                  height: 45.0,
                  child: RaisedButton(onPressed: (){
                    if(_dropDownCity == 'နေရပ်ရွေးပါ'){
                      Fluttertoast.showToast(msg: 'Please Choose City', backgroundColor: Colors.black.withOpacity(0.7));
                    }else{
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen()));
                    }
                    },child: Text('ဝင်မည်',style: TextStyle(color: Colors.white),),
                    color: myColor.colorPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),),
                )
              ],
            ),
          ),
        )
    );
  }
}
