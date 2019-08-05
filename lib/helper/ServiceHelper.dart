import 'dart:core';
import 'package:dio/dio.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';

class ServiceHelper{
 var response;
 final Dio dio = new Dio();
 int conTimeOut = 60000;

 getNewsFeed<Response>(int organizationId, int page, int pageSize, String userUniqueKey) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_NEWSFEED+"newsfeedposted/getcitynewsfeed",
      queryParameters: {"OrganizationID": organizationId, "page": page, "pageSize": pageSize, "UserUniqueKey": userUniqueKey});
  return response;
 }

 likeReact<Response>(String userUniqueKey, String newsFeedId, String react) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_NEWSFEED+"newsfeedposted/iosreact",
      queryParameters: {"userguid": userUniqueKey, "nfguid": newsFeedId, "react": react});
  return response;
 }

 userLogin<Response>(String PhoneNo, String RegionCode, String Token, String Resource) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Account/LoginForAndroid",
      queryParameters: {"PhoneNO": PhoneNo, "RegionCode": RegionCode, "Token": Token, "Resource": Resource});
  return response;
 }

}


