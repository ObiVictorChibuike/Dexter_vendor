import 'package:dexter_vendor/app/shared/constants/http_status.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/core/use_cases/use_cases.dart';
import 'package:dexter_vendor/data/vendor_model/update_vendor_profile_response.dart';
import 'package:dexter_vendor/datas/model/user/update_user-response.dart';
import 'package:dexter_vendor/datas/repository/user_repository/user_repository.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


class UpdateUserImpl implements useCase<DataState<UpdateVendorProfileResponse>, UpdateUserProfileParam> {
  final UserRepository _userRepository;

  UpdateUserImpl(this._userRepository);

  Future<DataState<UpdateVendorProfileResponse>> execute({required UpdateUserProfileParam params}) async{
    try {
      final response = await _userRepository.updateUser(email: params.email!, firstName: params.firstName!, lastName: params.lastName!, phone: params.phone!);
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

class UpdateUserProfileParam{
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  UpdateUserProfileParam(this.firstName, this.lastName, this.email, this.phone,);
}