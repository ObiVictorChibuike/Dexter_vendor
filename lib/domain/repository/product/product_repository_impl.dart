import 'package:dexter_vendor/app/shared/constants/http_status.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/core/use_cases/use_cases.dart';
import 'package:dexter_vendor/data/product_model/products_of_shop_model.dart';
import 'package:dexter_vendor/datas/repository/product_repository/product_repository.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class GetProductOfShopImpl implements useCase<DataState<AllProductsOfShopResponseModel>, GetProductOfShopParam> {
  final ProductRepository _productRepository;

  GetProductOfShopImpl(this._productRepository);

  Future<DataState<AllProductsOfShopResponseModel>> execute({required GetProductOfShopParam params}) async{
    try {
      final response = await _productRepository.getAllProduct(shopId: params.shopId!);
      if (response!.statusCode == HttpResponseStatus.ok || response.statusCode == HttpResponseStatus.success) {
        return DataSuccess(AllProductsOfShopResponseModel.fromJson(response.data));
      }
      return DataFailed(response.statusMessage);
    } on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      if (kDebugMode) {
        print(errorMessage);
      }
      return DataFailed(err.response?.data[Strings.message] ?? errorMessage);
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return DataFailed(err.toString());
    }
  }
}

class GetProductOfShopParam{
  final String? shopId;
  GetProductOfShopParam(this.shopId,);
}