import 'package:dexter_vendor/datas/services/vendor_services/vendor_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VendorRepository {
  final VendorServices _vendorServices;
  VendorRepository(this._vendorServices);

  Future<Response?> postBasicDetail({required String id, required String qualification, required String street,
    required String city,required String state, required XFile imageFile, required BuildContext context}) =>
      _vendorServices.postBasicDetail(id: id, qualification: qualification, street: street, city: city, state: state, imageFile: imageFile, context: context);

  Future<Response?> createShop({required String id, required String name,
    required String bio, required XFile imageFile, required String openedFrom, required String openedTo,  required String address,
    required String email, required String phone,
    required BuildContext context}) =>
      _vendorServices.createShop(id: id, name: name, bio: bio, imageFile: imageFile, context: context,
          openedFrom: openedFrom, openedTo: openedTo, address: address, email: email, phone: phone);

  Future<Response?> createShopDetails({required String shopId,
    required String openedFrom, required String openedTo,  required String address,
    required String email, required String phone, required String minOrder, required String shippingCost, required BuildContext context,}) =>
      _vendorServices.createShopDetails(shopId: shopId, openedFrom: openedFrom,
          openedTo: openedTo, address: address, email: email, phone: phone, minOrder: minOrder, shippingCost: shippingCost, context: context);

  Future<Response?> createCategory({required String id, required String name,XFile? imageFile, required BuildContext context}) =>
      _vendorServices.createCategory(id: id, name: name, imageFile: imageFile, context: context);
  Future<Response?> createProduct({required String shopId, required String categoryId, required String name,
    required XFile imageFile, required String price, required String description, required BuildContext context}) =>
      _vendorServices.createProduct(name: name, imageFile: imageFile, price: price, description: description, context: context, shopId: shopId, categoryId: categoryId);

  Future<Response?> storeVendorType({required String serviceId, required String vendorId}) =>
      _vendorServices.storeVendorType(serviceId: serviceId, vendorId: vendorId);

  Future<Response?> getAsShop({required String shopId}) => _vendorServices.getAShop(shopId: shopId);
}