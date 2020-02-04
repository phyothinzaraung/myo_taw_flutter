import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/myWidget/CustomButtonWidget.dart';

class IosPickerWidget extends StatelessWidget {
  final VoidCallback onPress;
  final String text;
  final ValueChanged<int> onSelectedItemChanged;
  final List<Widget> children;
  final FixedExtentScrollController fixedExtentScrollController;

  IosPickerWidget({this.text,this.onPress, this.onSelectedItemChanged, this.children, this.fixedExtentScrollController});

  Future iosPicker(BuildContext context){
    return showCupertinoModalPopup(
        context: context,
        builder: (context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomButtonWidget(onPress: (){
                      Navigator.pop(context);
                    }, child: Text(MyString.txt_close, style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: Colors.red),),
                      color: Colors.white,
                      isFlatButton: true,
                    ),
                    CustomButtonWidget(onPress: onPress,
                        child: Text(MyString.txt_confirm,style: TextStyle(fontSize: FontSize.textSizeExtraSmall, color: Colors.blue)),
                        color: Colors.white,
                        isFlatButton: true,
                    ),
                  ],
                ),
              ),
              Container(
                height: 180,
                child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 35,
                    magnification: 1,
                    scrollController: fixedExtentScrollController,
                    useMagnifier: true,
                    onSelectedItemChanged: onSelectedItemChanged,
                    children: children
                ),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          iosPicker(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(text, style: TextStyle(fontSize: FontSize.textSizeExtraSmall),),
        ));
  }
}
