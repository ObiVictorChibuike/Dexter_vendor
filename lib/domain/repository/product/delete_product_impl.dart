import 'package:dexter_vendor/app/shared/constants/http_status.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/core/use_cases/use_cases.dart';
import 'package:dexter_vendor/datas/model/product/delete_product_response_model.dart';
import 'package:dexter_vendor/datas/repository/product_repository/product_repository.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class DeleteShopImpl implements useCase<DataState<DeleteProductResponse>, DeleteProductParam>  {
  final ProductRepository _productRepository;

  DeleteShopImpl(this._productRepository);

  Future<DataState<DeleteProductResponse>> execute({required DeleteProductParam params}) async{
    try {
      final response = await _productRepository.deleteProduct(productId: params.productId!, shopId: params.shopId!, context: params.context!);
      if (response!.statusCode == HttpResponseStatus.ok || response.statusCode == HttpResponseStatus.success) {
        return DataSuccess(DeleteProductResponse.fromJson(response.data));
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

class DeleteProductParam{
  final int? productId;
  final String? shopId;
  final BuildContext? context;
  DeleteProductParam(this.productId, this.context, this.shopId);
}