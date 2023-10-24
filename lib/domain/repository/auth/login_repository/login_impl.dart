import 'package:dexter_vendor/app/shared/constants/http_status.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/core/use_cases/use_cases.dart';
import 'package:dexter_vendor/data/auth_model/login_response.dart';
import 'package:dexter_vendor/datas/repository/auth_repository/auth_repository.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class LoginImpl implements useCase<DataState<LoginResponse>, LoginParam> {
  final AuthRepository _authRepository;

  LoginImpl(this._authRepository);

  @override
  Future<DataState<LoginResponse>> execute({required LoginParam params}) async{
    try {
      final response = await _authRepository.login(email: params.email!, password: params.password!, context: params.context);
      if (response!.statusCode == HttpResponseStatus.ok || response.statusCode == HttpResponseStatus.success) {
        return DataSuccess(LoginResponse.fromJson(response.data));
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

class LoginParam{
  final String? email;
  final String? password;
  final BuildContext context;
  LoginParam(this.email, this.password, this.context);
}

