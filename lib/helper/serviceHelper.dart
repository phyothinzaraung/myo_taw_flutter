import 'dart:core';
import 'package:dio/dio.dart';
import 'package:myotaw/helper/myoTawConstant.dart';

class ServiceHelper{
 var response;
 final Dio dio = new Dio();
 int conTimeOut = 60000;

 getNewsFeed<Response>(int organizationId, int page, int pageSize, String userUniqueKey) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(baseUrl.WEB_SERVICE_ROOT_ADDRESS_NEWSFEED+"newsfeedposted/getcitynewsfeed",
      queryParameters: {"OrganizationID": organizationId, "page": page, "pageSize": pageSize, "UserUniqueKey": userUniqueKey});
  return response;
 }

}


