import 'package:flutter/material.dart';

class PhotoDetailScreen extends StatelessWidget {
  String photoUrl;
  PhotoDetailScreen(this.photoUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Center(
        child: Image.network(photoUrl, fit: BoxFit.fitHeight,),
      ),
    );
  }
}
