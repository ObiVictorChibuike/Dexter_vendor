import 'package:dexter_vendor/app/shared/constants/http_status.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/core/use_cases/use_cases.dart';
import 'package:dexter_vendor/datas/model/vendor/vendor_shop_response.dart';
import 'package:dexter_vendor/datas/repository/vendor_repository/vendor_repository.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class GetAShopImpl implements useCase<DataState<VendorShopResponse>, GetVendorShopParam>  {
  final VendorRepository _vendorRepository;

  GetAShopImpl(this._vendorRepository);

  Future<DataState<VendorShopResponse>> execute({required GetVendorShopParam params}) async{
    try {
      final response = await _vendorRepository.getAsShop(shopId: params.shopId!);
      if (response!.statusCode == HttpResponseStatus.ok || response.statusCode == HttpResponseStatus.success) {
        return DataSuccess(VendorShopResponse.fromJson(response.data));
      }
      return DataFailed(response.statusMessage);
    } on DioError catch (err) {
      final errorMessage = Future.error(ApiError.fromDio(err));
      if (kDebugMode) {
        print(errorMessage);
      }
      throw DataFailed(err.response?.data[Strings.message] ?? errorMessage);
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      throw DataFailed(err.toString());
    }
  }
}

class GetVendorShopParam{
  final String? shopId;
  GetVendorShopParam(this.shopId,);
}