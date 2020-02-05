import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:myotaw/helper/FireBaseAnalyticsHelper.dart';
import 'package:myotaw/helper/SharePreferencesHelper.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'helper/MyoTawConstant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WardAdminLocationUpdateScreen extends StatefulWidget {
  @override
  _WardAdminLocationUpdateScreenState createState() => _WardAdminLocationUpdateScreenState();
}

class _WardAdminLocationUpdateScreenState extends State<WardAdminLocationUpdateScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  var _location = new Location();
  CameraPosition _cameraPosition;
  LatLng _latLng;
  AnimationController _animatinController;
  Tween<double> _tween = Tween(begin: 1, end: 2);
  StreamSubscription<LocationData> _streamSubscription;
  Sharepreferenceshelper _sharepreferenceshelper = Sharepreferenceshelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animatinController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animatinController.repeat(reverse: true);
    _location.serviceEnabled().then((isEnable){
      if(!isEnable){
        _location.requestService().then((value){
          if(value){
            _streamSubscription = _location.onLocationChanged().listen((currentLocation){
              setState(() {
                _cameraPosition = CameraPosition(
                  target: LatLng(currentLocation.latitude, currentLocation.longitude),
                  zoom: 17,
                );
              });
            });
            //Navigator.of(context).pop();
          }else{
            Navigator.of(context).pop();
          }
        });
      }else{
        _streamSubscription = _location.onLocationChanged().listen((currentLocation){
          if(mounted){
            setState(() {
              _cameraPosition = CameraPosition(
                  target: LatLng(currentLocation.latitude, currentLocation.longitude),
                  zoom: 17.0
              );
            });
          }
        });
      }
    });
  }

  Widget _floatingActionButtion(){
    return FloatingActionButton.extended(onPressed: ()async{
      await _sharepreferenceshelper.initSharePref();
      FireBaseAnalyticsHelper().TrackClickEvent(ScreenName.WARD_ADMIN_LOCATION_UPDATE_SCREEN, ClickEvent.GET_LOCATION_FROM_GOOGLE_MAP, _sharepreferenceshelper.getUserUniqueKey());
      Navigator.of(context).pop({'latLng' : _latLng});

    }, label: Text(MyString.txt_get_location_update, style: TextStyle(color: Colors.white),),
      icon: Icon(Icons.pin_drop, color: Colors.white,),
      backgroundColor: MyColor.colorPrimary,);
  }

  _updatePosition(CameraPosition cameraPosition){
    _latLng = cameraPosition.target;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(MyString.txt_location_update,maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal), ),
      body: _cameraPosition!=null?
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: _cameraPosition,
            mapType: MapType.normal,
            onMapCreated: (controller){
              _controller.complete(controller);
            },
            onCameraMove: (position){
              _updatePosition(position);
            },
          ),
          Align(
            child: ScaleTransition(
              scale: _tween.animate(CurvedAnimation(parent: _animatinController, curve: Curves.bounceIn)),
              child: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset('images/pin_holder.png'),
              ),
            ),
          ),
        ],
      ) :
      Center(
        child: CircularProgressIndicator(),
      ),
    floatingActionButton: _floatingActionButtion()
    );
    /*return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(child: Text(MyString.txt_location_update, style: TextStyle(fontSize: FontSize.textSizeNormal),)),
            //Text(MyString.txt_get_location_update, style: TextStyle(fontSize: FontSize.textSizeSmall),),
          ],
        ),

      ),
      floatingActionButton:
      body:
    );*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //call before super.dispose for active tickerprovidermixing
    //_streamSubscription.cancel();
    _animatinController.stop();
    _animatinController.dispose();
    super.dispose();
  }
}
