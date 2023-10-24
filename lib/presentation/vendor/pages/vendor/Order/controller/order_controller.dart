import 'dart:developer';

import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/data/orders/order_details_response.dart';
import 'package:dexter_vendor/data/orders/order_response_model.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class OrderController extends GetxController{
  List<Orders>? confirmedOrderResponseModel = <Orders>[].obs;
  bool? getConfirmOrderLoadingState;
  bool? getConfirmOrderErrorState;

  Future<void> getConfirmedOrder()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    getConfirmOrderLoadingState = true;
    getConfirmOrderErrorState = false;
    confirmedOrderResponseModel = null;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/orders?status=confirmed", method: RequestMethod.get);
      confirmedOrderResponseModel = OrderResponseModel.fromJson(response!.data).data;
      getConfirmOrderLoadingState = false;
      getConfirmOrderErrorState = false;
      // log("done");
      update();
    }on dio.DioError catch (err) {
      getConfirmOrderLoadingState = false;
      getConfirmOrderErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      throw errorMessage;
    } catch (err) {
      getConfirmOrderLoadingState = false;
      getConfirmOrderErrorState = true;
      update();
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      throw err.toString();
    }
  }


  List<Orders>? pendingOrderResponseModel = <Orders>[].obs;
  bool? getPendingOrderLoadingState;
  bool? getPendingOrderErrorState;

  Future<void> getPendingOrder()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    getPendingOrderLoadingState = true;
    getPendingOrderErrorState = false;
    pendingOrderResponseModel = null;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/orders?status=pending", method: RequestMethod.get);
      pendingOrderResponseModel = OrderResponseModel.fromJson(response!.data).data;
      getPendingOrderLoadingState = false;
      getPendingOrderErrorState = false;
      // log("done");
      update();
    }on dio.DioError catch (err) {
      getPendingOrderLoadingState = false;
      getPendingOrderErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      throw errorMessage;
    } catch (err) {
      getPendingOrderLoadingState = false;
      getPendingOrderErrorState = true;
      update();
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      throw err.toString();
    }
  }

  List<Orders>? fulfilledOrderResponseModel = <Orders>[].obs;
  bool? getFulfilledOrderLoadingState;
  bool? getFulfilledOrdersErrorState;
  Future<void> getFulfilledBookings()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    getFulfilledOrderLoadingState = true;
    getFulfilledOrdersErrorState = false;
    fulfilledOrderResponseModel = null;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/orders?status=fulfilled", method: RequestMethod.get);
      fulfilledOrderResponseModel = OrderResponseModel.fromJson(response!.data).data;
      getFulfilledOrderLoadingState = false;
      getFulfilledOrdersErrorState = false;
      update();
    }on dio.DioError catch (err) {
      getFulfilledOrderLoadingState = false;
      getFulfilledOrdersErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      throw errorMessage;
    } catch (err) {
      getFulfilledOrderLoadingState = false;
      getFulfilledOrdersErrorState = true;
      update();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      throw err.toString();
    }
  }

  List<Orders>? completedOrderResponseModel = <Orders>[].obs;
  bool? getCompletedBookingsLoadingState;
  bool? getCompletedBookingsErrorState;
  Future<void> getCompletedBookings()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    getCompletedBookingsLoadingState = true;
    getCompletedBookingsErrorState = false;
    completedOrderResponseModel = null;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/orders?status=completed", method: RequestMethod.get);
      completedOrderResponseModel = OrderResponseModel.fromJson(response!.data).data;
      getCompletedBookingsLoadingState = false;
      getCompletedBookingsErrorState = false;
      update();
    }on dio.DioError catch (err) {
      getCompletedBookingsLoadingState = false;
      getCompletedBookingsErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      throw errorMessage;
    } catch (err) {
      getCompletedBookingsLoadingState = false;
      getCompletedBookingsErrorState = true;
      update();
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      throw err.toString();
    }
  }

  List<Orders>? cancelledOrderResponseModel = <Orders>[].obs;
  bool? getCanceledBookingsLoadingState;
  bool? getCanceledBookingsErrorState;
  Future<void> getCanceledBookings()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    getCanceledBookingsLoadingState = true;
    getCanceledBookingsErrorState = false;
    cancelledOrderResponseModel = null;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/orders?status=cancelled", method: RequestMethod.get);
      cancelledOrderResponseModel = OrderResponseModel.fromJson(response!.data).data;
      getCanceledBookingsLoadingState = false;
      getCanceledBookingsErrorState = false;
      update();
    }on dio.DioError catch (err) {
      getCanceledBookingsLoadingState = false;
      getCanceledBookingsErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      throw errorMessage;
    } catch (err) {
      getCanceledBookingsLoadingState = false;
      getCanceledBookingsErrorState = true;
      update();
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      throw err.toString();
    }
  }


  bool? getOrderDetailsLoadingState;
  bool? getOrderDetailsErrorState;
  OrderDetailsResponse? orderDetailsResponse;
  Future<void> getOrderDetails({required String orderId})async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    getOrderDetailsLoadingState = true;
    getOrderDetailsErrorState = false;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/orders/$orderId", method: RequestMethod.get);
      orderDetailsResponse = OrderDetailsResponse.fromJson(response!.data);
      getOrderDetailsLoadingState = false;
      getOrderDetailsErrorState = false;
      update();
    }on dio.DioError catch (err) {
      getOrderDetailsLoadingState = false;
      getOrderDetailsErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      throw errorMessage;
    } catch (err) {
      getOrderDetailsLoadingState = false;
      getOrderDetailsErrorState = true;
      update();
      throw err.toString();
    }
  }


  Future<dio.Response<dynamic>?> markOrderAsConfirmed({required String orderId}) async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    try{
      final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/orders/$orderId/mark-as-confirmed", method: RequestMethod.post, context: Get.context!);
      // final message =  response?.data["message"];
      return response;
    }on dio.DioError catch (err) {
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

  Future<dio.Response<dynamic>?> markOrderAsFulfilled({required String orderId}) async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    try{
      final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/orders/$orderId/mark-as-fulfilled", method: RequestMethod.post, context: Get.context!);
      // final message =  response?.data["message"];
      return response;
    }on dio.DioError catch (err) {
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
  int currentIndex = 0;

  void changeButtonIndex(int index){
    currentIndex = index;
    update();
  }
}