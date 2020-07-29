import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';

class DropDownWidget extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChange;
  final List<String> list;
  double fontSize;
  DropDownWidget({this.value, this.onChange, this.list, this.fontSize : FontSize.textSizeSmall});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: new TextStyle(fontSize: fontSize , color: MyColor.colorTextBlack),
        isExpanded: true,
        iconEnabledColor: MyColor.colorPrimary,
        value: value,
        onChanged: onChange,
        items: list.map<DropdownMenuItem<String>>((String str){
          return DropdownMenuItem<String>(
            value: str,
            child: Text(str),
          );
        }).toList(),
      ),
    );
  }
}
