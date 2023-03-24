import 'package:get/get.dart';

class AuthStatus{
  final String successful = 'successful';
  final String failedInternet = 'network-request-failed';
  final String wrongPassword = 'wrongPassword'.tr;
  final String emailAlreadyExists = 'emailAlreadyExists'.tr;
  final String userNotFound = 'userNotFound'.tr;
  final String invalidEmail = 'invalidEmail'.tr;
  final String weakPassword = 'weakPassword'.tr;
  final String networkRequestFailed = 'networkRequestFailed'.tr;
  final String tooManyRequests = 'tooManyRequests'.tr;
  final String unknown = 'unknown'.tr;

  String getAuthStatus(String status){
    switch(status){
      case 'successful': return successful;
      case 'wrong-password': return wrongPassword;
      case 'email-already-in-use': return emailAlreadyExists;
      case 'user-not-found': return userNotFound;
      case 'invalid-email': return invalidEmail;
      case 'weak-password': return weakPassword;
      case 'network-request-failed': return networkRequestFailed;
      case 'too-many-requests': return tooManyRequests;
      default : return unknown+status;

    }
  }




}