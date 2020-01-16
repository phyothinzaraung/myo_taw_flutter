import 'package:flutter/material.dart';

class ButtonLoadingIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 2,
        ));
  }
}
