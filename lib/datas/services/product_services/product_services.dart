import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductServices{
  Future<Response?> getAllProduct({required String shopId}) async {
    final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/products", method: RequestMethod.get, context: null,);
    return response;
  }

  Future<Response?> updateProductDetails({required XFile? imageFile, required String name, required String description, required int inStock, required int categoryId, required String price, required int productId, required String shopId, required BuildContext context}) async {
    var postBody = FormData.fromMap({
      "image": imageFile == null ? null : await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
      "name": name,
      "description": description,
      "in_stock": inStock,
      "price": price,
      "category_id": categoryId,
      "_method": "patch"
    });
    final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/products/$productId", method: RequestMethod.post, body: postBody, context: context);
    return response;
  }

  Future<Response?> deleteProduct({required int productId, required String shopId, required BuildContext context}) async {
    final response = await NetworkProvider().call(path: "/vendor/shops/$shopId/products/$productId", method: RequestMethod.delete, context: context);
    return response;
  }
}