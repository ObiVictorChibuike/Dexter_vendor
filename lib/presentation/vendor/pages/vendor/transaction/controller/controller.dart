import 'package:dexter_vendor/data/transactions/transactions_response_model.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/app_config.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController{

  List<Datum>? transactionHistoryResponseModel;
  bool? isLoadingTransactionHistory;
  bool? isLoadingTransactionHistoryHasError;
  Future<void> getTransactionsHistory() async {
    isLoadingTransactionHistory = true;
    isLoadingTransactionHistoryHasError = false;
    update();
    try{
      var response = await NetworkProvider().call(path: AppConfig.allTransaction, method: RequestMethod.get, context: null,);
      final resBody = response?.data["data"];
      // transactionHistoryResponseModel = resBody.map<Datum>((datum) => Datum.fromJson(datum)).toList();
      transactionHistoryResponseModel = TransactionHistoryResponseModel.fromJson(response!.data).data;
      isLoadingTransactionHistory = false;
      isLoadingTransactionHistoryHasError = false;
      update();
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      isLoadingTransactionHistory = false;
      isLoadingTransactionHistoryHasError = true;
      update();
      throw errorMessage;
    } catch (err) {
      isLoadingTransactionHistory = false;
      isLoadingTransactionHistoryHasError = true;
      update();
      throw err.toString();
    }
  }
}