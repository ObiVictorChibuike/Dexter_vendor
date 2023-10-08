import 'dart:developer';

import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/core/state/view_state.dart';
import 'package:dexter_vendor/data/location_data/get_location.dart';
import 'package:dexter_vendor/data/product_model/product_details_response_model.dart';
import 'package:dexter_vendor/data/product_model/product_review_response.dart';
import 'package:dexter_vendor/data/product_model/shop_product_category_response.dart';
import 'package:dexter_vendor/data/shop_model/create_shop_response_model.dart';
import 'package:dexter_vendor/datas/model/product/delete_product_response_model.dart';
import 'package:dexter_vendor/data/product_model/products_of_shop_model.dart';
import 'package:dexter_vendor/datas/model/product/update_product_of_shop_model.dart';
import 'package:dexter_vendor/datas/model/vendor/create_category_response.dart';
import 'package:dexter_vendor/datas/repository/product_repository/product_repository.dart';
import 'package:dexter_vendor/datas/services/product_services/product_services.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dexter_vendor/domain/repository/product/delete_product_impl.dart';
import 'package:dexter_vendor/domain/repository/product/product_repository_impl.dart';
import 'package:dexter_vendor/domain/repository/product/update_product_impl.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/widget/custom_snack.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class ProductController extends GetxController{
  final homeController = Get.put(HomeController());

  Future<void> editShop({
    required String shopName,
    required String biography,
    required XFile coverImage,
    required String openTime,
    required String closeTime,
    required String address,
    required String email,
    required String phoneNumber,
    required String discount,
    required double lat,
    required double long,
    required String shoppingCost,
    required BuildContext context,
  }) async {
    // progressIndicator(Get.context);
    try{
      final homeController = Get.put(HomeController());
      Get.put<LocalCachedData>(await LocalCachedData.create());
      final shopId = await LocalCachedData.instance.getShopId();
      // final location = await GetLocation.instance?.checkLocation;
      var postBody = dio.FormData.fromMap({
        "_method": "patch",
        "name": shopName,
        "biography": biography,
        "cover_image": await dio.MultipartFile.fromFile(coverImage.path, filename: coverImage.path.split('/').last),
        "opening_time": openTime,
        "closing_time": closeTime,
        "contact_address": address,
        "contact_email": email,
        "contact_phone": phoneNumber,
        "discount": discount,
        "latitude": lat,
        "longitude": long,
        "shipping_cost": shoppingCost,
      });
      final response = await NetworkProvider().call(path: "/vendor/shops/$shopId", method: RequestMethod.post, body: postBody, context: context);
      final value = CreateShopResponse.fromJson(response!.data);
      await LocalCachedData.instance.cacheCreateShopResponse(createShopResponse: value);
      if(value.data != null){
        await LocalCachedData.instance.cacheShopId(shopId: value.data!.id);
          await homeController.getAShop();
          await getAllProductOfShop();
          Get.back();
          Get.back();
          Get.back();
          update();
      }
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
  XFile? coverPhoto;
  void onUploadShopCoverPhoto(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      coverPhoto = pickedFile;
      update();
    } catch (e) {
      final pickImageError = e;
      update();
    }
  }
  final products = [
    {
      "assets": AssetPath.beautyClinic,
      "title": "Lip Painting",
      "price": "N 2000",
    },
    {
      "assets": AssetPath.makeUpGirl,
      "title": "Full face Makeup",
      "price": "N 2000",
    },
    {
      "assets": AssetPath.makeUpGirl,
      "title": "Full face Makeup",
      "price": "N 2000",
    },
    {
      "assets": AssetPath.makeUpGirl,
      "title": "Full face Makeup",
      "price": "N 2000",
    },
    {
      "assets": AssetPath.makeUpGirl,
      "title": "Full face Makeup",
      "price": "N 2000",
    },
  ];

  ShopProductCategoryResponse? shopProductCategoryResponse;
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

  String? errorMessage;
  final getAllProduct = Get.put(GetProductOfShopImpl(ProductRepository(ProductServices())));
  final updateProduct = Get.put(UpdateProductImpl(ProductRepository(ProductServices())));
  final deleteProduct = Get.put(DeleteShopImpl(ProductRepository(ProductServices())));

  ViewState<AllProductsOfShopResponseModel> viewState = ViewState(state: ResponseState.EMPTY);
  void _setViewState(ViewState<AllProductsOfShopResponseModel> viewState) {
    this.viewState = viewState;
  }

  ViewState<DeleteProductResponse> deleteProductViewState = ViewState(state: ResponseState.EMPTY);
  void _setDeleteProductViewState(ViewState<DeleteProductResponse> deleteProductViewState) {
    this.deleteProductViewState = deleteProductViewState;
  }

  ViewState<UpdateProductResponse> updateProductViewState = ViewState(state: ResponseState.EMPTY);
  void _setUpdateProductViewState(ViewState<UpdateProductResponse> updateProductViewState) {
    this.updateProductViewState = updateProductViewState;
  }

  List<Products>? allProduct = <Products>[].obs;
  final picker = ImagePicker();
  XFile? productCategoryImage;
  XFile? productImage;

  final _homeController = Get.put(HomeController());

  Future<void> getAllProductOfShop() async {
    _setViewState(ViewState.loading());
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    await _homeController.getAShop();
    await getAllProduct.execute(params: GetProductOfShopParam(shopId.toString())).then((value) async {
      if(value is DataSuccess || value.data != null) {
        allProduct = value.data!.data;
        update();
        _setViewState(ViewState.complete(value.data!));
        update();
      }if (value is DataFailed || value.data == null) {
        if (kDebugMode) {
          print(value.error);
        }errorMessage = value.error.toString();
        _setViewState(ViewState.error(value.error.toString()));
        update();
      }}
    );
  }


  Future<void> onUpdateProduct({required String name, XFile? imageFile, required BuildContext context, required int productId, required String price, required String description, required int inStock, required int categoryId,})async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    await updateProduct.execute(params: UpdateProductDetailsImplParam(name, imageFile, context, productId, price, inStock, categoryId, shopId.toString(), description)).then((value) async {
      if(value is DataSuccess || value.data != null) {
        await getAllProductOfShop();
        _setUpdateProductViewState(ViewState.complete(value.data!));
        Get.back();
        Get.back();
        update();
      }
      if (value is DataFailed || value.data == null) {
        if (kDebugMode) {
          print(value.error.toString());
        }
        errorMessage = value.error.toString();
        _setUpdateProductViewState(ViewState.error(value.error.toString()));
        update();
      }}
    );
  }


  Future<void> onDeleteProduct({required int productId, required BuildContext context})async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    await deleteProduct.execute(params: DeleteProductParam(productId, context, shopId.toString())).then((value) async {
      if(value is DataSuccess || value.data != null) {
        await getAllProductOfShop();
        _setDeleteProductViewState(ViewState.complete(value.data!));
        update();
      }
      if (value is DataFailed || value.data == null) {
        if (kDebugMode) {
          print(value.error.toString());
        }
        errorMessage = value.error.toString();
        _setDeleteProductViewState(ViewState.error(value.error.toString()));
        update();
      }}
    );
  }

  void onUploadProductPhoto(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      productImage = pickedFile;
      update();
    } catch (e) {
      final pickImageError = e;
      update();
    }
  }

  List<ProductReview>? productReviewsResponse;
  bool? productReviewsLoadingState;
  bool? productReviewsErrorState;
  Future<void> getProductReview({required String productId})async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    // productReviewsLoadingState = true;
    // productReviewsErrorState = false;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/products/$productId/reviews", method: RequestMethod.get);
      productReviewsResponse = ProductReviewsResponse.fromJson(response!.data).data;
      // productReviewsLoadingState = false;
      // productReviewsErrorState = false;
      update();
    }on DioError catch (err) {
      // productReviewsLoadingState = false;
      // productReviewsErrorState = true;
      productDetailsResponsesLoadingState = false;
      productDetailsResponseErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));;
      throw errorMessage;
    } catch (err) {
      // productReviewsLoadingState = false;
      // productReviewsErrorState = true;
      productDetailsResponsesLoadingState = false;
      productDetailsResponseErrorState = true;
      update();
      throw err.toString();
    }
  }

  ProductDetailsResponse? productDetailsResponse;
  bool? productDetailsResponsesLoadingState;
  bool? productDetailsResponseErrorState;
  Future<void> getProductDetailsResponse({required String productId})async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final shopId = await LocalCachedData.instance.getShopId();
    productDetailsResponsesLoadingState = true;
    productDetailsResponseErrorState = false;
    update();
    try{
      final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/products/$productId", method: RequestMethod.get);
      productDetailsResponse = ProductDetailsResponse.fromJson(response!.data);
      await getProductReview(productId: productId);
      productDetailsResponsesLoadingState = false;
      productDetailsResponseErrorState = false;
      update();
    }on DioError catch (err) {
      productDetailsResponsesLoadingState = false;
      productDetailsResponseErrorState = true;
      update();
      final errorMessage = Future.error(ApiError.fromDio(err));;
      throw errorMessage;
    } catch (err) {
      productDetailsResponsesLoadingState = false;
      productDetailsResponseErrorState = true;
      update();
      throw err.toString();
    }
  }

  Future<void> addProductCategory({required String categoryName, required BuildContext context}) async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final token = await LocalCachedData.instance.getAuthToken().then((value){
      log(value.toString());
    });
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
        Get.snackbar("Success", payLoad.message ?? "Category added successfully", colorText: white, backgroundColor: greenPea);
      });
    }on dio.DioError catch (err) {
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

  getProductCategory() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final status = await LocalCachedData.instance.getIsBookableServiceStatus();
    if(status == true){
     null;
    }else{
      getCategory();
    }
  }

  @override
  void onInit() {
    getProductCategory();
    super.onInit();
  }
}