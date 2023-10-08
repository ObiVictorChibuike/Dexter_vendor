import 'dart:convert';
import 'package:dexter_vendor/app/shared/constants/firestore_constants.dart';
import 'package:dexter_vendor/data/app_services_model/get_all_services_response_model.dart';
import 'package:dexter_vendor/data/auth_model/login_response.dart';
import 'package:dexter_vendor/data/auth_model/registration_response.dart';
import 'package:dexter_vendor/data/business/business_images_response.dart';
import 'package:dexter_vendor/data/business/business_response_model.dart';
import 'package:dexter_vendor/data/business/create_business_model_response.dart';
import 'package:dexter_vendor/data/shop_model/create_shop_response_model.dart';
import 'package:dexter_vendor/data/vendor_model/vendor_profile_response.dart';
import 'package:dexter_vendor/datas/model/user/user.dart';
import 'package:dexter_vendor/data/vendor_model/update_vendor_profile_response.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalCachedData{
  final SharedPreferences _prefs;
  LocalCachedData._(this._prefs);
  static Future<LocalCachedData> create() async => LocalCachedData._(await SharedPreferences.getInstance());
  static LocalCachedData get instance => Get.find<LocalCachedData>();

  Future<int?> getShopId() async {
    int? shopId = _prefs.getInt("shopId");
    return shopId;
  }

  Future<void> cacheShopId({required int? shopId}) async {
    _prefs.setInt("shopId", shopId ?? 0);
  }

  Future<int?> getSelectedServiceId() async {
    int? selectedService = _prefs.getInt("selectedServiceId");
    return selectedService;
  }

  Future<void> cacheSelectedServicesId({required int? selectedServiceId}) async {
    _prefs.setInt("selectedServiceId", selectedServiceId!);
  }

  Future<String?> getSelectedServiceName() async {
    String? selectedServiceName = _prefs.getString("selectedServiceName");
    return selectedServiceName;
  }

  Future<void> cacheSelectedServicesName({required String? selectedServiceName}) async {
    _prefs.setString("selectedServiceName", selectedServiceName!);
  }

  Future<String?> getAuthToken() async {
    String? token = _prefs.getString("token");
    return token;
  }

  Future<void> cacheAuthToken({required String? token}) async {
    _prefs.setString("token", token!);
  }

  Future<void> onLogout() async {
    await _prefs.remove(FirestoreConstants.id);
    // await StorageService.to.remove(STORAGE_USER_PROFILE_KEY);
    // _isLogin.value = false;
    // token = '';
  }

  Future<String?> getCurrentUserId() async {
    String? userId = _prefs.getString(FirestoreConstants.id);
    return userId;
  }
  Future<void> cacheCurrentUserId({required String? userId}) async {
    _prefs.setString(FirestoreConstants.id, userId!);
  }

  Future<String?> getCurrentUserType() async {
    String? userType = _prefs.getString(FirestoreConstants.userType);
    return userType;
  }
  Future<void> cacheCurrentUserType({required String? userType}) async {
    _prefs.setString(FirestoreConstants.userType, userType!);
  }

  Future<String?> getCurrentUserAboutMe() async {
    String? userAboutMe = _prefs.getString(FirestoreConstants.aboutMe);
    return userAboutMe;
  }
  Future<void> cacheCurrentUserAboutMe({required String? userAboutMe}) async {
    _prefs.setString(FirestoreConstants.aboutMe, userAboutMe!);
  }

  Future<String?> getCurrentUserNickName() async {
    String? userNickName = _prefs.getString(FirestoreConstants.nickname);
    return userNickName;
  }
  Future<void> cacheCurrentUserNickName({required String? userNickName}) async {
    _prefs.setString(FirestoreConstants.nickname, userNickName!);
  }

  Future<String?> getCurrentUserPhotoUrl() async {
    String? userPhotoUrl = _prefs.getString(FirestoreConstants.photoUrl);
    return userPhotoUrl;
  }
  Future<void> cacheCurrentPhotoUrl({required String? userPhotoUrl}) async {
    _prefs.setString(FirestoreConstants.photoUrl, userPhotoUrl!);
  }

  Future<void> cacheVendorProfile({required VendorProfileResponse vendorProfileResponse}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("vendor_profile", json.encode(vendorProfileResponse.toJson()));
  }

  Future<VendorProfileResponse?> getVendorProfile() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? authUser = sharedPreferences.getString("vendor_profile");
    return authUser == null ? null : VendorProfileResponse.fromJson(jsonDecode(authUser));
  }

  Future<void> cacheAppServices({required AppServicesResponse appServicesResponse}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("app_services", json.encode(appServicesResponse.toJson()));
  }

  Future<AppServicesResponse?> getAppServices() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? appServices = sharedPreferences.getString("app_services");
    return appServices == null ? null : AppServicesResponse.fromJson(jsonDecode(appServices));
  }

  Future<void> cacheLoginResponse({required LoginResponse loginResponse}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("login_response", json.encode(loginResponse.toJson()));
  }

  Future<LoginResponse?> getLoginResponse() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? loginResponse = sharedPreferences.getString("login_response");
    return loginResponse == null ? null : LoginResponse.fromJson(jsonDecode(loginResponse));
  }

  Future<void> cacheBusinessResponse({required BusinessResponseModel businessResponse}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("business_response", json.encode(businessResponse.toJson()));
  }

  Future<BusinessResponseModel?> getBusinessResponse() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? businessResponse = sharedPreferences.getString("business_response");
    return businessResponse == null ? null : BusinessResponseModel.fromJson(jsonDecode(businessResponse));
  }

  Future<void> cacheBusinessImages({required BusinessImagesResponseModel businessImagesResponseModel}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("business_image", json.encode(businessImagesResponseModel.toJson()));
  }

  Future<BusinessImagesResponseModel?> getBusinessImages() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? businessImagesResponseModel = sharedPreferences.getString("business_image");
    return businessImagesResponseModel == null ? null : BusinessImagesResponseModel.fromJson(jsonDecode(businessImagesResponseModel));
  }

  Future<void> cacheCreateShopResponse({required CreateShopResponse createShopResponse}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("create_shop_response", json.encode(createShopResponse.toJson()));
  }

  Future<CreateShopResponse?> getCreateShopResponse() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? createShopResponse = sharedPreferences.getString("create_shop_response");
    return createShopResponse == null ? null : CreateShopResponse.fromJson(jsonDecode(createShopResponse));
  }

  Future<bool> getLoginStatus() async {
    bool? userData = _prefs.getBool("isLoggedIn");
    return userData ?? false;
  }

  Future<void> cacheLoginStatus({required bool isLoggedIn}) async {
    _prefs.setBool("isLoggedIn", isLoggedIn);
  }

  Future<bool> getIsBookableServiceStatus() async {
    bool? userData = _prefs.getBool("getIsBookableServiceStatus");
    return userData ?? false;
  }

  Future<void> cacheIsBookableServiceStatus({required bool isBookableServiceStatus}) async {
    _prefs.setBool("getIsBookableServiceStatus", isBookableServiceStatus);
  }

  Future<String?> getVendorFcmToken() async {
    String? fcmToken = _prefs.getString("fcm_token");
    return fcmToken == null ? null : fcmToken;
  }

  Future<void> cacheVendorFcmToken({required String fcmToken}) async {
    _prefs.setString("fcm_token", fcmToken);
  }

  Future<void> clearCache() async {
    _prefs.clear();
  }

  Future<bool?> getIsEnableNotificationStatus() async {
    bool? isEnableNotification = _prefs.getBool("isEnableNotification");
    return isEnableNotification;
  }

  Future<void> cacheIsEnableNotificationStatus({required bool isEnableNotification}) async {
    _prefs.setBool("isEnableNotification", isEnableNotification);
  }

  Future<bool?> getIsSignInWithFireBaseStatus() async {
    bool? isSignInWithFireBase = _prefs.getBool("getIsSignInWithFireBase");
    return isSignInWithFireBase;
  }

  Future<void> cacheIsSignInWithFireBaseStatus({required bool isSignInWithFireBase}) async {
    _prefs.setBool("getIsSignInWithFireBase", isSignInWithFireBase);
  }

Future<void> saveUserDetails({required UserLoginResponseEntity userLoginResponseEntity}) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString("userLoginResponseEntity", jsonEncode(userLoginResponseEntity));
}
Future<UserLoginResponseEntity> fetchUserDetails() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  String? userData = sharedPreferences.getString("userLoginResponseEntity");
  return UserLoginResponseEntity.fromJson(jsonDecode(userData!));
}

  Future<void> cacheRegistrationResponse({required RegistrationResponse registrationResponse}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("registrationResponse", jsonEncode(registrationResponse));
  }
  Future<RegistrationResponse> getRegistrationResponse() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? registrationResponse = sharedPreferences.getString("registrationResponse");
    return RegistrationResponse.fromJson(jsonDecode(registrationResponse!));
  }

}