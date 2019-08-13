import 'dart:core';
import 'package:dio/dio.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/model/UserModel.dart';

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

 getAllTaxRecord<Response>(int page, int pageSize, String regionCode, String unique) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"TaxRecord/GetTaxRecord",
      queryParameters: {"page": page, "pageSize": pageSize, "RegionCode": regionCode, "UniqueKey": unique});
  return response;
 }

 deleteTaxRecord<Response>(int id) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"TaxRecord/DeleteTaxRecord",
      queryParameters: {"ID": id});
  return response;
 }

 updateUserInfo<Response>(UserModel model) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Account/UpdateUser", data: {
   'UniqueKey' : model.uniqueKey,
   'Name': model.name,
   'PhoneNo': model.phoneNo,
   'PhotoUrl': model.photoUrl,
   'State': model.state,
   'Township': model.township,
   'Address': model.address,
   'RegisteredDate': model.registeredDate,
   'Accesstime': model.accesstime,
   'IsDeleted': model.isDeleted,
   'Resource': model.resource,
   'AndroidToken': model.androidToken,
   'CurrentRegionCode': model.currentRegionCode,
   'PinCode': model.pinCode,
   'Amount': model.amount
  });
  return response;
 }

 getAllFaq<Response>(String regionCode, int page, int pageSize, String category) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"FAQ/GetFAQListwithCategory",
      queryParameters: {"RegionCode": regionCode, "page": page, "pageSize": pageSize, "Category": category});
  return response;
 }

 getDao<Response>(int page, int pageSize, String regionCode, String display) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"AboutDAO/GetAboutDAO",
      queryParameters: {"page": page, "pageSize": pageSize, "RegionCode": regionCode, "Display": display});
  return response;
 }

 getDaoByDeptType<Response>(int page, int pageSize, String regionCode, String deptType) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"AboutDAO/GetAboutDAOByDeptType",
      queryParameters: {"page": page, "pageSize": pageSize, "RegionCode": regionCode, "DeptType": deptType});
  return response;
 }

}


