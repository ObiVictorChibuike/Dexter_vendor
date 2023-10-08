import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/firestore_constants.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/data/app_services_model/get_all_services_response_model.dart';
import 'package:dexter_vendor/data/auth_model/login_response.dart';
import 'package:dexter_vendor/data/business/business_response_model.dart';
import 'package:dexter_vendor/data/vendor_model/vendor_profile_response.dart';
import 'package:dexter_vendor/datas/model/user/user.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/app_config.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor_overview/vendor_overview.dart';
import 'package:dexter_vendor/widget/progress_indicator.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart'as auth;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateException,
  authenticateCanceled,
}

class LoginController extends GetxController{

  //Form Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Variables
  bool? networkState;
  String? errorMessage;
  bool togglePassword = true;
  String? userPassword;

  void togglePasswordVisibility(){
    togglePassword = !togglePassword;
    update();
  }

  final googleSignIn = GoogleSignIn();
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Status myStatus = Status.uninitialized;
  Status get status => myStatus;

  Future<bool> handleSignIn() async {
    progressIndicator(Get.context);
    myStatus = Status.authenticating;
    update();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      auth.User? user = (await firebaseAuth.signInWithCredential(credential)).user;
      if (user != null) {
        String displayName = user.displayName ?? "";
        String email = user.email ?? "";
        String id = user.uid;
        String phoneNumber = user.phoneNumber ?? "08199999999";
        String photoUrl = user.photoURL ?? profilePicturePlaceHolder;
        UserLoginResponseEntity userProfile = UserLoginResponseEntity();
        userProfile.email = email;
        userProfile.userId = id;
        userProfile.displayName = displayName;
        userProfile.photoUrl = photoUrl;
        userProfile.userType = "Vendor";
        userProfile.phoneNumber = phoneNumber;
        Get.put<LocalCachedData>(await LocalCachedData.create());
        await LocalCachedData.instance.saveUserDetails(userLoginResponseEntity: userProfile);
        await LocalCachedData.instance.cacheLoginStatus(isLoggedIn: true);
        await LocalCachedData.instance.cacheCurrentUserType(userType: "Vendor");
        await LocalCachedData.instance.cacheCurrentUserId(userId: userProfile.userId);
        var userDataStore = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection)
            .withConverter(fromFirestore: UserData.fromFirestore,toFirestore: (UserData userChatModel, options)=> userChatModel.toFirestore(),).where("id", isEqualTo: id).get();
        if(userDataStore.docs.isEmpty){
          final data = UserData(
              id: id, name: displayName, email: email,
              photourl: photoUrl, location: "", fcmtoken: "",
              addtime: Timestamp.now(), userType: "Vendor", businessType: "");
          await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).withConverter(fromFirestore: UserData.fromFirestore,toFirestore: (UserData userChatModel, options)=> userChatModel.toFirestore(),).add(data);
        }
        await loginWithFireBase(email,"${email}");
          myStatus = Status.authenticated;
          Get.back();
          update();
        return true;
      } else {
        myStatus = Status.authenticateError;
        Get.back();
        update();
        return false;
      }
    } else {
      myStatus = Status.authenticateCanceled;
      Get.back();
      update();
      return false;
    }
  }

  void handleException() {
    myStatus = Status.authenticateException;
    update();
  }

  Future<void> handleSignOut() async {
    myStatus = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }

  Future<void> loginWithFireBase(String email, String password)async{
    try{
      var postBody = jsonEncode({
        "email":  email,
        "password": password,
      });
      final response = await NetworkProvider().call(path: AppConfig.login, method: RequestMethod.post, body: postBody, context: Get.context);
      final value = LoginResponse.fromJson(response!.data);
      final token = value.data!.token!;
      await LocalCachedData.instance.cacheAuthToken(token: token);
      await getAuthUserWithFirebase().then((value) async {
        Get.back();
        Get.offAll(()=> const VendorOverView());
      });
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.back();
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, backgroundColor: persianRed, colorText: white);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.back();
      Get.snackbar("Something Went Wrong",  err.toString(), backgroundColor: persianRed, colorText: white);
      update();
      throw err.toString();
    }
  }

  //Fetch the services dexter offers
  Future<void> getAppServices()async{
    try{
      final response = await NetworkProvider().call(path: AppConfig.services, method: RequestMethod.get);
      final value = AppServicesResponse.fromJson(response!.data);
      await LocalCachedData.instance.cacheAppServices(appServicesResponse: value);
      update();
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      throw errorMessage;
    } catch (err) {
      throw err.toString();
    }
  }

  //Method to login vendor and save auth token
  final homeController = Get.put(HomeController());
  Future<void> login()async{
    try{
      var postBody = jsonEncode({
        "email":  emailController.text,
        "password": passwordController.text,
      });
      final response = await NetworkProvider().call(path: AppConfig.login, method: RequestMethod.post, body: postBody, context: Get.context);
      final value = LoginResponse.fromJson(response!.data);
      await LocalCachedData.instance.cacheLoginResponse(loginResponse: value);
      final token = value.data!.token!;
      await LocalCachedData.instance.cacheAuthToken(token: token);
      if(value.data?.user?.shop != null){
        await LocalCachedData.instance.cacheShopId(shopId: value.data!.user!.shop!.id);
        await LocalCachedData.instance.cacheIsBookableServiceStatus(isBookableServiceStatus: value.data!.user!.shop!.service!.isBookable!);
        await getVendorProfile().then((value) async {
          await homeController.sendFcmTokenDuringLoging();


          //Check firebase to see if user already exist
          Get.put<LocalCachedData>(await LocalCachedData.create());
          final vendorProfile = await LocalCachedData.instance.getVendorProfile();
          // var uuid = Uuid();
          UserLoginResponseEntity userProfile = UserLoginResponseEntity();
          userProfile.email = vendorProfile!.data!.email;
          // userProfile.userId = uuid.v4();
          userProfile.userId = vendorProfile.data!.id!.toString();
          userProfile.displayName = "${vendorProfile.data!.firstName} ${vendorProfile.data!.lastName}";
          userProfile.photoUrl = vendorProfile.data?.image ?? profilePicturePlaceHolder;
          userProfile.userType = "Vendor";
          userProfile.phoneNumber = vendorProfile.data!.phone;
          await LocalCachedData.instance.saveUserDetails(userLoginResponseEntity: userProfile);
          await LocalCachedData.instance.cacheCurrentUserType(userType: "Vendor");
          await LocalCachedData.instance.cacheCurrentUserId(userId: userProfile.userId);
          await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).withConverter(fromFirestore: UserData.fromFirestore,toFirestore: (UserData userChatModel, options)=> userChatModel.toFirestore(),).
          where("id", isEqualTo: userProfile.userId).where("user_type", isEqualTo: "Vendor").get();
          await LocalCachedData.instance.cacheLoginStatus(isLoggedIn: true);
          Get.back();
          Get.offAll(()=> const VendorOverView());
        });
      }else if(value.data?.user?.business != null){
        await LocalCachedData.instance.cacheIsBookableServiceStatus(isBookableServiceStatus: value.data!.user!.business!.service!.isBookable!);
        var response = await NetworkProvider().call(path: "/vendor/businesses/${value.data!.user!.business!.id}", method: RequestMethod.get, context: null,);
        final data = BusinessResponseModel.fromJson(response!.data);
        await LocalCachedData.instance.cacheBusinessResponse(businessResponse: data);
        await getVendorProfile().then((value) async {
          await homeController.sendFcmTokenDuringLoging();
          //Check firebase to see if user already exist
          Get.put<LocalCachedData>(await LocalCachedData.create());
          final vendorProfile = await LocalCachedData.instance.getVendorProfile();
          // var uuid = Uuid();
          UserLoginResponseEntity userProfile = UserLoginResponseEntity();
          userProfile.email = vendorProfile!.data!.email;
          // userProfile.userId = uuid.v4();
          userProfile.userId = vendorProfile.data!.id!.toString();
          userProfile.displayName = "${vendorProfile.data!.firstName} ${vendorProfile.data!.lastName}";
          userProfile.photoUrl = vendorProfile.data?.image ?? profilePicturePlaceHolder;
          userProfile.userType = "Vendor";
          userProfile.phoneNumber = vendorProfile.data!.phone;
          await LocalCachedData.instance.saveUserDetails(userLoginResponseEntity: userProfile);
          await LocalCachedData.instance.cacheCurrentUserType(userType: "Vendor");
          await LocalCachedData.instance.cacheCurrentUserId(userId: userProfile.userId);
          await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).withConverter(fromFirestore: UserData.fromFirestore,toFirestore: (UserData userChatModel, options)=> userChatModel.toFirestore(),).
          where("id", isEqualTo: userProfile.userId).where("user_type", isEqualTo: "Vendor").get();
          await LocalCachedData.instance.cacheLoginStatus(isLoggedIn: true);
          Get.back();
          Get.offAll(()=> const VendorOverView());
        });
      }else if (value.data?.user?.shop == null || value.data?.user?.business == null){
        Get.back();
        Get.snackbar("Error", "Account Invalid. Please Register", backgroundColor: persianRed, colorText: white);
      }
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, backgroundColor: persianRed, colorText: white);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString(), backgroundColor: persianRed, colorText: white);
      update();
      throw err.toString();
    }
  }

  Future<void> getVendorProfile() async {
    try{
      var response = await NetworkProvider().call(path: AppConfig.user, method: RequestMethod.get, context: null,);
      final value = VendorProfileResponse.fromJson(response!.data);
      await LocalCachedData.instance.cacheShopId(shopId: value.data?.shop?.id);
      await LocalCachedData.instance.cacheVendorProfile(vendorProfileResponse: value);
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error", err.response?.data['message'] ?? errorMessage, backgroundColor: persianRed, colorText: white);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString(), backgroundColor: persianRed, colorText: white);
      update();
      throw err.toString();
    }
  }

  Future<void> getABusiness({required String businessId}) async {
    try{
      var response = await NetworkProvider().call(path: "/vendor/businesses/$businessId", method: RequestMethod.get, context: null,);
      final value = BusinessResponseModel.fromJson(response!.data);
      await LocalCachedData.instance.cacheBusinessResponse(businessResponse: value);
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

  Future<void> getAuthUserWithFirebase() async {
    try{
      var response = await NetworkProvider().call(path: AppConfig.user, method: RequestMethod.get, context: null,);
      final value = VendorProfileResponse.fromJson(response!.data);
      await LocalCachedData.instance.cacheVendorProfile(vendorProfileResponse: value);
      Get.back();
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


  Future<void> onInitializeLocalStorage() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    super.onInit();
  }

  @override
  void onInit() {
    onInitializeLocalStorage();
    super.onInit();
  }
}