import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/app_config.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/material.dart';


class AuthServices{

  Future<Response?> login({required String email, required String password, required BuildContext context}) async {
    var postBody = jsonEncode({
        "email":  email,
        "password": password,
    });
    final response = await NetworkProvider().call(path: AppConfig.login, method: RequestMethod.post, body: postBody, context: context);
    return response;
  }

  Future<Response?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required BuildContext context,
  }) async {
    var postBody = jsonEncode({
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phoneNumber,
      "password": password,
    });
    final response = await NetworkProvider().call(path: AppConfig.register, method: RequestMethod.post, body: postBody, context: context);
    return response;
  }

  Future<Response?> getProductInCategory({required String shopId}) async {
    final response = await NetworkProvider().call(path: "/api/vendor/categories/categories-in-shop/$shopId", method: RequestMethod.get,);
    return response;
  }
}