import 'package:flutter/material.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';

class FormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(MyString.txt_form, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),
      ),
      body: Center(
        child: Text('form'),
      ),
    );
  }
}
