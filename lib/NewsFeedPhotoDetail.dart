import 'package:flutter/material.dart';
import 'helper/myoTawConstant.dart';

class NewsFeedPhotoDetail extends StatelessWidget {
  String _photoUrl;
  NewsFeedPhotoDetail(this._photoUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(baseUrl.NEWS_FEED_CONTENT_URL+_photoUrl),
      ),
    );
  }
}
