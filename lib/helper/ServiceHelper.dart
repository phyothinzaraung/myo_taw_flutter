import 'dart:core';
import 'dart:io';
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

 getNewsFeed<Response>({int organizationId, int page, int pageSize, String userUniqueKey}) async{
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
   'Amount': model.amount,
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

 uploadProfilePhoto<Response>(String file, String uniqueKey) async{
  FormData formData = new FormData.from({
   'Uniquekey' : uniqueKey,
   'file' : UploadFileInfo(File(file), 'profilePhoto')
  });
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Account/UserPhotoUpload",
      data: formData);
  return response;
 }

 uploadTaxRecord<Response>(String file, String subject, String uniqueKey, String userName, String regionCode) async{
  FormData formData = new FormData.from({
   'file' : UploadFileInfo(File(file), 'taxRecordPhoto'),
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

 sendSuggestion<Response>(String file, String phoneNo, String subject, String message, String uniqueKey, String userName, String lat, String lng,
     String regionCode) async{
  FormData formData = new FormData.from({
   'file' : UploadFileInfo(File(file), 'suggestionPhoto'),
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
  response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"BizLicense/ApplyBizLicense", data: {
   'BizName' : model.bizName,
   'BizType': model.bizType,
   'Length': model.length,
   'Width': model.width,
   'Area': model.area,
   'BizRegionNo': model.bizRegionNo,
   'BizStreetName': model.bizStreetName,
   'BizBlockNo': model.bizBlockNo,
   'BizTownship': model.bizTownship,
   'BizState': model.bizState,
   'OwnerName': model.ownerName,
   'NRCNo': model.nrcNo,
   'PhoneNo': model.phoneNo,
   'RegionNo': model.regionNo,
   'StreetName': model.streetName,
   'BlockNo': model.blockNo,
   'Township': model.township,
   'State': model.state,
   'Remark': model.remark,
   'UniqueKey': model.uniqueKey,
   'RegionCode': model.regionCode,
   'UserName': model.userName,
   'LicenseType': model.licenseType,
   'LicenseTypeID': model.licensetypeId,
  });
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
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"BizLicense/ApplyBizPhotosList",
      queryParameters: {"ID": id});
  return response;
 }

 uploadApplyBizPhoto<Response>(String file, String appBizId, String title) async{
  FormData formData = new FormData.from({
   'file' : UploadFileInfo(File(file), 'applyBizPhoto'),
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
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_DAO_INVOICE_NO+"CustomerData/GetAmountFromInvoice",
      queryParameters: {"TaxType": taxType,"InvoiceNo": invoiceNo});
  return response;
 }

 postPayment<Response>(PaymentLogModel model) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_TAX_PAYMENT+"Payment/PayBill", data: {
   'UniqueKey' : model.uniqueKey,
   'UseAmount': model.useAmount,
   'TaxType': model.taxType,
   'InvoiceNo': model.invoiceNo,
  });
  return response;
 }

 postReferral<Response>(ReferralModel model) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  response = await dio.post(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_REFERRAL+"ref/RefQRcodeCityApp", data: {
   'ReferralPhoneNumber' : model.referPhNo,
   'UserPhoneNumber': model.userPhNo,
   'ReferDate': model.referDate,
   'IMEI': model.imei,
   'Application': model.application,
  });
  return response;
 }

 getSmartWaterMeterUnit<Response>(String phoneNo) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  _interceptor();
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS_DAO_INVOICE_NO+"SmartWaterMeter/GetSmartMeterData",
      queryParameters: {"PhoneNo": phoneNo});
  return response;
 }

 getSmartWaterMeterLog<Response>(String phoneNo) async{
  dio.options.connectTimeout = conTimeOut;
  dio.options.receiveTimeout = conTimeOut;
  _interceptor();
  response = await dio.get(BaseUrl.WEB_SERVICE_ROOT_ADDRESS+"Payment/SmartMeterPaymentLogWithUserAmount",
      queryParameters: {"PhoneNo": phoneNo});
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

}


