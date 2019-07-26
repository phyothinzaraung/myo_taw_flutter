import 'package:intl/intl.dart';

String showDateTime(String date){
  var list = date.split('T');
  var getDateFormat = DateTime.parse(list[0]);
  String stringDate = DateFormat('dd MMMM yyyy').format(getDateFormat).toString();
  var datime = DateTime(2019,7,26,10,45,22);
  final diff = DateTime.now().difference(datime).inMinutes;
  //print('difffdateime: ${diff}');
  return stringDate;
}