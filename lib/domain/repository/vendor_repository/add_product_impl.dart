import 'package:dexter_vendor/app/shared/constants/http_status.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/core/use_cases/use_cases.dart';
import 'package:dexter_vendor/data/product_model/add_product_to_category_response.dart';
import 'package:dexter_vendor/datas/repository/vendor_repository/vendor_repository.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductImpl implements useCase<DataState<AddProductToCategoryResponse>, AddProductImplParam> {
  final VendorRepository _vendorRepository;

  AddProductImpl(this._vendorRepository);

  @override
  Future<DataState<AddProductToCategoryResponse>> execute({required AddProductImplParam params}) async{
    try {
      final response = await _vendorRepository.createProduct(name: params.name!, imageFile: params.imageFile!,
          price: params.price!, description: params.description!, context: params.context, shopId: params.shopId, categoryId: params.categoryId);
      if (response!.statusCode == HttpResponseStatus.ok || response.statusCode == HttpResponseStatus.success) {
        return DataSuccess(AddProductToCategoryResponse.fromJson(response.data));
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

class AddProductImplParam{
  final String? name;
  final XFile? imageFile;
  final String? price;
  final String? description;
  final String shopId;
  final String categoryId;
  final BuildContext context;
  AddProductImplParam(this.name, this.imageFile, this.price, this.description, this.context, this.shopId, this.categoryId);
}