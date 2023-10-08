import 'dart:convert';

import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/data/bank/bank_account_response_model.dart';
import 'package:dexter_vendor/data/bank/bank_response_model.dart';
import 'package:dexter_vendor/data/bank/create_bank_account_response_model.dart';
import 'package:dexter_vendor/data/bank/delete_bank_account_response.dart';
import 'package:dexter_vendor/data/bank/update_bank_account%20_response.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/app_config.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/withdraw/controller/controller.dart';
import 'package:dexter_vendor/widget/custom_snack.dart';
import 'package:dexter_vendor/widget/progress_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BankController extends GetxController{
  BankResponse? bankResponse;
  Future<void> getAllBank()async{
    try{
      final response = await NetworkProvider().call(path: AppConfig.banks, method: RequestMethod.get);
      bankResponse = BankResponse.fromJson(response!.data);
      update();
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      throw errorMessage;
    } catch (err) {
      throw err.toString();
    }
  }

  Future<void> refreshBankList({BuildContext? context})async{
    progressIndicator(context);
    try{
      final response = await NetworkProvider().call(path: AppConfig.banks, method: RequestMethod.get);
      bankResponse = BankResponse.fromJson(response!.data);
      update();
      Get.back();
      Get.snackbar("Success", bankResponse?.message ?? "Request Successful", colorText: white, backgroundColor: greenPea);
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      throw errorMessage;
    } catch (err) {
      Get.back();
      throw err.toString();
    }
  }


  bool? onLoadingBankAccountsState;
  bool? onLoadingBankAccountErrorState;

  BankAccountResponse? bankAccountResponse;
  Future<void> getAllBankAccount()async{
    onLoadingBankAccountsState = true;
    onLoadingBankAccountErrorState = false;
    try{
      final response = await NetworkProvider().call(path: AppConfig.banksAccount, method: RequestMethod.get);
      bankAccountResponse = BankAccountResponse.fromJson(response!.data);
      onLoadingBankAccountsState = false;
      onLoadingBankAccountErrorState = false;
      update();
    }on DioError catch (err) {
      onLoadingBankAccountsState = false;
      onLoadingBankAccountErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      throw errorMessage;
    } catch (err) {
      onLoadingBankAccountsState = false;
      onLoadingBankAccountErrorState = true;
      update();
      throw err.toString();
    }
  }

  Future<void> getAllBankAccountNoState()async{
    try{
      final response = await NetworkProvider().call(path: AppConfig.banksAccount, method: RequestMethod.get);
      bankAccountResponse = BankAccountResponse.fromJson(response!.data);
      update();
    }on DioError catch (err) {
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      throw errorMessage;
    } catch (err) {
      update();
      throw err.toString();
    }
  }

  Future<void> deleteBankAccount({required String bankAccountId})async{
    try{
      final response = await NetworkProvider().call(path: "/vendor/bank-accounts/$bankAccountId", method: RequestMethod.delete, context: Get.context);
      final data = DeleteBankAccountResponse.fromJson(response!.data);
      _controller.getAllBankAccount();
      await getAllBankAccountNoState().then((value){
        Get.back();
        Get.snackbar("Success", data.message ?? "Account Successfully Deleted", backgroundColor: greenPea, colorText: white);
        update();
      });
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      throw errorMessage;
    } catch (err) {
      Get.back();
      throw err.toString();
    }
  }

  final _controller = Get.put(WithdrawalController());
  Future<void> addBankAccount(String bankCode, String accountNumber)async{
    try{
      var postBody = jsonEncode({
        "bank_code":  bankCode,
        "account_number": accountNumber,
      });
      final response = await NetworkProvider().call(path: AppConfig.createBankAccount, method: RequestMethod.post, body: postBody, context: Get.context);
      final data = CreateBankAccountResponse.fromJson(response!.data);
      _controller.getAllBankAccount();
      update();
      await getAllBankAccount().then((value){
        Get.back();
        Get.back();
        update();
        Get.snackbar("Success", data.message ?? "Withdrawal Successful", colorText: white, backgroundColor: greenPea);
        update();
      });
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

  Future<void> updateBankAccount(String bankCode, String accountNumber, bankAccountId)async{
    try{
      var postBody = jsonEncode({
        "_method": "patch",
        "bank_code":  bankCode,
        "account_number": accountNumber,
      });
      final response = await NetworkProvider().call(path: "/vendor/bank-accounts/$bankAccountId", method: RequestMethod.post, body: postBody, context: Get.context);
      final data = UpdateBankAccountResponseModel.fromJson(response!.data);
      update();
      await getAllBankAccount().then((value){
        Get.back();
        update();
        Get.snackbar("Success", data.message ?? "Account Updated Successfully", colorText: white, backgroundColor: greenPea);
        update();
      });
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error", err.toString(), colorText: white, backgroundColor: persianRed);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
      update();
      throw err.toString();
    }
  }
}