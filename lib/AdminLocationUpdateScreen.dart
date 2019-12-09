import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'helper/MyoTawConstant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminLocationUpdateScreen extends StatefulWidget {
  @override
  _AdminLocationUpdateScreenState createState() => _AdminLocationUpdateScreenState();
}

class _AdminLocationUpdateScreenState extends State<AdminLocationUpdateScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  var _location = new Location();
  CameraPosition _cameraPosition;
  LatLng _latLng;
  AnimationController _animatinController;
  Tween<double> _tween = Tween(begin: 1, end: 2);
  StreamSubscription<LocationData> _streamSubscription;

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

  _updatePosition(CameraPosition cameraPosition){
    _latLng = cameraPosition.target;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(child: Text(MyString.txt_location_update, style: TextStyle(fontSize: FontSize.textSizeNormal),)),
            //Text(MyString.txt_get_location_update, style: TextStyle(fontSize: FontSize.textSizeSmall),),
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        Navigator.of(context).pop({'latLng' : _latLng});

        }, label: Text(MyString.txt_get_location_update),backgroundColor: MyColor.colorPrimary,),
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
      )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamSubscription.cancel();
  }
}
