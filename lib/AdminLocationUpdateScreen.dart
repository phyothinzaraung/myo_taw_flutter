import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'helper/MyoTawConstant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminLocationUpdateScreen extends StatefulWidget {
  @override
  _AdminLocationUpdateScreenState createState() => _AdminLocationUpdateScreenState();
}

class _AdminLocationUpdateScreenState extends State<AdminLocationUpdateScreen> {
  Completer<GoogleMapController> _controller = Completer();
  var _location = new Location();
  CameraPosition _cameraPosition;
  String _lat, _lng;
  LatLng _latLng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _location.serviceEnabled().then((isEnable){
      if(!isEnable){
        _location.requestService().then((value){
          if(value){
            _location.onLocationChanged().listen((currentLocation){
              _lat = currentLocation.latitude.toString();
              _lng = currentLocation.longitude.toString();
              setState(() {
                _cameraPosition = CameraPosition(
                  target: LatLng(currentLocation.latitude, currentLocation.longitude),
                  zoom: 14.4746,
                );
              });
            });
            //Navigator.of(context).pop();
          }else{
            Navigator.of(context).pop();
          }
        });
      }else{
        _location.onLocationChanged().listen((currentLocation){
          _lat = currentLocation.latitude.toString();
          _lng = currentLocation.longitude.toString();
          if(mounted){
            setState(() {
              _cameraPosition = CameraPosition(
                  target: LatLng(currentLocation.latitude, currentLocation.longitude),
                  zoom: 15.0
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
          Image.asset('images/pin_holder.png', width: 30.0, height: 30.0,)

        ],
      ) :
      Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
