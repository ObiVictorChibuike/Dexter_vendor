import 'package:dexter_vendor/app/shared/constants/http_status.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/core/use_cases/use_cases.dart';
import 'package:dexter_vendor/data/vendor_model/update_vendor_profile_response.dart';
import 'package:dexter_vendor/datas/model/vendor/store_vendor_style.dart';
import 'package:dexter_vendor/datas/repository/vendor_repository/vendor_repository.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BasicDetailsImpl implements useCase<DataState<UpdateVendorProfileResponse>, CreateBasicDetailsParam> {
  final VendorRepository _vendorRepository;

  BasicDetailsImpl(this._vendorRepository);

  @override
  Future<DataState<UpdateVendorProfileResponse>> execute({required CreateBasicDetailsParam params}) async{
    try {
      final response = await _vendorRepository.postBasicDetail(id: params.id!, qualification: params.qualification!,
          street: params.street!, city: params.city!, state: params.state!, imageFile: params.imageFile, context: params.context);
      if (response!.statusCode == HttpResponseStatus.ok || response.statusCode == HttpResponseStatus.success) {
        return DataSuccess(UpdateVendorProfileResponse.fromJson(response.data));
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

class CreateBasicDetailsParam{
  final String? id;
  final String? qualification;
  final String? street;
  final String? city;
  final String? state;
  final XFile imageFile;
  final BuildContext context;
  CreateBasicDetailsParam(this.id, this.qualification, this.street, this.city,this.state, this.imageFile, this.context);
}

class StoreVendorTypeImpl implements useCase<DataState<StoreVendorTypeResponse>, StoreVendorTypParam> {
  final VendorRepository _vendorRepository;

  StoreVendorTypeImpl(this._vendorRepository);

  @override
  Future<DataState<StoreVendorTypeResponse>> execute({required StoreVendorTypParam params}) async{
    try {
      final response = await _vendorRepository.storeVendorType(serviceId: params.serviceId, vendorId: params.vendorId);
      if (response!.statusCode == HttpResponseStatus.ok || response.statusCode == HttpResponseStatus.success) {
        return DataSuccess(StoreVendorTypeResponse.fromJson(response.data));
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

class StoreVendorTypParam{
  final String serviceId;
  final String vendorId;
  StoreVendorTypParam(this.serviceId, this.vendorId);
}