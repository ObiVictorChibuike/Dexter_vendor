import 'package:dexter_vendor/app/shared/constants/http_status.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/core/use_cases/use_cases.dart';
import 'package:dexter_vendor/datas/model/vendor/create_shop_details_response.dart';
import 'package:dexter_vendor/datas/repository/vendor_repository/vendor_repository.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreateShopDetailImpl implements useCase<DataState<CreateShopDetailsResponse>, CreateShopDetailParam> {
  final VendorRepository _vendorRepository;

  CreateShopDetailImpl(this._vendorRepository);

  @override
  Future<DataState<CreateShopDetailsResponse>> execute({required CreateShopDetailParam params}) async{
    try {
      final response = await _vendorRepository.createShopDetails(shopId: params.shopId!,
          openedFrom: params.openedFrom!, openedTo: params.openedTo!, address: params.address!,
          email: params.email!, phone: params.phone!, minOrder: params.minOrder!, shippingCost: params.shippingCost!, context: params.context);
      if (response!.statusCode == HttpResponseStatus.ok || response.statusCode == HttpResponseStatus.success) {
        return DataSuccess(CreateShopDetailsResponse.fromJson(response.data));
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

class CreateShopDetailParam{
  final String? shopId;
  final String? openedFrom;
  final String? openedTo;
  final String? address;
  final String? email;
  final String? phone;
  final String? minOrder;
  final String? shippingCost;
  final BuildContext context;
  CreateShopDetailParam(this.shopId, this.openedFrom, this.openedTo, this.address, this.email, this.phone, this.minOrder, this.shippingCost, this.context);
}