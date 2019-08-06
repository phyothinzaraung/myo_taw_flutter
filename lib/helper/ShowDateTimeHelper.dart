import 'package:intl/intl.dart';

//created by YYW
String showDateTime(String date){
  var list = date.split('.');
  var dateTime = DateTime.parse(list[0]);
  var timeDiff = DateTime.now().difference(dateTime);
  var dateList = date.split('T');
  var dateFormat;

  if(timeDiff < Duration(days: 0,hours: 0,minutes: 0, seconds: 60)){
    dateFormat = '${DateTime.now().difference(dateTime).inSeconds} second ago';
    //print(('datetime: ${timeDiff} ${dateFormat} seconds'));

  }else if(timeDiff < Duration(days: 0,hours: 0,minutes: 60, seconds: 0)){
    dateFormat = '${DateTime.now().difference(dateTime).inMinutes} minute ago';
    //print(('datetime: ${timeDiff} ${dateFormat} minutes'));

  }else if(timeDiff < Duration(days: 0,hours: 24,minutes: 0, seconds: 0)){
    dateFormat = '${DateTime.now().difference(dateTime).inHours} hour ago';
    //print(('datetime: ${timeDiff} ${dateFormat} hours'));

  }else if(timeDiff < Duration(days: 3, hours: 0,minutes: 0, seconds: 0)){
    dateFormat = '${DateTime.now().difference(dateTime).inDays} day ago';
    //print(('datetime: ${timeDiff} ${dateFormat} hours'));

  }else{
    dateFormat = DateFormat('dd MMMM yyyy').format(DateTime.parse(dateList[0])).toString();
    //print(('datetime: ${timeDiff} ${dateFormat} days'));
  }
  return dateFormat.toString();
}