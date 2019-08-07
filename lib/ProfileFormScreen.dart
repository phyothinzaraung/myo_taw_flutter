import 'package:flutter/material.dart';
import 'helper/MyoTawConstant.dart';
import 'model/UserModel.dart';
import 'model/LocationModel.dart';
import 'Database/LocationDb.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProfileFormScreen extends StatefulWidget {
  UserModel model;
  ProfileFormScreen(this.model);
  @override
  _ProfileFormScreenState createState() => _ProfileFormScreenState(this.model);
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  UserModel _userModel;
  String _userName, _userAddress;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  String _dropDownState = 'နေရပ်ရွေးပါ';
  String _dropDownTownship = 'နေရပ်ရွေးပါ';
  List<String> _stateList;
  List<String> _townshipList;
  bool _isLoading = false;
  LocationDb _locationDb = LocationDb();
  List<LocationModel> _locationList = new List<LocationModel>();
  _ProfileFormScreenState(this._userModel);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initLocation();
    _stateList = [_dropDownState];
    _townshipList = [_dropDownState];
    _nameController.text = _userModel.name;
    _addressController.text = _userModel.address;
  }

  _initLocation()async{
    setState(() {
      _isLoading = true;
    });
    await _locationDb.openLocationDb();
    var state = await _locationDb.getState();
    await _locationDb.closeLocationDb();
    for(var i in state){
      _locationList.add(i);
      _stateList.add(i.stateDivision_Unicode);
    }
    print('prifilelist: ${_locationList.length}');

    setState(() {
      _dropDownState = _userModel.state;
      _isLoading = false;
    });
  }

  Widget modalProgressIndicator(){
    return Center(
      child: Card(
        child: Container(
          width: 220.0,
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(margin: EdgeInsets.only(right: 30.0),
                  child: Text('Loading......',style: TextStyle(fontSize: FontSize.textSizeNormal, color: Colors.black))),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColor.colorPrimary))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyString.title_profile, style: TextStyle(fontSize: FontSize.textSizeNormal),),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: modalProgressIndicator(),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0,left: 30.0, right: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Container(margin: EdgeInsets.only(right: 10.0),child: Image.asset('images/profile.png', width: 30.0, height: 30.0,)),
                        Text(MyString.title_profile, style: TextStyle(fontSize: FontSize.textSizeNormal),)
                      ],
                    ),
                  ),
                  Container(margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(MyString.txt_user_name, style: TextStyle(fontSize: FontSize.textSizeSmall),)),

                  //textfield name
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none
                      ),
                      controller: _nameController,
                      style: TextStyle(fontSize: FontSize.textSizeSmall),
                      onChanged: (value){
                        _userName = value;
                      },
                    ),
                  ),
                  Container(margin: EdgeInsets.only(top:20.0, bottom: 10.0),
                      child: Text(MyString.txt_user_address, style: TextStyle(fontSize: FontSize.textSizeSmall),)),

                  //textfield address
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(color: MyColor.colorPrimary, style: BorderStyle.solid, width: 0.80)
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none
                      ),
                      controller: _addressController,
                      style: TextStyle(fontSize: FontSize.textSizeSmall),
                      onChanged: (value){
                        _userAddress = value;
                      },
                    ),
                  ),

                  Container(margin: EdgeInsets.only(top:20.0, bottom: 10.0),
                      child: Text(MyString.txt_user_state, style: TextStyle(fontSize: FontSize.textSizeSmall),)),

                  //dropdown state
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                        value: _dropDownState,
                        onChanged: (String value){
                          setState(() {
                            _dropDownState = value;
                          });
                        },
                        items: _stateList.map<DropdownMenuItem<String>>((String str){
                          return DropdownMenuItem<String>(
                            value: str,
                            child: Text(str),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  //dropdown township
                  Container(margin: EdgeInsets.only(top:20.0, bottom: 10.0),
                      child: Text(MyString.txt_user_township, style: TextStyle(fontSize: FontSize.textSizeSmall),)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(
                            color: MyColor.colorPrimary,style: BorderStyle.solid, width: 0.80
                        )
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: new TextStyle(fontSize: 13.0, color: Colors.black87),
                        isExpanded: true,
                        iconEnabledColor: MyColor.colorPrimary,
                        value: _dropDownTownship,
                        onChanged: (String value){
                          setState(() {
                            _dropDownTownship = value;
                          });
                        },
                        items: _townshipList.map<DropdownMenuItem<String>>((String str){
                          return DropdownMenuItem<String>(
                            value: str,
                            child: Text(str),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 40.0),
                    width: double.maxFinite,
                    height: 50.0,
                    child: RaisedButton(
                        onPressed: (){

                        },color: MyColor.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      child: Text(MyString.txt_save_user_profile, style: TextStyle(fontSize: FontSize.textSizeSmall, color: Colors.white),),),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
