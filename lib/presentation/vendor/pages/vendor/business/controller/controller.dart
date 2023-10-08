import 'dart:developer';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/data/business/update_business_model_response.dart';
import 'package:dexter_vendor/widget/custom_snack.dart';
import 'package:dio/dio.dart'as dio;
import 'package:dexter_vendor/data/business/business_images_response.dart';
import 'package:dexter_vendor/data/business/business_response_model.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BusinessController extends GetxController{
  XFile? coverPhoto;
  final picker = ImagePicker();
  void onUploadCoverPhoto(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      coverPhoto = pickedFile;
      update();
    } catch (e) {
      final pickImageError = e;
      update();
    }
  }
  BusinessResponseModel? businessResponseModel;
  bool? getBusinessLoadingState;
  bool? getBusinessErrorState;

  Future<void> getABusiness()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final businessResponse = await LocalCachedData.instance.getBusinessResponse();
    final businessId = businessResponse?.data?.id;
    getBusinessLoadingState = true;
    getBusinessErrorState = false;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/businesses/$businessId", method: RequestMethod.get);
      businessResponseModel = BusinessResponseModel.fromJson(response!.data);
      update();
      await getBusinessImages();
      // log("done");
    }on DioError catch (err) {
      getBusinessLoadingState = false;
      getBusinessErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      throw errorMessage;
    } catch (err) {
      getBusinessLoadingState = false;
      getBusinessErrorState = true;
      update();
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      throw err.toString();
    }
  }

  BusinessImagesResponseModel? businessImagesResponseModel;
  Future<void> getBusinessImages() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final businessResponse = await LocalCachedData.instance.getBusinessResponse();
    final businessId = businessResponse?.data?.id;
    try{
      var response = await NetworkProvider().call(path: "/vendor/businesses/$businessId/images", method: RequestMethod.get, context: null,);
      final value = BusinessImagesResponseModel.fromJson(response!.data);
      await LocalCachedData.instance.cacheBusinessImages(businessImagesResponseModel: value);
      businessImagesResponseModel = value;
      getBusinessLoadingState = false;
      getBusinessErrorState = false;
      update();
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      update();
      throw err.toString();
    }
  }

  XFile? photo1;
  XFile? photo2;
  XFile? photo3;
  XFile? photo4;
  XFile? businessServiceSampleImages;

  void onUploadBusinessServiceSampleImages(ImageSource source, int index) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      businessServiceSampleImages = pickedFile;
      if(index == 0){
        photo1 = businessServiceSampleImages;
        update();
      }else if(index == 1){
        photo2 = businessServiceSampleImages;
        update();
      }else if(index == 2){
        photo3 = businessServiceSampleImages;
        update();
      }else{
        photo4 = businessServiceSampleImages;
        update();
      }
      update();
    } catch (e) {
      final pickImageError = e;
      log(pickImageError.toString());
      update();
    }
  }

  Future<void> updateBusiness({required String? name, required String? biography, required XFile? coverImage,
    required String? openingTime, required String? closingTime, required String? contactAddress, required String? contactEmail,
    required String? contactPhone, required double? latitude, required double? longitude, required String? serviceId,
    required String? serviceCharge, required List<XFile>? businessImages}) async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final businessResponse = await LocalCachedData.instance.getBusinessResponse();
    final businessId = businessResponse?.data?.id;
    final file = coverImage == null ? null : await dio.MultipartFile.fromFile(
      coverImage.path,
      filename: coverImage.name,
    );
    try{
      var postBody = dio.FormData.fromMap({
        "_method": "patch",
        "name": name,
        "biography": biography,
        "cover_image": file,
        "opening_time": openingTime,
        "closing_time": closingTime,
        "contact_address": contactAddress,
        "contact_email": contactEmail,
        "contact_phone": contactPhone,
        "latitude": latitude,
        "longitude": longitude,
        "service_id": serviceId,
        "service_charge": serviceCharge,
        "business_images": businessImages == [] ? [] : [
          for (var file in businessImages!)
            {await dio.MultipartFile.fromFile(file.path, filename: 'fileName')}.toList()
        ],
      });
      var response = await NetworkProvider().call(path: "/vendor/businesses/$businessId", method: RequestMethod.post, body: postBody, context: Get.context);
      final payLoad = BusinessResponseModel.fromJson(response!.data);
      await LocalCachedData.instance.cacheBusinessResponse(businessResponse: payLoad);
      await getABusiness();
      Get.back();
      Get.back();
      Get.back();
      Get.snackbar("Success", payLoad.message ?? "Business updated successfully", colorText: white, backgroundColor: greenPea);
    }on dio.DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: persianRed);
      update();
      throw errorMessage;
    } catch (err) {
      if(err.toString() == "Request Entity Too Large"){
        Get.back();
        Get.snackbar("Error", "Image sizes are too large", colorText: white, backgroundColor: persianRed);
        update();
      }else{
        Get.back();
        Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
        update();
      }
      throw err.toString();
    }
  }
}