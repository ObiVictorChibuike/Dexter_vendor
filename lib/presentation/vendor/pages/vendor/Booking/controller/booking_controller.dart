import 'dart:convert';
import 'dart:developer';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/data/bookings/booking_details_response.dart';
import 'package:dexter_vendor/data/bookings/booking_response_model.dart';
import 'package:dexter_vendor/data/business/business_response_model.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/business/controller/controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class BookingController extends GetxController{
  List<Bookings>? pendingBookingsResponseModel = <Bookings>[].obs;
  bool? getPendingBookingsLoadingState;
  bool? getPendingBookingsErrorState;

  Future<void> getPendingBookings()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final businessResponse = await LocalCachedData.instance.getBusinessResponse();
    final businessId = businessResponse?.data?.id;
    getPendingBookingsLoadingState = true;
    getPendingBookingsErrorState = false;
    pendingBookingsResponseModel = null;
    log(getPendingBookingsLoadingState.toString());
    log(getPendingBookingsErrorState.toString());
    log("1");
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/businesses/$businessId/bookings?status=pending", method: RequestMethod.get);
      pendingBookingsResponseModel = BookingResponseModel.fromJson(response!.data).data;
      getPendingBookingsLoadingState = false;
      getPendingBookingsErrorState = false;
      log(getPendingBookingsLoadingState.toString());
      log(getPendingBookingsErrorState.toString());
      log(pendingBookingsResponseModel.toString());
      log("2");
      update();
    }on dio.DioError catch (err) {
      getPendingBookingsLoadingState = false;
      getPendingBookingsErrorState = true;
      log(getPendingBookingsLoadingState.toString());
      log(getPendingBookingsErrorState.toString());
      log("3");
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      throw errorMessage;
    } catch (err) {
      getPendingBookingsLoadingState = false;
      getPendingBookingsErrorState = true;
      log(getPendingBookingsLoadingState.toString());
      log(getPendingBookingsErrorState.toString());
      log("4");
      update();
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      throw err.toString();
    }
  }

  List<Bookings>? confirmedBookingsResponseModel = <Bookings>[].obs;
  bool? getConfirmedBookingsLoadingState;
  bool? getConfirmedBookingsErrorState;
  Future<void> getConfirmedBookings()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final businessResponse = await LocalCachedData.instance.getBusinessResponse();
    final businessId = businessResponse?.data?.id;
    getConfirmedBookingsLoadingState = true;
    getConfirmedBookingsErrorState = false;
    confirmedBookingsResponseModel = null;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/businesses/$businessId/bookings?status=confirmed", method: RequestMethod.get);
      confirmedBookingsResponseModel = BookingResponseModel.fromJson(response!.data).data;
      getConfirmedBookingsLoadingState = false;
      getConfirmedBookingsErrorState = false;
      update();
    }on dio.DioError catch (err) {
      getConfirmedBookingsLoadingState = false;
      getConfirmedBookingsErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      throw errorMessage;
    } catch (err) {
      getConfirmedBookingsLoadingState = false;
      getConfirmedBookingsErrorState = true;
      update();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      throw err.toString();
    }
  }

  List<Bookings>? fulfilledBookingsResponseModel = <Bookings>[].obs;
  bool? getFulfilledBookingsLoadingState;
  bool? getFulfilledBookingsErrorState;
  Future<void> getFulfilledBookings()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final businessResponse = await LocalCachedData.instance.getBusinessResponse();
    final businessId = businessResponse?.data?.id;
    getFulfilledBookingsLoadingState = true;
    getFulfilledBookingsErrorState = false;
    fulfilledBookingsResponseModel = null;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/businesses/$businessId/bookings?status=fulfilled", method: RequestMethod.get);
      fulfilledBookingsResponseModel = BookingResponseModel.fromJson(response!.data).data;
      getFulfilledBookingsLoadingState = false;
      getFulfilledBookingsErrorState = false;
      update();
    }on dio.DioError catch (err) {
      getFulfilledBookingsLoadingState = false;
      getFulfilledBookingsErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      throw errorMessage;
    } catch (err) {
      getFulfilledBookingsLoadingState = false;
      getFulfilledBookingsErrorState = true;
      update();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      throw err.toString();
    }
  }


  List<Bookings>? completedBookingsResponseModel = <Bookings>[].obs;
  bool? getCompletedBookingsLoadingState;
  bool? getCompletedBookingsErrorState;
  Future<void> getCompletedBookings()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final businessResponse = await LocalCachedData.instance.getBusinessResponse();
    final businessId = businessResponse?.data?.id;
    getCompletedBookingsLoadingState = true;
    getCompletedBookingsErrorState = false;
    completedBookingsResponseModel = null;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/businesses/$businessId/bookings?status=completed", method: RequestMethod.get);
      completedBookingsResponseModel = BookingResponseModel.fromJson(response!.data).data;
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

  List<Bookings>? cancelledBookingsResponseModel = <Bookings>[].obs;
  bool? getCanceledBookingsLoadingState;
  bool? getCanceledBookingsErrorState;
  Future<void> getCanceledBookings()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final businessResponse = await LocalCachedData.instance.getBusinessResponse();
    final businessId = businessResponse?.data?.id;
    getCanceledBookingsLoadingState = true;
    getCanceledBookingsErrorState = false;
    cancelledBookingsResponseModel = null;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/businesses/$businessId/bookings?status=cancelled", method: RequestMethod.get);
      cancelledBookingsResponseModel = BookingResponseModel.fromJson(response!.data).data;
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

  final _controller = Get.put(BusinessController());
  bool? getBookingDetailsLoadingState;
  bool? getBookingDetailsErrorState;
  BookingDetailsResponse? bookingDetailsResponse;
  BusinessResponseModel? businessResponseModel;
  Future<void> getBookingDetails({required String bookingId})async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    businessResponseModel = await LocalCachedData.instance.getBusinessResponse();
    final businessId = businessResponseModel?.data?.id;
    getBookingDetailsLoadingState = true;
    getBookingDetailsErrorState = false;
    update();
      await _controller.getABusiness();
    try{
      final response = await NetworkProvider().call(path: "/vendor/businesses/$businessId/bookings/$bookingId", method: RequestMethod.get);
      bookingDetailsResponse = BookingDetailsResponse.fromJson(response!.data);
      getBookingDetailsLoadingState = false;
      getBookingDetailsErrorState = false;
      update();
    }on dio.DioError catch (err) {
      getBookingDetailsLoadingState = false;
      getBookingDetailsErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      throw errorMessage;
    } catch (err) {
      getBookingDetailsLoadingState = false;
      getBookingDetailsErrorState = true;
      update();
      throw err.toString();
    }
  }

  Future<dio.Response<dynamic>?> confirmBooking({required String amount, required String date, required String bookingId}) async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    businessResponseModel = await LocalCachedData.instance.getBusinessResponse();
    final businessId = businessResponseModel?.data?.id;
    try{
      var postBody = jsonEncode({
        "amount": amount,
        "scheduled_date": date,
      });
      final response = await NetworkProvider().call(path: "/vendor/businesses/$businessId/bookings/$bookingId/mark-as-confirmed", method: RequestMethod.post, body: postBody, context: Get.context!);
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

  Future<dio.Response<dynamic>?> markBookingAsDelivered({required String bookingId}) async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    businessResponseModel = await LocalCachedData.instance.getBusinessResponse();
    final businessId = businessResponseModel?.data?.id;
    try{
      final response = await NetworkProvider().call(path: "/vendor/businesses/$businessId/bookings/$bookingId/mark-as-fulfilled", method: RequestMethod.post, context: Get.context!);
      final message =  response?.data["message"];
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