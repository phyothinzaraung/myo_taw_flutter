import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'helper/MyoTawConstant.dart';

class SuggestionScreen extends StatefulWidget {
  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  List<String> _subjectList = new List<String>();
  String _dropDownSubject = MyString.txt_choose_subject;
  TextEditingController _messController = TextEditingController();
  String _mess;
  bool _isCon;
  File _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subjectList = [_dropDownSubject,'လမ်းပြင်၊ လမ်းပျက်','အမှိုက်','ရေမြောင်း','ရေကြီး၊ ရေလျှံ','မီးကြိုး','တိရိစ္ဆာန်အရေး','ရေပေးဝေရေး','အများပိုင်နေရာ','အခြား'];
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
    //print('isCon : ${_isCon}');
  }

  Future camera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 1024, maxHeight: 768);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.txt_suggestion, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
            child: Row(
              children: <Widget>[
                Container(margin: EdgeInsets.only(right: 10.0),
                    child: Image.asset('images/suggestion_no_circle.png', width: 30.0, height: 30.0,)),
                Text(MyString.title_suggestion, style: TextStyle(fontSize: FontSize.textSizeSmall),),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(0.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  _image!=null?Image.file(_image, width: double.maxFinite, height: 200.0, fit: BoxFit.cover,):
                  Image.asset('images/placeholder.jpg', width: double.maxFinite, height: 200.0, fit: BoxFit.cover,),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 45.0,
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: RaisedButton(onPressed: (){
                            camera();
                            },child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(right: 30.0),
                                  child: Image.asset('images/camera.png', width: 25.0, height: 25.0,)),
                              Text(MyString.txt_upload_photo_camera, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorPrimary),)
                            ],
                          ),color: Colors.white,elevation: 1.0,
                            shape: RoundedRectangleBorder(side: BorderSide(color: MyColor.colorPrimary,), borderRadius: BorderRadius.circular(5.0)),),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                            child: Text(MyString.title_suggestion_subject, style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          padding: EdgeInsets.symmetric(horizontal: 7.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(
                                  color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.80
                              )
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              style: new TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.black87),
                              isExpanded: true,
                              iconEnabledColor: MyColor.colorPrimary,
                              value: _dropDownSubject,
                              onChanged: (String value){
                                setState(() {
                                  _dropDownSubject = value;
                                });
                              },
                              items: _subjectList.map<DropdownMenuItem<String>>((String str){
                                return DropdownMenuItem<String>(
                                  value: str,
                                  child: Text(str),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Text(MyString.title_suggestion_mess, style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                        Container(
                          margin: EdgeInsets.only(top: 5.0, bottom: 20.0),
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          height: 160.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none
                            ),
                            controller: _messController,
                            style: TextStyle(fontSize: FontSize.textSizeSmall),
                            onChanged: (value){
                              _mess = value;
                            },
                          ),
                        ),
                        Container(
                          height: 45.0,
                          width: double.maxFinite,
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: RaisedButton(onPressed: ()async{
                            await _checkCon();
                            if(_isCon){

                            }else{
                              Fluttertoast.showToast(msg: 'No internet connection', fontSize: FontSize.textSizeNormal, backgroundColor: Colors.black.withOpacity(0.7));
                            }

                            }, child: Text(MyString.txt_save_user_profile, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
                            color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
