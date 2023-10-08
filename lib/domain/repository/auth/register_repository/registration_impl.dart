import 'package:dexter_vendor/app/shared/constants/http_status.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/data/auth_model/registration_response.dart';
import 'package:dexter_vendor/datas/repository/auth_repository/auth_repository.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_data_state.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../core/use_cases/use_cases.dart';


class RegistrationImpl implements useCase<DataState<RegistrationResponse>, OnBoardingStageOneParam> {
  final AuthRepository _authRepository;

  RegistrationImpl(this._authRepository);

  @override
  Future<DataState<RegistrationResponse>> execute({required OnBoardingStageOneParam params}) async{
    try {
      final response = await _authRepository.register(firstName: params.firstName!, lastName: params.lastName!,
          email: params.email!, phoneNumber: params.phone!, password: params.password!, context: params.context);
      if (response!.statusCode == HttpResponseStatus.ok || response.statusCode == HttpResponseStatus.success) {
        return DataSuccess(RegistrationResponse.fromJson(response.data));
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

class OnBoardingStageOneParam{
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? password;
  final BuildContext context;
  OnBoardingStageOneParam(this.firstName, this.lastName, this.email, this.phone, this.password, this.context);
}

