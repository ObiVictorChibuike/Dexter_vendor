import 'package:dexter_vendor/app/shared/constants/http_status.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/core/use_cases/use_cases.dart';
import 'package:dexter_vendor/data/vendor_model/vendor_profile_response.dart';
import 'package:dexter_vendor/datas/repository/user_repository/user_repository.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class UserRepositoryImpl implements noParamUseCases<DataState<VendorProfileResponse>> {
  final UserRepository _userRepository;

  UserRepositoryImpl(this._userRepository);

  Future<DataState<VendorProfileResponse>> noParamCall() async{
    try {
      final response = await _userRepository.getUser();
      if (response!.statusCode == HttpResponseStatus.ok || response.statusCode == HttpResponseStatus.success) {
      return DataSuccess(VendorProfileResponse.fromJson(response.data));
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