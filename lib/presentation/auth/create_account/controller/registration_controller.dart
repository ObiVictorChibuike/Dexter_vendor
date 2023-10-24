import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/firestore_constants.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/data/auth_model/registration_response.dart';
import 'package:dexter_vendor/data/business/business_response_model.dart';
import 'package:dexter_vendor/data/business/create_business_model_response.dart';
import 'package:dexter_vendor/data/location_data/get_location.dart';
import 'package:dexter_vendor/data/shop_model/create_shop_response_model.dart';
import 'package:dexter_vendor/data/vendor_model/vendor_profile_response.dart';
import 'package:dexter_vendor/datas/model/user/user.dart';
import 'package:dexter_vendor/data/product_model/add_product_to_category_response.dart';
import 'package:dexter_vendor/data/vendor_model/update_vendor_profile_response.dart';
import 'package:dexter_vendor/data/product_model/shop_product_category_response.dart';
import 'package:dexter_vendor/datas/model/vendor/create_category_response.dart';
import 'package:dexter_vendor/datas/model/vendor/vendor_shop_response.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/app_config.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dexter_vendor/presentation/auth/create_account/pages/add_product.dart';
import 'package:dexter_vendor/presentation/auth/create_account/pages/create_shop.dart';
import 'package:dexter_vendor/presentation/auth/create_account/pages/guildline.dart';
import 'package:dexter_vendor/presentation/auth/create_account/pages/service_provider_details.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor_overview/vendor_overview.dart';
import 'package:uuid/uuid.dart';
import 'package:dexter_vendor/widget/progress_indicator.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateException,
  authenticateCanceled,
}

class RegistrationController extends GetxController{

  //Form Controllers
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();

  //Variables
  bool? networkState;
  String? errorMessages;
  String? userPassword;

