import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/myWidget/ApplyBizLicenseFormSnackBarWidget.dart';
import 'package:myotaw/myWidget/CustomDialogWidget.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/DropDownWidget.dart';
import 'package:myotaw/myWidget/IosPickerWidget.dart';
import 'package:myotaw/myWidget/WarningSnackBarWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'model/BizLicenseModel.dart';
import 'helper/SharePreferencesHelper.dart';
import 'Database/LocationDb.dart';
import 'model/ApplyBizLicenseModel.dart';
import 'Database/UserDb.dart';
import 'model/UserModel.dart';
import 'helper/ServiceHelper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'ApplyBizLicensePhotoListScreen.dart';
import 'myWidget/CustomButtonWidget.dart';
import 'myWidget/CustomProgressIndicator.dart';

class ApplyBizLicenseFormScreen extends StatefulWidget {
  BizLicenseModel model;
  ApplyBizLicenseFormScreen(this.model);
  @override
  _ApplyBizLicenseFormScreenState createState() => _ApplyBizLicenseFormScreenState(this.model);
}

class _ApplyBizLicenseFormScreenState extends State<ApplyBizLicenseFormScreen> {
  BizLicenseModel _bizLicenseModel;
  ApplyBizLicenseModel _applyBizLicenseModel = ApplyBizLicenseModel();

  TextEditingController _bizNameController = TextEditingController();
  TextEditingController _bizTypeController = TextEditingController();
  TextEditingController _bizLengthController = TextEditingController();
  TextEditingController _bizWidthController = TextEditingController();
  TextEditingController _bizRegionNoController = TextEditingController();
  TextEditingController _bizStreetController = TextEditingController();
  TextEditingController _bizBlockNoController = TextEditingController();

  TextEditingController _ownerNameController = TextEditingController();
  TextEditingController _ownerNrcController = TextEditingController();
  TextEditingController _ownerPhoneController = TextEditingController();
  TextEditingController _ownerRegionNoController = TextEditingController();
  TextEditingController _ownerStreetController = TextEditingController();
  TextEditingController _ownerBlockNoController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();

  List<String> _stateList;
  List<String> _townshipList;
  String _dropDownBizState = MyString.txt_choose_state_township;
  String _dropDownBizTownship = MyString.txt_choose_state_township;

  List<String> _ownerStateList;
  List<String> _ownerTownshipList;
  String _dropDownOwnerState = MyString.txt_choose_state_township;
  String _dropDownOwnerTownship = MyString.txt_choose_state_township;
  LocationDb _locationDb = LocationDb();
  bool _isCon, _isLoading = false;
  bool _isClose = false;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();
  UserDb _userDb = UserDb();
  UserModel _userModel;
  var _response;
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey();

  List<Widget> _bizStateWidgetList = List();
  List<Widget> _bizTownshipWidgetList = List();
  List<Widget> _ownerStateWidgetList = List();
  List<Widget> _ownerTownshipWidgetList = List();
  int _bizStatePickerIndex, _bizTownshipPickerIndex, _ownerStatePickerIndex, _ownerTownshipPickerIndex;


  _ApplyBizLicenseFormScreenState(this._bizLicenseModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stateList = [_dropDownBizState];
    _townshipList = [_dropDownBizTownship];
    _ownerStateList = [_dropDownOwnerState];
    _ownerTownshipList = [_dropDownOwnerTownship];

    _bizStatePickerIndex = 0;
    _bizTownshipPickerIndex = 0;
    _ownerStatePickerIndex = 0;
    _ownerTownshipPickerIndex = 0;
    _init();
    _getUser();
  }

  _pickerWidgetStateInit(){
    for(var i in _stateList){
      _bizStateWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));

      _ownerStateWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _pickerWidgetBizTownshipInit(){
    for(var i in _townshipList){
      _bizTownshipWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _pickerWidgetOwnerTownshipInit(){
    for(var i in _ownerTownshipList){

      _ownerTownshipWidgetList.add(Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(i, style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),),
      ));
    }
  }

  _init()async{
    await _locationDb.openLocationDb();
    var stateList = await _locationDb.getState();
    _locationDb.closeLocationDb();
    _stateList.addAll(stateList);
    _ownerStateList.addAll(stateList);
    _pickerWidgetStateInit();
  }

