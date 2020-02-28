import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/myWidget/NativeProgressIndicator.dart';
import 'package:photo_view/photo_view.dart';

import 'helper/PlatformHelper.dart';

class PhotoDetailScreen extends StatelessWidget {
  String photoUrl;
  PhotoDetailScreen(this.photoUrl);

  Widget _nativeProgressIndicator() {
    return PlatformHelper.isAndroid() ?
    Center(child: CircularProgressIndicator()) :
    CupertinoTheme(
        data: CupertinoThemeData(
            brightness: Brightness.dark
        ),
        child: CupertinoActivityIndicator(radius: 15,)
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: null,
      body: Container(
        color: Colors.black,
        child: Center(
          child: PhotoView(
            imageProvider: NetworkImage(photoUrl),
            loadingChild: _nativeProgressIndicator(),
            loadFailedChild: Image.asset('images/placeholder.jpg'),
          ),
        ),
      ),
    );
  }
}