  Future<void> onInitializeLocalStorage() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    super.onInit();
  }

  final googleSignIn = GoogleSignIn();
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Status myStatus = Status.uninitialized;
  Status get status => myStatus;

  Future<bool> handleSignIn({required BuildContext context}) async {
    progressIndicator(context);
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
        String phoneNumber = user.phoneNumber ?? "";
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
        await registerWithFireBaseAccount(displayName.split(" ").first, displayName.split(" ").last, email, phoneNumber, "${email}");
        myStatus = Status.authenticated;
        Get.back();
        Get.back();
        update();
        return true;
       } else {
        myStatus = Status.authenticateError;
        Get.back();
        Get.back();
        update();
        return false;
      }
    }else{
      myStatus = Status.authenticateCanceled;
      Get.back();
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

  List<String> item = [
    "SSCE",
    "Bsc",
    "OND",
    "HND",
    "Masters",
    "ph.D"
  ];

  List<String> state = [
    "Abia State",
    "Adamawa State",
    "Akwa Ibom State",
    "Anambra State",
    "Bauchi State",
    "Bayelsa State",
    "Benue State",
    "Borno State",
    "CrossRiver State",
    "Delta State",
    "Ebonyi State",
    "Edo State",
    "Ekiti State",
    "Enugu State",
    "Gombe State",
    "Imo State",
    "Jigawa State",
    "Kaduna State",
    "Kano State",
    "Katsina State",
    "Kebbi State",
    "Kogi State",
    "Kwara State",
    "Lagos State",
    "Nasarawa State",
    "Niger State",
    "Ogun State",
    "Ondo State",
    "Osun State",
    "Oyo State",
    "Plateau State",
    "Rivers State",
    "Sokoto State",
    "Taraba State",
    "Yobe State",
    "Zamfara State",
    "Abuja FCT"
  ];

  List<String> foodCategory = [
    "Drinks",
    "Snacks",
    "Combo",
    "Fast food",
    "Grills",
    "Swallow",
    "Pasta",
  ];

  List<String> fashion = [
    "Tops",
    "T-Shirts",
    "Jackets",
    "Sports",
    "Designers",
    "Jeans",
    "Trousers",
    "Skirts",
    "Caps",
    "Shorts",
    "Polo",
    "Shoes",
    "Vests"
  ];

  List<String> makeUpCategory = [
    "Bridal Makeup",
    "Basic/Everyday Makeup",
    "Special Occasion",
    "FX Makeup (Special Effect Makeup)",
    "Editional Makeup",
  ];

  List<String> laundryCategory = [
    "Basic package (Washing, Drying and Ironing)",
    "Wash and fold package",
    "Dry cleaning",
    "Bulk laundry package",
    "Express package",
  ];

  final picker = ImagePicker();
  XFile? imageFile;
  XFile? businessServiceSampleImages;
  XFile? coverPhoto;
  XFile? productImage;
  XFile? productCategoryImage;
  int? serviceId;
  bool? checkBookableService;
  int? vendorId;


  void onUploadImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      imageFile = pickedFile;
      update();
    } catch (e) {
      final pickImageError = e;
      log(pickImageError.toString());
      update();
    }
  }

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

  void onUploadCoverPhoto(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      coverPhoto = pickedFile;
      update();
    } catch (e) {
      final pickImageError = e;
      log(pickImageError.toString());
      update();
    }
  }

  void onUploadProductPhoto(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      productImage = pickedFile;
      update();
    } catch (e) {
      final pickImageError = e;
      log(pickImageError.toString());
      update();
    }
  }

  void onUploadProductCategoryPhoto(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      productCategoryImage = pickedFile;
      update();
    } catch (e) {
      final pickImageError = e;
      log(pickImageError.toString());
      update();
    }
  }
  XFile? photo1;
  XFile? photo2;
  XFile? photo3;
  XFile? photo4;

  @override
  void onInit() {
    onInitializeLocalStorage();
    update();
    super.onInit();
  }

  bool? isLoadingCategory;
  bool? isLoadingCategoryHasError;
  Future<void> getCategory() async {
    isLoadingCategory = true;
    isLoadingCategoryHasError = false;
    update();
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();

    try{
      var response = await NetworkProvider().call(path: "/vendor/shops/$shopId/categories", method: RequestMethod.get, context: Get.context);
      shopProductCategoryResponse = ShopProductCategoryResponse.fromJson(response!.data);
      isLoadingCategory = false;
      isLoadingCategoryHasError = false;
      update();
    }on dio.DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      isLoadingCategory = true;
      isLoadingCategoryHasError = false;
      update();
      update();
      throw errorMessage;
    } catch (err) {
      isLoadingCategory = true;
      isLoadingCategoryHasError = false;
      update();
      update();
      throw err.toString();
    }
  }


  String? selectedCategory;
  ShopProductCategoryResponse? shopProductCategoryResponse;
  bool? onHasAddProductIsLoading;

  Future<void> addVendorProduct({required String categoryName, XFile? imageFile, required String productName,
      required XFile productImage, required String productPrice, required String description, required int inStock}) async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    update();
    progressIndicator(Get.context);
    try{
      if(shopProductCategoryResponse!.data != [] ||  shopProductCategoryResponse!.data!.isNotEmpty || shopProductCategoryResponse?.data == null){
        // final categoryList = shopProductCategoryResponse!.data!.map((element) => element.name?.toLowerCase());
        // final categoryCheck = categoryList.contains(selectedCategory?.toLowerCase());
        // if(categoryCheck == true){
          final index = shopProductCategoryResponse?.data?.indexWhere((element) => element.name?.toLowerCase() == selectedCategory?.toLowerCase());
          final categoryId = shopProductCategoryResponse?.data![index!].id;
          await onAddProduct(name: productName, imageFile: productImage, price: productPrice, description: description, shopId: shopId!, categoryId: categoryId!, inStock: inStock).then((value) async {
            Get.put<LocalCachedData>(await LocalCachedData.create());
            final signInWithGoogleFirebaseStatus = await LocalCachedData.instance.getIsSignInWithFireBaseStatus();
            final vendorProfile = await LocalCachedData.instance.getVendorProfile();
            final shopResponse = await LocalCachedData.instance.getCreateShopResponse();
            final selectedBusinessName = await LocalCachedData.instance.getSelectedServiceName();
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
            var userDataStore = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection)
                .withConverter(fromFirestore: UserData.fromFirestore,toFirestore: (UserData userChatModel, options)=> userChatModel.toFirestore(),).where("id", isEqualTo: userProfile.userId).where("user_type", isEqualTo: "Vendor").get();
            if(userDataStore.docs.isEmpty && signInWithGoogleFirebaseStatus != true){
              final data = UserData(
                  id: userProfile.userId, name: userProfile.displayName, email: userProfile.email,
                  photourl: userProfile.photoUrl, location: "", fcmtoken: "",
                  addtime: Timestamp.now(), userType: "Vendor", businessType: selectedBusinessName,
                  businessName: shopResponse?.data?.name ?? "", businessBio: shopResponse?.data?.biography ?? "",
                  businessCloseTime: shopResponse?.data?.closingTime ?? "", businessOpenTime: shopResponse?.data?.openingTime ?? "",
                  businessAddress: shopResponse?.data?.contactAddress?.fullAddress ?? "",
                  businessCoverPhoto: shopResponse?.data?.coverImage ?? imagePlaceHolder);
              await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).withConverter(fromFirestore: UserData.fromFirestore,toFirestore: (UserData userChatModel, options)=> userChatModel.toFirestore(),).add(data);
            }onHasAddProductIsLoading = true;
            await LocalCachedData.instance.cacheLoginStatus(isLoggedIn: true);
            await LocalCachedData.instance.cacheIsBookableServiceStatus(isBookableServiceStatus: false);
            update();
          });
        // }else if(categoryCheck == false){
        //   Get.put<LocalCachedData>(await LocalCachedData.create());
        //   final signInWithGoogleFirebaseStatus = await LocalCachedData.instance.getIsSignInWithFireBaseStatus();
        //   await addProductCategory(categoryName: categoryName, shopId: shopId!).then((value) async {
        //     final categoryId = value.data!.id;
        //     await onAddProduct(name: productName, imageFile: productImage, price: productPrice, description: description, shopId: shopId, categoryId: categoryId!, inStock: inStock).then((value) async {
        //       final vendorProfile = await LocalCachedData.instance.getVendorProfile();
        //       final selectedBusinessName = await LocalCachedData.instance.getSelectedServiceName();
        //       var uuid = Uuid();
        //       UserLoginResponseEntity userProfile = UserLoginResponseEntity();
        //       userProfile.email = vendorProfile!.data!.email;
        //       userProfile.userId = uuid.v4();
        //       userProfile.displayName = "${vendorProfile.data!.firstName} ${vendorProfile.data!.lastName}";
        //       userProfile.photoUrl = vendorProfile.data?.image ?? profilePicturePlaceHolder;
        //       userProfile.userType = "Vendor";
        //       userProfile.phoneNumber = vendorProfile.data!.phone;
        //       await LocalCachedData.instance.saveUserDetails(userLoginResponseEntity: userProfile);
        //       await LocalCachedData.instance.cacheCurrentUserType(userType: "Vendor");
        //       await LocalCachedData.instance.cacheCurrentUserId(userId: userProfile.userId);
        //       var userDataStore = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection)
        //           .withConverter(fromFirestore: UserData.fromFirestore,toFirestore: (UserData userChatModel, options)=> userChatModel.toFirestore(),).where("id", isEqualTo: userProfile.userId).get();
        //       if(userDataStore.docs.isEmpty && signInWithGoogleFirebaseStatus != true){
        //       final data = UserData(
        //       id: userProfile.userId, name: userProfile.displayName, email: userProfile.email,
        //       photourl: userProfile.photoUrl, location: "", fcmtoken: "",
        //       addtime: Timestamp.now(), userType: "Vendor", businessType: selectedBusinessName);
        //       await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).withConverter(fromFirestore: UserData.fromFirestore,toFirestore: (UserData userChatModel, options)=> userChatModel.toFirestore(),).add(data);
        //       }onHasAddProductIsLoading = true;
        //       await LocalCachedData.instance.cacheLoginStatus(isLoggedIn: true);
        //       update();
        //     });
        //   });
        // }
      }
      update();
    }on dio.DioError catch (err) {
      Get.back();
      final errorMessage = Future.error(ApiError.fromDio(err));
      errorMessages = err.response?.data['message'] ?? errorMessage.toString();
      onHasAddProductIsLoading = false;
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      onHasAddProductIsLoading = false;
      update();
      errorMessages = err.toString();
      throw err.toString();
    }
  }

  Future<void> addProductFromApp({required String categoryName, XFile? imageFile, required String productName,
    required XFile productImage, required String productPrice, required String description, required int inStock}) async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    progressIndicator(Get.context);
    try{
      var response = await NetworkProvider().call(path: "/vendor/shops/$shopId/categories", method: RequestMethod.get,);
      shopProductCategoryResponse = ShopProductCategoryResponse.fromJson(response!.data);
      if(shopProductCategoryResponse!.data != [] || shopProductCategoryResponse!.data!.isNotEmpty || shopProductCategoryResponse?.data == null){
        // final categoryList = shopProductCategoryResponse!.data!.map((element) => element.name?.toLowerCase());
        // final categoryCheck = categoryList.contains(selectedCategory?.toLowerCase());
        // if(categoryCheck == true){
          final index = shopProductCategoryResponse?.data?.indexWhere((element) => element.name?.toLowerCase() == selectedCategory?.toLowerCase());
          final categoryId = shopProductCategoryResponse?.data![index!].id;
          await onAddProduct(name: productName, imageFile: productImage, price: productPrice, description: description, shopId: shopId!, categoryId: categoryId!, inStock: inStock).then((value) async {
            await LocalCachedData.instance.cacheLoginStatus(isLoggedIn: true);
            onHasAddProductIsLoading = true;
            update();
          });
        // }else if(categoryCheck == false){
        //   await addProductCategory(categoryName: categoryName, shopId: shopId!).then((value) async {
        //     final categoryId = value.data!.id;
        //     await onAddProduct(name: productName, imageFile: productImage, price: productPrice, description: description, shopId: shopId, categoryId: categoryId!, inStock: inStock);
        //     onHasAddProductIsLoading = true;
        //     await LocalCachedData.instance.cacheLoginStatus(isLoggedIn: true);
        //     update();
        //   });
        // }
      }
      update();
    }on dio.DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      errorMessages = err.response?.data['message'] ?? errorMessage.toString();
      onHasAddProductIsLoading = false;
      update();
      throw errorMessage;
    } catch (err) {
      onHasAddProductIsLoading = false;
      update();
      errorMessages = err.toString();
      throw err.toString();
    }
  }

  Future<AddProductToCategoryResponse> onAddProduct({required String name, required XFile? imageFile, required String? price,
    required String? description, required int shopId, required int categoryId, required int inStock}) async {
    try{
      final file = imageFile == null ? null : await dio.MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.name,
      );
      var postBody = dio.FormData.fromMap({
        "name": name,
        "description": description,
        "image": file,
        "price": price,
        "in_stock": inStock,
        "category_id": categoryId
      });
      var response = await NetworkProvider().call(path: "/vendor/shops/$shopId/products", method: RequestMethod.post, body: postBody, context: Get.context);
      final payLoad = AddProductToCategoryResponse.fromJson(response!.data);
      return payLoad;
    }on dio.DioError catch (err) {
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


  Future<void> createABusiness({required String? name, required String? biography, required XFile? coverImage,
    required String? openingTime, required String? closingTime, required String? contactAddress, required String? contactEmail,
    required String? contactPhone, required double? latitude, required double? longitude, required String? serviceId,
    required String? serviceCharge, required List<XFile>? businessImages}) async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final file = coverImage == null ? null : await dio.MultipartFile.fromFile(
      coverImage.path,
      filename: coverImage.name,
    );
    try{
      var postBody = dio.FormData.fromMap({
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
      var response = await NetworkProvider().call(path: "/vendor/businesses", method: RequestMethod.post, body: postBody, context: Get.context);
      final payLoad = CreateABusinessResponse.fromJson(response!.data);
      await getABusiness(businessId: payLoad.data!.id.toString()).then((value) async {
        Get.put<LocalCachedData>(await LocalCachedData.create());
        final signInWithGoogleFirebaseStatus = await LocalCachedData.instance.getIsSignInWithFireBaseStatus();
        final vendorProfile = await LocalCachedData.instance.getVendorProfile();
        final selectedBusinessName = await LocalCachedData.instance.getSelectedServiceName();
        var uuid = Uuid();
        UserLoginResponseEntity userProfile = UserLoginResponseEntity();
        userProfile.email = vendorProfile!.data!.email;
        userProfile.userId = uuid.v4();
        userProfile.displayName = "${vendorProfile.data!.firstName} ${vendorProfile.data!.lastName}";
        userProfile.photoUrl = vendorProfile.data?.image ?? profilePicturePlaceHolder;
        userProfile.userType = "Vendor";
        userProfile.phoneNumber = vendorProfile.data!.phone;
        await LocalCachedData.instance.saveUserDetails(userLoginResponseEntity: userProfile);
        await LocalCachedData.instance.cacheCurrentUserType(userType: "Vendor");
        await LocalCachedData.instance.cacheCurrentUserId(userId: userProfile.userId);
        var userDataStore = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection)
            .withConverter(fromFirestore: UserData.fromFirestore,toFirestore: (UserData userChatModel, options)=> userChatModel.toFirestore(),).where("id", isEqualTo: userProfile.userId).get();
        if(userDataStore.docs.isEmpty && signInWithGoogleFirebaseStatus != true){
        final businessResponse = await LocalCachedData.instance.getBusinessResponse();
        final data = UserData(
        id: userProfile.userId, name: userProfile.displayName, email: userProfile.email,
        photourl: userProfile.photoUrl, location: "", fcmtoken: "",
        addtime: Timestamp.now(), userType: "Vendor", businessType: selectedBusinessName,
        businessName: businessResponse?.data?.name ?? "", businessBio: businessResponse?.data?.biography ?? "",
        businessCloseTime: businessResponse?.data?.closingTime ?? "", businessOpenTime: businessResponse?.data?.openingTime ?? "",
        businessAddress: businessResponse?.data?.contactAddress?.fullAddress ?? "",
        businessCoverPhoto: businessResponse?.data?.coverImage ?? imagePlaceHolder);
        await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).withConverter(fromFirestore: UserData.fromFirestore,toFirestore: (UserData userChatModel, options)=> userChatModel.toFirestore(),).add(data);
        }
      });
      await LocalCachedData.instance.cacheLoginStatus(isLoggedIn: true);
      await LocalCachedData.instance.cacheIsBookableServiceStatus(isBookableServiceStatus: true);
      Get.back();
      Get.offAll(()=> const VendorOverView());
    }on dio.DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error",   err.response?.data['message'] ?? errorMessage, backgroundColor: persianRed, colorText: white);
      update();
      throw errorMessage;
    } catch (err) {
      if(err.toString() == "Request Entity Too Large"){
        Get.back();
        Get.snackbar("Error",  "Images size are too large", backgroundColor: persianRed, colorText: white);
        update();
      }else{
        Get.back();
        Get.snackbar("Something Went Wrong",  err.toString(), backgroundColor: persianRed, colorText: white);
        update();
      }
      throw err.toString();
    }
  }


  Future<void> addProductCategory({required String categoryName, required BuildContext context}) async {
    final shopId = await LocalCachedData.instance.getShopId();
    try{
      var postBody = dio.FormData.fromMap({
        "name": categoryName,
        "cover_image": productCategoryImage == null ? null : productCategoryImage,
      });
      var response = await NetworkProvider().call(path: "/vendor/shops/$shopId/categories", method: RequestMethod.post, body: postBody, context: Get.context);
      final payLoad = AddProductCategoryResponse.fromJson(response!.data);
      await getCategory().then((value){
        Get.back();
        Get.snackbar("Success", payLoad.message ?? "Category added successfully", backgroundColor: greenPea, colorText: white);
      });
    }on dio.DioError catch (err) {
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

  Future<void> registerAccount() async {
    try{
      var postBody = jsonEncode({
        "first_name": firstName.text,
        "last_name": lastName.text,
        "email": email.text,
        "phone": phone.text,
        "password": password.text,
        "password_confirmation": password.text
      });
      final response = await NetworkProvider().call(path: AppConfig.register, method: RequestMethod.post, body: postBody, context: Get.context!);
      final value = RegistrationResponse.fromJson(response!.data);
      await LocalCachedData.instance.cacheAuthToken(token: value.data!.token);
      firstName.clear();
      lastName.clear();
      email.clear();
      phone.clear();
      password.clear();
      await LocalCachedData.instance.cacheRegistrationResponse(registrationResponse: value).then((value) async {
        Get.back();
        Get.offAll(() => GuildLines());
      });
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error",  err.response?.data['message'] ?? errorMessage, backgroundColor: persianRed, colorText: white);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      update();
      Get.snackbar("Something Went Wrong", err.toString(), backgroundColor: persianRed, colorText: white);
      throw err.toString();
    }
  }


  Future<void> getVendorProfile() async {
    try{
      var response = await NetworkProvider().call(path: AppConfig.user, method: RequestMethod.get, context: null,);
      final value = VendorProfileResponse.fromJson(response!.data);
      await LocalCachedData.instance.cacheVendorProfile(vendorProfileResponse: value);
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

  Future<void> getShopResponse({required String shopId}) async {
    try{
      var response = await NetworkProvider().call(path: "/vendor/shops/$shopId", method: RequestMethod.get, context: null,);
      final value = CreateShopResponse.fromJson(response!.data);
      await LocalCachedData.instance.cacheCreateShopResponse(createShopResponse: value);
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
      vendorId = value.data!.id!;
      await LocalCachedData.instance.cacheVendorProfile(vendorProfileResponse: value);
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

  String? registrationErrorMessages;

  Future<void> registerWithFireBaseAccount(String firstName, String lastName, String email, String phone, String password)async{
    try{
      var postBody = jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "password": password,
      });
      final response = await NetworkProvider().call(path: AppConfig.register, method: RequestMethod.post, body: postBody, context: Get.context!);
      final value = RegistrationResponse.fromJson(response!.data);
      await LocalCachedData.instance.cacheAuthToken(token: value.data!.token);
      await getAuthUserWithFirebase().then((value) async {
        await LocalCachedData.instance.cacheIsSignInWithFireBaseStatus(isSignInWithFireBase: true);
        Get.back();
        Get.offAll(() => GuildLines());
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
      Get.snackbar("Something Went Wrong", err.toString(), backgroundColor: persianRed, colorText: white);
      update();
      throw err.toString();
    }
  }


  Future<void> createShop({
    required String shopName,
    required String biography,
    required XFile coverImage,
    required String openTime,
    required String closeTime,
    required String address,
    required String email,
    required String phoneNumber,
    required String discount,
    // required double lat,
    // required double long,
    required String shoppingCost,
    required String serviceId,
    required BuildContext context,
    }) async {
    // progressIndicator(Get.context);
    try{
      Get.put<LocalCachedData>(await LocalCachedData.create());
      final location = await GetLocation.instance?.checkLocation;
      var postBody = dio.FormData.fromMap({
        "name": shopName,
        "biography": biography,
        "cover_image": await dio.MultipartFile.fromFile(coverImage.path, filename: coverImage.path.split('/').last),
        "opening_time": openTime,
        "closing_time": closeTime,
        "contact_address": address,
        "contact_email": email,
        "contact_phone": phoneNumber,
        "discount": discount,
        "latitude": location?.latitude ?? 0.0,
        "longitude": location?.longitude ?? 0.0,
        "shipping_cost": shoppingCost,
        "service_id": serviceId
      });
      final response = await NetworkProvider().call(path: "/vendor/shops", method: RequestMethod.post, body: postBody, context: context);
      final value = CreateShopResponse.fromJson(response!.data);
      await LocalCachedData.instance.cacheCreateShopResponse(createShopResponse: value);
      if(value.data != null){
        await LocalCachedData.instance.cacheShopId(shopId: value.data!.id);
        await getShopResponse(shopId: value.data!.id!.toString());
        await getVendorProfile().then((value) async {
          await getCategory();
          Get.back();
          Get.offAll(()=> const AddProducts());
        });
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

  Future<void> createBasicDetails({required String email, required String firstName, required String lastName,
    required String phoneNumber, required XFile imageFile, required String qualification, String? nin}) async {
    // progressIndicator(Get.context);
    try{
      var postBody = dio.FormData.fromMap({
        "_method": "patch",
        "email": email,
        "first_name": lastName,
        "last_name": firstName,
        "phone": phoneNumber,
        "image": await dio.MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
        "qualification": qualification,
        "nin": nin,
      });
      final response = await NetworkProvider().call(path: "/vendor/profile", method: RequestMethod.post, body: postBody, context: Get.context);
      final value = UpdateVendorProfileResponse.fromJson(response!.data);
      await getVendorProfile();
      log(value.message ?? "This is successful");
      Get.back();
      checkBookableService == true ? Get.to(()=> const ServiceProviderDetails()) : Get.offAll(()=> CreateVendor());
    }on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      Get.back();
      Get.snackbar("Error", err.response?.data['message'] == "Request Entity Too Large" ? "Image Size is Too Large" : err.response?.data['message'] ?? errorMessage, backgroundColor: persianRed, colorText: white);
      update();
      throw errorMessage;
    } catch (err) {
      Get.back();
      Get.snackbar("Something Went Wrong", err.toString() == "Request Entity Too Large" ? "Image Size is Too Large" : err.toString(), backgroundColor: persianRed, colorText: white);
      update();
      throw err.toString();
    }
  }
}