import 'dart:convert';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/app_config.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dexter_vendor/presentation/auth/reset_password/pages/reset_password.dart';
import 'package:dexter_vendor/widget/custom_snack.dart';
import 'package:dexter_vendor/widget/progress_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordResetController extends GetxController{

  bool? isSuccessFul;
  final emailController = TextEditingController();
  final verificationCode = TextEditingController();
  Future<void> confirmResetPasswordEmail({required String email, required BuildContext context}) async {
    try{
      var postBody = jsonEncode({
        "email": email,
      });
      final response = await NetworkProvider().call(path: AppConfig.confirmResetPasswordEmail, method: RequestMethod.post, body: postBody, context: Get.context!);
     final message =  response?.data["message"];
     isSuccessFul = true;
     update();
     Get.back();
     Get.snackbar("Success", message, colorText: white, backgroundColor: greenPea);
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      isSuccessFul = false;
      update();
      Get.back();
      Get.snackbar("Error",err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: persianRed);
      update();
      throw errorMessage;
    } catch (err) {
      isSuccessFul = false;
      update();
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
      throw err.toString();
    }
  }

  Future<void> confirmResetPasswordToken({required String email,required String token, required BuildContext context}) async {
    try{
      var postBody = jsonEncode({
        "token": token,
        "email": email,
      });
      final response = await NetworkProvider().call(path: AppConfig.confirmResetPasswordToken, method: RequestMethod.post, body: postBody, context: Get.context!);
      final message =  response?.data["message"];
      Get.back();
      Get.offAll(()=>ResetPassword());
      Get.snackbar("Success", message, backgroundColor: greenPea, colorText: white);
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: persianRed);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
      throw err.toString();
    }
  }

  Future<void> resetPassword({required String email,required String token, required String password, required String confirmPassword, required BuildContext context}) async {
    try{
      var postBody = jsonEncode({
        "token": token,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword
      });
      final response = await NetworkProvider().call(path: AppConfig.confirmResetPasswordToken, method: RequestMethod.post, body: postBody, context: Get.context!);
      final message =  response?.data["message"];
      Get.back();
      Get.snackbar("Success", message, backgroundColor: greenPea, colorText: white);
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: persianRed);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
      throw err.toString();
    }
  }
}