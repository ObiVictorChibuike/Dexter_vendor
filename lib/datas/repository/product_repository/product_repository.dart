import 'package:dexter_vendor/datas/services/product_services/product_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductRepository {
  final ProductServices _productServices;
  ProductRepository(this._productServices);

  Future<Response?> getAllProduct({required String shopId}) => _productServices.getAllProduct(shopId: shopId);

  Future<Response?> updateVotersDetails({XFile? imageFile, required String name, required String description, required int inStock, required String price, required int categoryId, required int productId,  required String shopId, required BuildContext context,}) =>
      _productServices.updateProductDetails(imageFile: imageFile, name: name, price: price,categoryId: categoryId, productId: productId, shopId: shopId, context: context, description: description, inStock: inStock);

  Future<Response?> deleteProduct({required int productId, required String shopId, required BuildContext context}) =>
      _productServices.deleteProduct(productId: productId, shopId: shopId, context: context);
}