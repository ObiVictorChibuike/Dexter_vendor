import 'dart:developer';
import 'package:dexter_vendor/app/shared/constants/http_status.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/core/use_cases/use_cases.dart';
import 'package:dexter_vendor/datas/model/product/update_product_of_shop_model.dart';
import 'package:dexter_vendor/datas/repository/product_repository/product_repository.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProductImpl implements useCase<DataState<UpdateProductResponse>, UpdateProductDetailsImplParam> {
  final ProductRepository _productRepository;

  UpdateProductImpl(this._productRepository);

  @override
  Future<DataState<UpdateProductResponse>> execute({required UpdateProductDetailsImplParam params}) async{
    try {
      final response = await _productRepository.updateVotersDetails(imageFile: params.imageFile ?? null,
          name: params.name!,  context: params.context, productId: params.productId!, price: params.price!, inStock: params.inStock, categoryId: params.categoryId, shopId: params.shopId!, description: params.description!, );
      if (response!.statusCode == HttpResponseStatus.ok || response.statusCode == HttpResponseStatus.success) {
        log(response.statusCode.toString());
        return DataSuccess(UpdateProductResponse.fromJson(response.data));
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

class UpdateProductDetailsImplParam{
  final String? name;
  final String? description;
  final XFile? imageFile;
  final BuildContext context;
  final int? productId;
  final String? price;
  final int inStock;
  final int categoryId;
  final String? shopId;
  UpdateProductDetailsImplParam(this.name,this.imageFile, this.context, this.productId, this.price, this.inStock,this.categoryId, this.shopId, this.description);
}