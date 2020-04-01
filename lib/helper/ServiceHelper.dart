import 'dart:core';
import 'package:dio/dio.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/model/UserModel.dart';
import 'package:myotaw/model/ApplyBizLicenseModel.dart';
import 'package:myotaw/model/PaymentLogModel.dart';
import 'package:myotaw/model/ReferralModel.dart';

class ServiceHelper{
 var response;
 final Dio dio = new Dio();
 int conTimeOut = 60000;

 getNewsFeed<Response>(int organizationId, int page, int pageSize, String userUniqueKey) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_NEWSFEED+"newsfeedposted/getcitynewsfeedver3",
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
   response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Account/UpdateUser", data: model.toJson());
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

 uploadProfilePhoto<Response>(String file, String uniqueKey) async{
  FormData formData = new FormData.fromMap({
   'Uniquekey' : uniqueKey,
   'file' : await MultipartFile.fromFile(file, filename: 'profilePhoto')
  });
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Account/UserPhotoUpload",
      data: formData);
  return response;
 }

 uploadTaxRecord<Response>(String file, String subject, String uniqueKey, String userName, String regionCode) async{
  FormData formData = new FormData.fromMap({
   'file' : await MultipartFile.fromFile(file,filename: 'taxRecordPhoto'),
   'Subject' : subject,
   'Uniquekey' : uniqueKey,
   'UserName' : userName,
   'RegionCode' : regionCode,
  });
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"TaxRecord/UpSertTaxRecordWithPhoto",
      data: formData);
  return response;
 }

 sendSuggestion<Response>(String file, String phoneNo, String subject, String message,
     String uniqueKey, String userName, double lat, double lng, String regionCode, bool isAdmin, String wardName, double floodLevel) async{
  FormData formData = new FormData.fromMap({
   'file' : await MultipartFile.fromFile(file,filename: subject),
   'UserPhoneNo' : phoneNo,
   'Subject' : subject,
   'Message' : message,
   'UniqueKey' : uniqueKey,
   'UserName' : userName,
   'Latitude' : lat,
   'Longitude' : lng,
   'RegionCode' : regionCode,
   'IsRead' : false,
   'Fixed' : false,
   'Source' : 'app',
   'IsWardAdmin' : isAdmin,
   'WardName' : wardName,
   'FloodLevel' : floodLevel
  });
   dio.options.connectTimeout = conTimeOut;
   dio.options.receiveTimeout = conTimeOut;
   response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Contribute/UpSertContributeWithPhoto",
       data: formData);
   return response;
 }

 getBizLicense<Response>(String regionCode) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"BizLicense/GetBizLicenseList",
      queryParameters: {"RegionCode": regionCode});
  return response;
 }

 postApplyBizLicense<Response>(ApplyBizLicenseModel model) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"BizLicense/ApplyBizLicense", data: model.toJson());
  return response;
 }

 getAllApplyBizLicenseByUser<Response>(String regionCode, String uniqueKey) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"BizLicense/GetApplyBizLicensesByUser",
      queryParameters: {"RegionCode": regionCode, "UniqueKey" : uniqueKey});
  return response;
 }

 getApplyBizPhotoList<Response>(int id) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"BizLicense/ApplyBizPhotosListForFlutter",
      queryParameters: {"ID": id});
  return response;
 }

 uploadApplyBizPhoto<Response>(String file, String appBizId, String title) async{
  FormData formData = new FormData.fromMap({
   'file' : await MultipartFile.fromFile(file,filename: 'applyBizPhoto'),
   'ApBizID' : appBizId,
   'Title' : title,
  });
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"BizLicense/ApplyBizPhotosUpload",
      data: formData);
  return response;
 }

 getTaxUser<Response>(String regionCode, String budgetYear) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Expenditure/GetExpenditureList",
      queryParameters: {"RegionCode": regionCode, "BudgetYear" :  budgetYear});
  return response;
 }

 getUserBillAmount<Response>(String uniqueKey) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Payment/GetPurchaseListByUserForMyoTaw",
      queryParameters: {"UniqueKey": uniqueKey});
  return response;
 }

 getTopUp<Response>(String code,String uniqueKey) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Payment/TopUpFromAndroid",
      queryParameters: {"PaymentCode": code,"UniqueKey": uniqueKey});
  return response;
 }

 _interceptor(){
  dio.interceptors.add(InterceptorsWrapper(
      onRequest: (Options options) async{
       options.headers["APIKey"] = MyString.API_KEY;
      }
  ));
 }

 getAmountFromInvoiceNo<Response>(String taxType,String invoiceNo) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  _interceptor();
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_DAO_INVOICE_NO+"CustomData/GetAmountFromInvoice",
      queryParameters: {"TaxType": taxType,"InvoiceNo": invoiceNo});
  return response;
 }

 postPayment<Response>(PaymentLogModel model) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_TAX_PAYMENT+"Payment/PayBill", data: model.toJson());
  return response;
 }

 postReferral<Response>(ReferralModel model) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_REFERRAL+"ref/RefQRcodeCityApp", data: model.toJson());
  return response;
 }

 getSmartWaterMeterUnit<Response>(String meterNo) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  _interceptor();
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_DAO_INVOICE_NO+"SmartWaterMeter/GetFinalUnit",
      queryParameters: {"MeterNo": meterNo});
  return response;
 }

 getSmartWaterMeterLog<Response>(String meterNo) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  _interceptor();
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Payment/GetPaymentLog",
      queryParameters: {"MeterNo": meterNo});
  return response;
 }

 getOtpCode<Response>(String phoneNo, String key) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_OTP+"smsverification/requestCodeMyoTaw",
      queryParameters: {"phone": phoneNo, "hashkey" : key});
  return response;
 }

 verifyOtp<Response>(String phoneNo, String code) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_OTP+"smsverification/verifyCodemyotaw",
      queryParameters: {"phone": phoneNo, "code" : code});
  return response;
 }

 getUserInfo<Response>(String uniqueKey) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Account/GetUser",
      queryParameters: {"Uniquekey": uniqueKey});
  return response;
 }

 getContributionList<Response>(String regionCode, int page, int pageSize, String uniqueKey) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Contribute/GetContributeListByAdminId",
      queryParameters: {"RegionCode": regionCode, "page": page, "pageSize": pageSize, 'UniqueKey' : uniqueKey});
  return response;
 }

 getTopUpLogList<Response>(String meterNo) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Payment/GetTopUpLogByMyoTawApp",
      queryParameters: {"MeterNo": meterNo});
  return response;
 }

 getFloodLevelReportList<Response>(String regionCode, String uniqueKey) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Contribute/GetFloodListByUser",
      queryParameters: {"RegionCode": regionCode, "UniqueKey": uniqueKey});
  return response;
 }

 updateUserActiveTime<Response>(String uniqueKey) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Account/UpdateActiveTime",
      queryParameters: {"UniqueKey": uniqueKey});
  return response;
 }

 updateUserToken<Response>(String uniqueKey, String token, String type) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Account/UserTokenUpdate",
      queryParameters: {"UniqueKey": uniqueKey ,"Token": token ,"Type": type});
  return response;
 }

 getNotification<Response>(String regionCode,String uniqueKey) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Notification/GetNotificationListForAndroid",
      queryParameters: {"RegionCode":regionCode, "UniqueKey":uniqueKey});
  return response;
 }

}


