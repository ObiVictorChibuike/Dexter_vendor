
import 'dart:developer';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/core/state/view_state.dart';
import 'package:dexter_vendor/data/bookings/booking_response_model.dart';
import 'package:dexter_vendor/data/notification/notification_response.dart';
import 'package:dexter_vendor/data/orders/order_response_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart'as auth;
import 'package:dexter_vendor/data/vendor_model/update_vendor_profile_response.dart';
import 'package:dexter_vendor/data/vendor_model/vendor_profile_response.dart';
import 'package:dexter_vendor/presentation/intro/page/onboarding_screen.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor_overview/vendor_overview.dart';
import 'package:dexter_vendor/widget/progress_indicator.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dexter_vendor/datas/model/vendor/vendor_shop_response.dart';
import 'package:dexter_vendor/datas/repository/user_repository/user_repository.dart';
import 'package:dexter_vendor/datas/repository/vendor_repository/vendor_repository.dart';
import 'package:dexter_vendor/datas/services/user_services/user_services.dart';
import 'package:dexter_vendor/datas/services/vendor_services/vendor_services.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/app_config.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dexter_vendor/domain/repository/user/update_user_impl.dart';
import 'package:dexter_vendor/domain/repository/user/user_repository_impl.dart';
import 'package:dexter_vendor/domain/repository/vendor_repository/get_a_shop_impl.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController{
  final updateUser = Get.put(UpdateUserImpl(UserRepository(UserServices())));
  final user = Get.put(UserRepositoryImpl(UserRepository(UserServices())));

  ViewState<UpdateVendorProfileResponse> updateUserProfileViewState = ViewState(state: ResponseState.EMPTY);

  void _setUpdateUserProfileViewState(ViewState<UpdateVendorProfileResponse> updateUserProfileViewState) {
    this.updateUserProfileViewState = updateUserProfileViewState;
  }

  ViewState<VendorProfileResponse> userDataViewState = ViewState(state: ResponseState.EMPTY);

  void _setUserDataViewState(ViewState<VendorProfileResponse> userDataViewState) {
    this.userDataViewState = userDataViewState;
  }

  ViewState<VendorShopResponse> getVendorShopViewState = ViewState(state: ResponseState.EMPTY);

  void _setVendorShopViewState(ViewState<VendorShopResponse> getVendorShopViewState) {
    this.getVendorShopViewState = getVendorShopViewState;
  }

  RxInt selectedIndex = 0.obs;

  void moveToBooking(){
    Get.offAll(()=>VendorOverView());
    selectedIndex.value = 1;
    update();
  }

  void moveToChat(){
    // Get.offAll(()=>VendorOverView());
    selectedIndex.value = 2;
    update();
  }
  String? errorMessage;
  bool? serviceStatus;

  void changeIndex(int index){
    selectedIndex.value = index;
    update();
  }

  int enableNotificationPromptCount = 0;

  VendorProfileResponse? vendorProfileResponse;

  Future<void> getVendorProfile() async {
    try{
      var response = await NetworkProvider().call(path: AppConfig.user, method: RequestMethod.get, context: null,);
      vendorProfileResponse = VendorProfileResponse.fromJson(response!.data);
      update();
      await LocalCachedData.instance.cacheShopId(shopId: vendorProfileResponse?.data?.shop?.id);
      await LocalCachedData.instance.cacheVendorProfile(vendorProfileResponse: vendorProfileResponse!);
      update();
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.response?.data['message'] ?? errorMessage);
      update();
      throw errorMessage;
    } catch (err) {
      // Get.back();
      // showErrorSnackBar(Get.context,
      //     title: "Something Went Wrong",
      //     content: err.toString());
      update();
      throw err.toString();
    }
  }

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


  final vendorType = [
    {
      "assets": AssetPath.plug,
      "title": "Electric Repair"
    },
    {
      "assets": AssetPath.iron,
      "title": "Laundry"
    },
    {
      "assets": AssetPath.food,
      "title": "Food Delivery"
    },
    {
      "assets": AssetPath.makeUp,
      "title": "Make up"
    },
    {
      "assets": AssetPath.plumber,
      "title": "Plumbing"
    },
    {
      "assets": AssetPath.grocery,
      "title": "Grocery Shopping"
    },
    {
      "assets": AssetPath.fashion,
      "title": "Fashion Designer"
    },
    {
      "assets": AssetPath.hairStylist,
      "title": "Hair Stylist"
    },
  ];

  final notification = [
    {
      "assets": AssetPath.notification,
      "title": "Reminder",
      "body": "Fan Repair Inspection is scheduled for tomorrow",
      "duration": "13min"
    },
    {
      "assets": AssetPath.image,
      "title": "New Message",
      "body": "“Hey! I looked your problem and it’s fixed\n3 now. Can you confirm?”",
      "duration": "1hr"
    },
    {
      "assets": AssetPath.verified,
      "title": "Order Confirmed",
      "body": "Your Vehicle - Mini Van Order is successfully \nplaced.",
      "duration": "1hr"
    },

  ];

  Future<void> updateUserProfile(String firstName, lastName, email)async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final regResponse = await LocalCachedData.instance.getRegistrationResponse();
    await updateUser.execute(params: UpdateUserProfileParam(firstName, lastName, email, regResponse.data?.user?.phone ?? "")).then((value) async {
      if(value is DataSuccess || value.data != null) {
        await getUser();
        _setUpdateUserProfileViewState(ViewState.complete(value.data!));
        // updateUserResponse = value.data;
        update();
      }
      if (value is DataFailed || value.data == null) {
        if (kDebugMode) {
          print(value.error.toString());
        }
        errorMessage = value.error.toString();
        _setUpdateUserProfileViewState(ViewState.error(value.error.toString()));
        update();
      }}
    );
  }

  Future<void> getUser()async{
    await user.noParamCall().then((value) async {
      if(value is DataSuccess || value.data != null) {
        authUserResponse = value.data;
        await LocalCachedData.instance.cacheVendorProfile(vendorProfileResponse: value.data!);
        update();
      }
      if (value is DataFailed || value.data == null) {
        if (kDebugMode) {
          print(value.error.toString());
        }
        errorMessage = value.error.toString();
        _setUserDataViewState(ViewState.error(value.error.toString()));
        update();
      }}
    );
  }

  VendorProfileResponse? authUserResponse;

  Future<void> onInitializeLocalStorage() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    await LocalCachedData.instance.getVendorProfile().then((value){
      authUserResponse = value;
      update();
      super.onInit();
    });
  }

  final getVendorShop = Get.put(GetAShopImpl(VendorRepository(VendorServices())));
  VendorShopResponse? vendorShopResponse;
  Future<void> getAShop() async {
    _setVendorShopViewState(ViewState.loading());
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    await getVendorShop.execute(params: GetVendorShopParam(shopId.toString())).then((value) async {
      if(value is DataSuccess || value.data != null) {
        vendorShopResponse = value.data;
        // await LocalCachedData.instance.cacheCreateShopResponse(createShopResponse: value!.data!);
        update();
        _setVendorShopViewState(ViewState.complete(value.data!));
        update();
      }if (value is DataFailed || value.data == null) {
        if (kDebugMode) {
          print(value.error);
        }errorMessage = value.error.toString();
        _setVendorShopViewState(ViewState.error(value.error.toString()));
        update();
      }}
    );
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly'
      ]
  );
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  Future<void> SignOut() async {
    if (_googleSignIn.currentUser != null){
      await _googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
    } else{
      await FirebaseAuth.instance.signOut();}
  }

  Future<void> logOut({required BuildContext context}) async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    try{
      await deleteFcmTokenDuringSignOUt();
      await NetworkProvider().call(path: "/vendor/logout", method: RequestMethod.delete, context: Get.context);
        final sharedPreferences = await SharedPreferences.getInstance();
        await LocalCachedData.instance.clearCache();
        await LocalCachedData.instance.onLogout();
        await SignOut();
        await LocalCachedData.instance.cacheLoginStatus(isLoggedIn: false);
        sharedPreferences.clear();
        Get.back();
        Get.offUntil(MaterialPageRoute(builder: (context) => OnBoardingScreen()), (Route<dynamic> route) => false);
    }on dio.DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: persianRed);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.snackbar("Something Went Wrong",  err.toString(), colorText: white, backgroundColor: persianRed);
      update();
      throw err.toString();
    }
  }

  NotificationResponse? notificationResponse;
  int notificationLength = 0;
  bool? isLoadingNotification;
  bool? isLoadingNotificationHasError;

  Future<void> getNotification()async{
    isLoadingNotification = true;
    isLoadingNotificationHasError = false;
    try{
      final response = await NetworkProvider().call(path: AppConfig.notification, method: RequestMethod.get);
      notificationResponse = NotificationResponse.fromJson(response!.data);
      notificationLength = NotificationResponse.fromJson(response.data).data!.where((element) => element.readAt == null).length;
      isLoadingNotification = false;
      isLoadingNotificationHasError = false;
      update();
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      isLoadingNotification = false;
      isLoadingNotificationHasError = true;
      update();
      throw errorMessage;
    } catch (err) {
      isLoadingNotification = false;
      isLoadingNotificationHasError = true;
      update();
      throw err.toString();
    }
  }


  Future<void> deleteFcmTokenDuringSignOUt() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final fcmToken = await LocalCachedData.instance.getVendorFcmToken();
    final notificationStatus1 = await LocalCachedData.instance.getIsEnableNotificationStatus();
    if(fcmToken != null && fcmToken != "" && notificationStatus1 == true){
      try{
        final response = await NetworkProvider().call(path: "/vendor/fcm-tokens/$fcmToken", method: RequestMethod.delete);
        await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: false);
        notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
        update();
        // Get.back();
        // Get.snackbar("Success", "Notification Deactivated!", colorText: white, backgroundColor: greenPea);
      }on DioError catch (err) {
        final errorMessage = Future.error(ApiError.fromDio(err));
        notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
        update();
        // Get.back();
        // Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: persianRed);
        update();
        throw errorMessage;
      } catch (err) {
        notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
        update();
        Get.back();
        Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
        throw err.toString();
      }
    }

  }

  Future<void> sendFcmTokenDuringLoging() async {
    await getToken();

    try{
      var postBody = dio.FormData.fromMap({
        "token": fcmToken,
      });
      final response = await NetworkProvider().call(path: AppConfig.sendVendorToken, method: RequestMethod.post, body: postBody, context: null);
      Get.put<LocalCachedData>(await LocalCachedData.create());
      await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: true);
      await LocalCachedData.instance.cacheVendorFcmToken(fcmToken: fcmToken!);
      Get.put<LocalCachedData>(await LocalCachedData.create());
      notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
      update();
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      if(err.response?.data['message'] == "This token is already registered."){
        await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: true);
      }
      await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: false);
      notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
      update();
      throw errorMessage;
    } catch (err) {
      if(err.toString() == "This token is already registered."){
        await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: true);
      }else{
        await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: false);
        notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
        update();
      }
      update();
      throw err.toString();
    }
  }

  String? fcmToken;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  getToken() async {
    await messaging.getToken().then((value){
      final token = value;
      fcmToken = token;
    });
  }
  bool? notificationStatus;
  Future<void> sendFcmToken() async {
    await getToken();

    try{
      var postBody = dio.FormData.fromMap({
        "token": fcmToken,
      });
      final response = await NetworkProvider().call(path: AppConfig.sendVendorToken, method: RequestMethod.post, body: postBody, context: Get.context!);
      log( response?.data["message"]);
      Get.back();
      Get.put<LocalCachedData>(await LocalCachedData.create());
      await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: true);
      await LocalCachedData.instance.cacheVendorFcmToken(fcmToken: fcmToken!);
      Get.put<LocalCachedData>(await LocalCachedData.create());
      notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
      update();
      Get.snackbar("Success", "Notification Activated!", colorText: white, backgroundColor: greenPea);
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      if(err.response?.data['message'] == "This token is already registered."){
        Get.back();
        Get.snackbar("Success", "Notification already activated", colorText: white, backgroundColor: greenPea);
        await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: true);
      }
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: persianRed);
      await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: false);
      notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
      update();
      Get.back();
      throw errorMessage;
    } catch (err) {
      if(err.toString() == "This token is already registered."){
        Get.back();
        await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: true);
        notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
        update();
        Get.snackbar("Success", "Notification already activated", colorText: white, backgroundColor: greenPea);
      }else{
        Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
        await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: false);
        notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
        update();
        Get.back();
      }
      update();
      throw err.toString();
    }
  }

  Future<void> deleteFcmToken() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final fcmToken = await LocalCachedData.instance.getVendorFcmToken();
    try{
      final response = await NetworkProvider().call(path: "/vendor/fcm-tokens/$fcmToken", method: RequestMethod.delete, context: Get.context!);
      await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: false);
      notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
      update();
      Get.back();
      Get.snackbar("Success", "Notification Deactivated!", colorText: white, backgroundColor: greenPea);
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
      update();
      Get.back();
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: persianRed);
      update();
      throw errorMessage;
    } catch (err) {
      notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
      update();
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
      throw err.toString();
    }
  }

  Future<void> deleteFcmTokenInBackground() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final fcmToken = await LocalCachedData.instance.getVendorFcmToken();
    try{
      final response = await NetworkProvider().call(path: "/vendor/fcm-tokens/$fcmToken", method: RequestMethod.delete);
      await LocalCachedData.instance.cacheIsEnableNotificationStatus(isEnableNotification: false);
      notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
      update();
      // Get.back();
      // Get.snackbar("Success", "Notification Deactivated!", colorText: white, backgroundColor: greenPea);
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
      update();
      throw errorMessage;
    } catch (err) {
      notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
      update();
      // Get.back();
      // Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
      throw err.toString();
    }
  }


  final picker = ImagePicker();
  void onUploadProductPhoto(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      updateProfilePhoto = pickedFile;
      update();
    } catch (e) {
      final pickImageError = e;
      log(pickImageError.toString());
      update();
    }
  }

  XFile? updateProfilePhoto;

  Future<void> updateProfilePicture() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    try{
      var postBody = dio.FormData.fromMap({
        "_method": "patch",
        "email": vendorProfileResponse?.data?.email ?? "",
        "first_name": vendorProfileResponse?.data?.lastName ?? "",
        "last_name": vendorProfileResponse?.data?.firstName ?? "",
        "phone": vendorProfileResponse?.data?.phone ?? "",
        "image": await dio.MultipartFile.fromFile(updateProfilePhoto!.path, filename: updateProfilePhoto!.path.split('/').last),
        "qualification": vendorProfileResponse?.data?.qualification ?? "",
        "nin": vendorProfileResponse?.data?.nin ?? "",
      });
      final response = await NetworkProvider().call(path: "/vendor/profile", method: RequestMethod.post, body: postBody, context: Get.context);
      final value = VendorProfileResponse.fromJson(response!.data);
      await LocalCachedData.instance.cacheVendorProfile(vendorProfileResponse: value);
      await getVendorProfile().then((value){
        onInitializeLocalStorage();
        updateProfilePhoto = null;
        update();
        Get.back();
        Get.snackbar("Success", "Profile Picture Updated", colorText: white, backgroundColor: greenPea);
      });
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error", err.response?.data['message'] == "Request Entity Too Large" ? "Image Size is Too Large" : err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: greenPea);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString() == "Request Entity Too Large" ? "Image Size is Too Large" : err.toString(), colorText: white, backgroundColor: persianRed);
      update();
      throw err.toString();
    }
  }

  void loadShop()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    await LocalCachedData.instance.getIsBookableServiceStatus().then((value) async {
      if(value != true){
        await getAShop();
      }else{
        null;
      }
    });
  }

  @override
  void onInit() {
    // getTransactionsHistory();
    loadShop();
    super.onInit();
  }

  Future<void> markAsRead({required BuildContext context, required String notificationId, required bool isNotificationDetails})async{
    progressIndicator(context);
    try{
      final response = await NetworkProvider().call(path: "/vendor/notifications/$notificationId/mark-as-read", method: RequestMethod.post);
      final message = response?.data["message"];
      await getNotification().then((value){
        Get.back();
        isNotificationDetails == true ? Get.back() : null;
        Get.snackbar("Success",  message ?? "Marked as read", colorText: white, backgroundColor: greenPea);
      });
    }on DioError catch (err) {
      Get.back();
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: persianRed);
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
      throw err.toString();
    }
  }

  Future<void> markAllAsRead({required BuildContext context})async{
    progressIndicator(context);
    try{
      final response = await NetworkProvider().call(path: "/vendor/notifications/mark-all-as-read", method: RequestMethod.post);
      final message = response?.data["message"];
      await getNotification();
      Get.back();
      Get.snackbar("Success",  message ?? "Marked as read", colorText: white, backgroundColor: greenPea);
    }on DioError catch (err) {
      Get.back();
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, colorText: white, backgroundColor: persianRed);
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString(), colorText: white, backgroundColor: persianRed);
      throw err.toString();
    }
  }
}