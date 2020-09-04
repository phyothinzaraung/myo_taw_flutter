import 'package:intl/intl.dart';

class ShowDateTimeHelper{
  //created by YYW
  static String showDateTimeDifference(String date){
    var dateFormat;
    if(date != null){
      var list = date.split('.');
      var dateTime = DateTime.parse(list[0]);
      var timeDiff = DateTime.now().difference(dateTime);
      var dateList = date.split('T');

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
    }
    return dateFormat.toString();
  }

  static String showDateTimeFromServer(String date){
    var list = date.split('.');
    var dateTime = DateTime.parse(list[0]);
    var timeDiff = DateTime.now().difference(dateTime);
    var dateList = date.split('T');
    var dateFormat;
    dateFormat = DateFormat('dd MMMM yyyy').format(DateTime.parse(dateList[0])).toString();
    return dateFormat;
  }

  static String formatDateTimeForSearch(String date){
    var list = date.split('.');
    var dateTime = DateTime.parse(list[0]);
    var timeDiff = DateTime.now().difference(dateTime);
    var dateList = date.split('T');
    var dateFormat;
    dateFormat = DateFormat('yyyy/MM/dd').format(DateTime.parse(dateList[0])).toString();
    return dateFormat;
  }
}