  _getUser()async{
    await _sharepreferenceshelper.initSharePref();
    await _userDb.openUserDb();
    var model = await _userDb.getUserById(_sharepreferenceshelper.getUserUniqueKey());
    _userDb.closeUserDb();
    setState(() {
      _userModel = model;
    });
  }

  _getTownshipByState(String state)async{
    await _locationDb.openLocationDb();
    var townshipList = await _locationDb.getTownshipByState(state);
    _locationDb.closeLocationDb();

    setState(() {
      _townshipList.addAll(townshipList);
    });

    _pickerWidgetBizTownshipInit();
  }

  _getOwnerTownshipByState(String state)async{
    await _locationDb.openLocationDb();
    var townshipList = await _locationDb.getTownshipByState(state);
    _locationDb.closeLocationDb();

    setState(() {
      _ownerTownshipList.addAll(townshipList);
    });

    _pickerWidgetOwnerTownshipInit();
  }

  _checkCon()async{
    var conResult = await(Connectivity().checkConnectivity());
    if (conResult == ConnectivityResult.none) {
      _isCon = false;
    }else{
      _isCon = true;
    }
    print('isCon : ${_isCon}');
  }

  _callWebService(ApplyBizLicenseModel model)async{
    try{
      _response = await ServiceHelper().postApplyBizLicense(model);
      if(_response.data != null){
        CustomDialogWidget().customSuccessDialog(
          context: context,
          content: MyString.txt_need_paper_work,
          img: 'camera.png',
          onPress: (){
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ApplyBizLicensePhotoListScreen(ApplyBizLicenseModel.fromJson(_response.data))));
          }
        );
      }else{
        WarningSnackBar(_globalKey, MyString.txt_try_again);
      }
    }catch(e){
      print(e);
      WarningSnackBar(_globalKey, MyString.txt_try_again);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget _body(BuildContext context){
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CustomProgressIndicatorWidget(),
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
            child: Row(
              children: <Widget>[
                Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/business_license_nocircle.png', width: 30.0, height: 30.0,)),
                Text(MyString.title_biz_license, style: TextStyle(fontSize: FontSize.textSizeSmall),)
              ],
            ),
          ),
          _isClose==false?Card(
            margin: EdgeInsets.all(0.0),
            elevation: 0.0,
            color: Colors.black.withOpacity(0.7),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
            child: Container(
                margin: EdgeInsets.only(left: 30.0),
                padding: EdgeInsets.all(3.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 20.0),
                              child: Image.asset('images/star.png', width: 15.0, height: 15.0,)),
                          Expanded(
                              child: Text(MyString.txt_apply_license_need_to_fill, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),)),
                        ],
                      ),
                    ),
                    IconButton(icon: Icon(Icons.clear, color: Colors.white,), onPressed: (){
                      setState(() {
                        _isClose = true;
                      });
                    })
                  ],
                )),
          ) : Container(),
          //biz
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            child: Card(
              margin: EdgeInsets.all(0.0),
              elevation: 0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
              //biz information
              child: Container(
                margin: EdgeInsets.only(left: 30.0, right: 20.0, bottom: 30.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(MyString.txt_biz_license_information,
                        style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),),
                    ),
                    //text biz name
                    Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Text(MyString.txt_biz_name, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                    //text field biz name
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        cursorColor: MyColor.colorPrimary,
                        controller: _bizNameController,
                        style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                      ),
                    ),
                    //text biz type
                    Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Text(MyString.txt_biz_type, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                            Image.asset('images/star.png', width: 8.0, height: 8.0,)
                          ],
                        )),
                    //text field biz type
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        cursorColor: MyColor.colorPrimary,
                        controller: _bizTypeController,
                        style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                      ),
                    ),
                    //text biz area
                    Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Text(MyString.txt_area, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                            Image.asset('images/star.png', width: 8.0, height: 8.0,)
                          ],
                        )),
                    //text field biz l & w
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7.0),
                                        border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      cursorColor: MyColor.colorPrimary,
                                      controller: _bizLengthController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 1,
                                    child: Text(MyString.txt_unit_feet, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7.0),
                                        border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      cursorColor: MyColor.colorPrimary,
                                      controller: _bizWidthController,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 1,
                                    child: Text(MyString.txt_unit_feet, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    //biz location
                    Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Text(MyString.txt_biz_location, style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),)),

                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //text biz region no
                                Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Text(MyString.txt_biz_region_no, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                                //text field biz region no
                                Container(
                                  margin: EdgeInsets.only(right: 10.0),
                                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    cursorColor: MyColor.colorPrimary,
                                    controller: _bizRegionNoController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //text biz street
                                Container(
                                    margin: EdgeInsets.only(bottom: 5.0),
                                    child: Text(MyString.txt_biz_street_name, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                                //text field biz street
                                Container(
                                  margin: EdgeInsets.only(right: 10.0),
                                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    cursorColor: MyColor.colorPrimary,
                                    controller: _bizStreetController,
                                    style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //text block no
                    Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Text(MyString.txt_biz_block_no, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                    //text field block no
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        cursorColor: MyColor.colorPrimary,
                        controller: _bizBlockNoController,
                        style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                      ),
                    ),
                    //text biz state
                    Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Text(MyString.txt_state, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                            Image.asset('images/star.png', width: 8.0, height: 8.0,)
                          ],
                        )),
                    //dropdown biz state
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                              color: MyColor.colorGreyDark,style: BorderStyle.solid, width: 0.80
                          )
                      ),
                      child: Platform.isAndroid?

                          DropDownWidget(
                            value: _dropDownBizState,
                            onChange: (value){
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                _dropDownBizState = value;
                              });
                              _townshipList.clear();
                              setState(() {
                                _dropDownBizTownship = MyString.txt_choose_state_township;
                              });
                              _townshipList = [_dropDownBizTownship];
                              _getTownshipByState(_dropDownBizState);
                            },
                            list: _stateList,
                          )

                          :
                      IosPickerWidget(
                        text: _dropDownBizState,
                        fixedExtentScrollController: FixedExtentScrollController(initialItem: _bizStatePickerIndex),
                        onSelectedItemChanged: (index){
                          _bizStatePickerIndex = index;
                        },
                        onPress: (){
                          setState(() {
                            _dropDownBizState = _stateList[_bizStatePickerIndex];
                          });
                          _townshipList.clear();
                          _bizTownshipWidgetList.clear();

                          setState(() {
                            _townshipList = [MyString.txt_choose_state_township];
                          });

                          _dropDownBizTownship = _townshipList[0];
                          _getTownshipByState(_dropDownBizState);
                          Navigator.pop(context);
                        },
                        children: _bizStateWidgetList,
                      ),
                    ),
                    //text biz township
                    Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Text(MyString.txt_township, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                            Image.asset('images/star.png', width: 8.0, height: 8.0,)
                          ],
                        )),
                    //dropdown biz township
                    Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                              color: MyColor.colorGreyDark,style: BorderStyle.solid, width: 0.80
                          )
                      ),
                      child: Platform.isAndroid?

                      DropDownWidget(
                        value: _dropDownBizTownship,
                        onChange: (value){
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            _dropDownBizTownship = value;
                          });
                        },
                        list: _townshipList,
                      )

                          :
                      IosPickerWidget(
                        text: _dropDownBizTownship,
                        fixedExtentScrollController: FixedExtentScrollController(initialItem: _bizTownshipPickerIndex),
                        onSelectedItemChanged: (index){
                          _bizTownshipPickerIndex = index;
                        },
                        onPress: (){
                          setState(() {
                            _dropDownBizTownship = _townshipList[_bizTownshipPickerIndex];
                          });
                          Navigator.pop(context);
                        },
                        children: _bizTownshipWidgetList,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          //owner
          Card(
            margin: EdgeInsets.all(0.0),
            elevation: 0.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
            child: Container(
              margin: EdgeInsets.only(left: 30.0, right: 20.0, bottom: 30.0, top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //text owner information
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(MyString.txt_owner_information,
                      style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),),
                  ),
                  //text owner name
                  Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: Text(MyString.txt_owner_name, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                          Image.asset('images/star.png', width: 8.0, height: 8.0,)
                        ],
                      )),
                  //text field owner name
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      cursorColor: MyColor.colorPrimary,
                      controller: _ownerNameController,
                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                    ),
                  ),
                  //text owner nrc
                  Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: Text(MyString.txt_owner_nrc_no, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                          Image.asset('images/star.png', width: 8.0, height: 8.0,)
                        ],
                      )),
                  //text field owner nrc
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      cursorColor: MyColor.colorPrimary,
                      controller: _ownerNrcController,
                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                    ),
                  ),
                  //text owner ph
                  Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: Text(MyString.txt_owner_ph_no, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                          Image.asset('images/star.png', width: 8.0, height: 8.0,)
                        ],
                      )),
                  //text field owner ph
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      cursorColor: MyColor.colorPrimary,
                      controller: _ownerPhoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                    ),
                  ),
                  //text location
                  Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(MyString.txt_biz_location, style: TextStyle(fontSize: FontSize.textSizeExtraNormal, color: MyColor.colorPrimary),)),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //text owner region no
                              Container(
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  child: Text(MyString.txt_biz_region_no, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                              //text field owner regio no
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  cursorColor: MyColor.colorPrimary,
                                  controller: _ownerRegionNoController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //text owner street name
                              Container(
                                  margin: EdgeInsets.only(bottom: 5.0),
                                  child: Text(MyString.txt_biz_street_name, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                              //text field owner street name
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  cursorColor: MyColor.colorPrimary,
                                  controller: _ownerStreetController,
                                  style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //text owner block no
                  Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(MyString.txt_biz_block_no, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                  //text field owner block no
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      cursorColor: MyColor.colorPrimary,
                      controller: _ownerBlockNoController,
                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                    ),
                  ),
                  //text owner state
                  Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: Text(MyString.txt_state, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                          Image.asset('images/star.png', width: 8.0, height: 8.0,)
                        ],
                      )),


                  //drop down owner state
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(
                            color: MyColor.colorGreyDark,style: BorderStyle.solid, width: 0.80
                        )
                    ),
                    child: Platform.isAndroid?

                    DropDownWidget(
                      value: _dropDownOwnerState,
                      onChange: (value){
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          _dropDownOwnerState = value;
                        });
                        _ownerTownshipList.clear();
                        setState(() {
                          _dropDownOwnerTownship = MyString.txt_choose_state_township;
                        });
                        _ownerTownshipList = [_dropDownOwnerTownship];
                        _getOwnerTownshipByState(_dropDownOwnerState);
                      },
                      list: _ownerStateList,
                    )

                        :
                    IosPickerWidget(
                      text: _dropDownOwnerState,
                      fixedExtentScrollController: FixedExtentScrollController(initialItem: _ownerStatePickerIndex),
                      onSelectedItemChanged: (index){
                        _ownerStatePickerIndex = index;
                      },
                      onPress: (){
                        setState(() {
                          _dropDownOwnerState = _ownerStateList[_ownerStatePickerIndex];
                        });
                        _ownerTownshipList.clear();
                        _ownerTownshipWidgetList.clear();

                        setState(() {
                          _ownerTownshipList = [MyString.txt_choose_state_township];
                        });

                        _dropDownOwnerTownship = _ownerTownshipList[0];
                        _getOwnerTownshipByState(_dropDownOwnerState);
                        Navigator.pop(context);
                      },
                      children: _ownerStateWidgetList,
                    ),
                  ),
                  //text owner township
                  Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: Text(MyString.txt_township, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                          Image.asset('images/star.png', width: 8.0, height: 8.0,)
                        ],
                      )),


                  //dropdown owner township
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(
                            color: MyColor.colorGreyDark,style: BorderStyle.solid, width: 0.80
                        )
                    ),
                    child: Platform.isAndroid?

                    DropDownWidget(
                      value: _dropDownOwnerTownship,
                      onChange: (value){
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          _dropDownOwnerTownship = value;
                        });
                      },
                      list: _ownerTownshipList,
                    )

                        :
                    IosPickerWidget(
                      text: _dropDownOwnerTownship,
                      fixedExtentScrollController: FixedExtentScrollController(initialItem: _ownerTownshipPickerIndex),
                      onSelectedItemChanged: (index){
                        _ownerTownshipPickerIndex = index;
                      },
                      onPress: (){
                        setState(() {
                          _dropDownOwnerTownship = _ownerTownshipList[_ownerTownshipPickerIndex];
                        });
                        Navigator.pop(context);
                      },
                      children: _ownerTownshipWidgetList,
                    ),
                  ),
                  //text remark
                  Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(MyString.txt_remark, style: TextStyle(fontSize: FontSize.textSizeSmall, color: MyColor.colorTextBlack),)),
                  //text field remark
                  Container(
                    margin: EdgeInsets.only(top: 5.0, bottom: 20.0),
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    height: 160.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(color: MyColor.colorGreyDark, style: BorderStyle.solid, width: 0.80)
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none
                      ),
                      controller: _remarkController,
                      style: TextStyle(fontSize: FontSize.textSizeNormal, color: MyColor.colorTextBlack),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.all(20.0),
            child: CustomButtonWidget(onPress: ()async{
              await _checkCon();
              if(_isCon){
                if(_bizTypeController.text!=null && _bizLengthController.text!=null && _bizWidthController.text != null && _dropDownBizState != MyString.txt_choose_state_township
                    && _dropDownBizTownship != MyString.txt_choose_state_township &&_ownerNameController.text !=null && _ownerNrcController.text != null && _ownerPhoneController.text !=null
                    && _dropDownOwnerState != MyString.txt_choose_state_township && _dropDownOwnerTownship != MyString.txt_choose_state_township){
                  setState(() {
                    _isLoading = true;
                  });
                  _applyBizLicenseModel.id = 0;//int id cannot be null for post object
                  _applyBizLicenseModel.bizName = _bizNameController.text;
                  _applyBizLicenseModel.bizType = _bizTypeController.text;
                  _applyBizLicenseModel.length = double.parse(_bizLengthController.text);
                  _applyBizLicenseModel.width = double.parse(_bizWidthController.text);
                  _applyBizLicenseModel.area = _applyBizLicenseModel.length * _applyBizLicenseModel.width;
                  _applyBizLicenseModel.bizRegionNo = _bizRegionNoController.text;
                  _applyBizLicenseModel.bizStreetName = _bizStreetController.text;
                  _applyBizLicenseModel.bizBlockNo = _bizBlockNoController.text;
                  _applyBizLicenseModel.bizTownship = _dropDownBizTownship;
                  _applyBizLicenseModel.bizState = _dropDownBizState;
                  _applyBizLicenseModel.ownerName = _ownerNameController.text;
                  _applyBizLicenseModel.nrcNo = _ownerNrcController.text;
                  _applyBizLicenseModel.phoneNo = _ownerPhoneController.text;
                  _applyBizLicenseModel.regionNo = _ownerRegionNoController.text;
                  _applyBizLicenseModel.streetName = _ownerStreetController.text;
                  _applyBizLicenseModel.blockNo = _ownerBlockNoController.text;
                  _applyBizLicenseModel.township = _dropDownOwnerTownship;
                  _applyBizLicenseModel.state = _dropDownOwnerState;
                  _applyBizLicenseModel.remark = _remarkController.text;
                  _applyBizLicenseModel.uniqueKey = _sharepreferenceshelper.getUserUniqueKey();
                  _applyBizLicenseModel.regionCode = _sharepreferenceshelper.getRegionCode();
                  _applyBizLicenseModel.userName = _userModel.name;
                  _applyBizLicenseModel.licenseType = _bizLicenseModel.licenseType;
                  _applyBizLicenseModel.licensetypeId = _bizLicenseModel.id;
                  _applyBizLicenseModel.source = 'app'; //to know apply biz is from mobile app or chat bot
                  FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.APPLY_BIZ_LICENSE_FORM_SCREEN, ClickEvent.BIZ_LICENSE_APPLIED_CLICK_EVENT, _userModel.uniqueKey);
                  _callWebService(_applyBizLicenseModel);
                }else{
                  ApplyBizLicenseFormSnackBarWidget(_globalKey, MyString.txt_apply_license_need_to_fill);
                }
              }else{
                WarningSnackBar(_globalKey, MyString.txt_check_internet);
              }

            }, child: Text(MyString.txt_apply_license, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),
              color: MyColor.colorPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
        title : Text(MyString.txt_business_tax,maxLines: 1, overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
        body : _body(context),
        globalKey: _globalKey,
    );
  }
}
