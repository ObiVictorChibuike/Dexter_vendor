import 'package:dexter_vendor/datas/services/auth_services/auth_servcices.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final AuthServices _authServices;
  AuthRepository(this._authServices);

  Future<Response?> login({required String email, required String password, required BuildContext context}) => _authServices.login(email: email, password: password, context: context);

  Future<Response?> register({required String firstName, required String lastName, required String email,
    required String phoneNumber, required String password, required BuildContext context}) => _authServices.register(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, password: password, context: context);
  Future<Response?> getProductInCategory({required String shopId}) => _authServices.getProductInCategory(shopId: shopId);
}