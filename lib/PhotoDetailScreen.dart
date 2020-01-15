import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoDetailScreen extends StatelessWidget {
  String photoUrl;
  PhotoDetailScreen(this.photoUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(photoUrl),
          loadingChild: Center(child: CircularProgressIndicator(),),
          loadFailedChild: Image.asset('images/placeholder.jpg'),
        ),
      ),
    );
  }
}
