import 'dart:convert';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/app_config.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dio/dio.dart';


class UserServices{
  Future<Response?> getUser() async {
    final response = await NetworkProvider().call(path: AppConfig.user, method: RequestMethod.get, context: null,);
    return response;
  }

  Future<Response?> updateUser({required String email, required String firstName, required String lastName, required String phone}) async {
    var postBody = jsonEncode({
      "_method": "patch",
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone
    });
    final response = await NetworkProvider().call(path: AppConfig.updateUser, method: RequestMethod.post, body: postBody);
    return response;
  }
}