/*
Created by yeyint 31/7/2019*/

class NumConvertHelper{

   static String getMyanNumInt(int num){
    String str = num.toString();
    String myanNum = '';
    for(int i=0;i<str.length; i++){
      if(str[i] == '1'){
        myanNum += '၁';
      }else if(str[i] == '2'){
        myanNum += '၂';
      }else if(str[i] == '3'){
        myanNum += '၃';
      }else if(str[i] == '4'){
        myanNum += '၄';
      }else if(str[i] == '5'){
        myanNum += '၅';
      }else if(str[i] == '6'){
        myanNum += '၆';
      }else if(str[i] == '7'){
        myanNum += '၇';
      }else if(str[i] == '8'){
        myanNum += '၈';
      }else if(str[i] == '9'){
        myanNum += '၉';
      }else if(str[i] == '0'){
        myanNum += '၀';
      }else if(str[i] == ','){
        myanNum += ',';
      }else{
        myanNum += str[i];
      }
    }
    return myanNum;
  }

   static String getMyanNumString(String num){
    String str = num.toString();
    String myanNum = '';
    for(int i=0;i<str.length; i++){
      if(str[i] == '1'){
        myanNum += '၁';
      }else if(str[i] == '2'){
        myanNum += '၂';
      }else if(str[i] == '3'){
        myanNum += '၃';
      }else if(str[i] == '4'){
        myanNum += '၄';
      }else if(str[i] == '5'){
        myanNum += '၅';
      }else if(str[i] == '6'){
        myanNum += '၆';
      }else if(str[i] == '7'){
        myanNum += '၇';
      }else if(str[i] == '8'){
        myanNum += '၈';
      }else if(str[i] == '9'){
        myanNum += '၉';
      }else if(str[i] == '0'){
        myanNum += '၀';
      }else if(str[i] == ','){
        myanNum += ',';
      }else{
        myanNum += str[i];
      }
    }
    return myanNum;
  }

   static String getMyanNumDou(double num){
    String str = num.toString();
    String myanNum = '';
    for(int i=0;i<str.length; i++){
      if(str[i] == '1'){
        myanNum += '၁';
      }else if(str[i] == '2'){
        myanNum += '၂';
      }else if(str[i] == '3'){
        myanNum += '၃';
      }else if(str[i] == '4'){
        myanNum += '၄';
      }else if(str[i] == '5'){
        myanNum += '၅';
      }else if(str[i] == '6'){
        myanNum += '၆';
      }else if(str[i] == '7'){
        myanNum += '၇';
      }else if(str[i] == '8'){
        myanNum += '၈';
      }else if(str[i] == '9'){
        myanNum += '၉';
      }else if(str[i] == '0'){
        myanNum += '၀';
      }else if(str[i] == '.'){
        myanNum += '.';
      }else if(str[i] == ','){
        myanNum += ',';
      }else{
        myanNum += str[i];
      }
    }
    return myanNum;
  }


}
