import 'dart:convert';

import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/data/bank/bank_account_response_model.dart';
import 'package:dexter_vendor/data/withdrawal/withdrawal_response.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/app_config.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor_overview/vendor_overview.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class WithdrawalController extends GetxController{
  BankAccountResponse? bankAccountResponse;
  Future<void> getAllBankAccount()async{
    try{
      final response = await NetworkProvider().call(path: AppConfig.banksAccount, method: RequestMethod.get);
      bankAccountResponse = BankAccountResponse.fromJson(response!.data);
      update();
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      throw errorMessage;
    } catch (err) {
      Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      throw err.toString();
    }
  }
 HomeController homeController = Get.put(HomeController());

  Future<WithdrawalResponse> withdrawFunds(String amount, String bankAccountId)async{
    try{
      var postBody = jsonEncode({
        "amount":  amount,
        "bank_account_id": bankAccountId,
      });
      final response = await NetworkProvider().call(path: AppConfig.withdrawal, method: RequestMethod.post, body: postBody, context: Get.context);
      final value = WithdrawalResponse.fromJson(response!.data);
      await homeController.getVendorProfile();
      return value;
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: persianRed);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
      update();
      throw err.toString();
    }
  }

  @override
  void onInit() {
    getAllBankAccount();
    super.onInit();
  }
}
