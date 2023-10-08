import 'dart:convert';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VendorServices{
  Future<Response?> postBasicDetail({required String id, required String qualification, required String street,
    required String city,required String state, required XFile imageFile, required BuildContext context}) async {
    // final file = await MultipartFile.fromFile(
    //   imageFile.path,
    //   filename: imageFile.name,
    // );
    var postBody = FormData.fromMap({
      "_method": "put",
      "vendor_id": int.parse(id),
      "qualification": qualification,
      "street": street,
      "city": city,
      "state": "Lagos state",
      "image": await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
      "nin": null,
    });
    final response = await NetworkProvider().call(path: "/api/vendor/basic-detail/update", method: RequestMethod.post, body: postBody, context: context);
    return response;
  }

  Future<Response?> createShop({required String id, required String name,
    required String bio, required XFile imageFile, required String openedFrom, required String openedTo,  required String address,
    required String email, required String phone,
    required BuildContext context}) async {
    var postBody = FormData.fromMap({
      "vendor_id": id,
      "name": name,
      "bio": bio,
      "cover_image": await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
      "opened_from": openedFrom,
      "opened_to": openedTo,
      "address": address,
      "email": email,
      "phone": phone,
      "min_order": null,
      "shippingcost": null,
      "additionalcharge": null,
    });
    final response = await NetworkProvider().call(path: "/api/vendor/create-shop", method: RequestMethod.post, body: postBody, context: context, );
    return response;
  }

  Future<Response?> createShopDetails({required String shopId,
    required String openedFrom, required String openedTo,  required String address,
    required String email, required String phone, required String minOrder, required String shippingCost, required BuildContext context
    }) async {
    var postBody = jsonEncode({
      "shop_id": shopId,
      "opened_from": openedFrom,
      "opened_to": openedTo,
      "address": address,
      "email": email,
      "phone": phone,
      "min_order": minOrder,
      "shippingcost": shippingCost
    });
    final response = await NetworkProvider().call(path: "/api/vendor/shop/create-details/", method: RequestMethod.post, body: postBody, context: context);
    return response;
  }

  Future<Response?> createProduct({required String shopId, required String categoryId, required String name,
    required XFile imageFile, required String price,
    required String description, required BuildContext context}) async {
    final file = await MultipartFile.fromFile(
      imageFile.path,
      filename: imageFile.name,
    );
    var postBody = FormData.fromMap({
      "shop_id": shopId,
      "category_id": categoryId,
      "name": name,
      "image": file,
      "price": price,
      "description": description
    });
    final response = await NetworkProvider().call(path: "/api/vendor/products/store", method: RequestMethod.post, body: postBody, context: context);
    return response;
  }

  Future<Response?> createCategory({required String id, required String name ,XFile? imageFile, required BuildContext context}) async {
    MultipartFile? file = imageFile == null ? null : await MultipartFile.fromFile(
      imageFile.path,
      filename: imageFile.name,
    );
    var postBody = FormData.fromMap({
      "shop_id": id,
      "name": name,
      "cover_image": file == null ? null : file,
    });
    final response = await NetworkProvider().call(path: "/api/vendor/categories/create", method: RequestMethod.post, body: postBody, context: context);
    return response;
  }

  Future<Response?> storeVendorType({required String serviceId, required String vendorId}) async {
    var postBody = jsonEncode({
      "service_id": serviceId,
      "vendor_id": vendorId,
    });
    final response = await NetworkProvider().call(path: "/api/vendor/store-service", method: RequestMethod.put, body: postBody,);
    return response;
  }

  Future<Response?> getAShop({required String shopId}) async {
    final response = await NetworkProvider().call(path: "/vendor/shops/$shopId", method: RequestMethod.get, context: null,);
    return response;
  }
}