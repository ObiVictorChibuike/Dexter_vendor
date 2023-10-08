import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:clean_dialog/clean_dialog.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/presentation/auth/create_account/controller/registration_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor_overview/vendor_overview.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dexter_vendor/widget/custom_snack.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class AddProducts extends StatefulWidget {
  final bool? isFromProductScreen;
  const AddProducts({Key? key, this.isFromProductScreen}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> with FormMixin{
  final _controller = Get.put(RegistrationController());

  showAlertDialog(){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: 'Registration completion',
        content: "Welcome to Dexter Vendor App. To complete your registration journey, "
            "you're required to add at least one of your product details. "
            "Kindly, explore the product section to add more of your product when you're fully onboarded",
        backgroundColor: greenPea,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Ok',
              textColor: greenPea,
              onPressed: (){
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }

  showCategoryDialog(){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: 'Empty Category Notice',
        content: "You don't have any category yet. kindly add a category for your product.",
        backgroundColor: greenPea,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Ok',
              textColor: greenPea,
              onPressed: (){
                Navigator.pop(context);
                showNewCategoryBottomSheet(context);
              }
          ),
          CleanDialogActionButtons(
              actionTitle: 'Cancel',
              textColor: persianRed,
              onPressed: (){
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }

  showNotification() {
    var duration = const Duration(seconds: 1);
      return Timer(duration, ()=>showAlertDialog());
  }

  Widget _descriptionForm({required String hintText, required TextEditingController descriptionController}){
    var maxLine = 11;
    return Container(height: maxLine * 15.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        controller: descriptionController, textCapitalization: TextCapitalization.sentences,
        cursorHeight: 18,
        textInputAction: TextInputAction.next, keyboardType: TextInputType.text,
        validator: (value){
          if(value!.isEmpty){
            return "Please enter description";
          }
          // else if (value.split(" ").length > 50){
          //   return "Reached max words count";
          // }else if(value.split(" ").length < 5){
          //  return "Must not be less than 5 words";
          // }
          return null;
        },
        maxLines: maxLine,
        decoration: InputDecoration(
          counterText: " ",
          hintText: hintText,
          hintStyle: TextStyle(color: const Color(0xff9C9C9C), fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
          fillColor: Color(0xffEFEFF0),
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  void showNewCategoryBottomSheet(BuildContext context){
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(height: MediaQuery.of(context).size.height/1.6, color: Colors.white,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 26,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("New category",  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 25, fontWeight: FontWeight.w700, color: black)),
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(
                      child: Icon(
                        Icons.clear, size: 23,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 38,),
              Text('Category name',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 14, color: black),
              ),
              const SizedBox(
                height: 8,
              ),
              DexterTextField(
                keyboardType: TextInputType.text,
                controller: categoryNameController,
                minLines: null, maxLines: 1, expands: false,
                hintText: "Name of category",
                validator: isRequired,
              ),
              const SizedBox(height: 16,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Item description (Optional)',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  ),
                  Text(' Max. 50 words',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 13, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 8,),
              _descriptionForm(hintText: "Describe this category", descriptionController: categoryDescriptionController),
              const SizedBox(height: 32,),
              DexterPrimaryButton(
                onTap: () async {
                  if(categoryNameController.text.isEmpty){
                    Get.snackbar("Error", "Please enter category name");
                  }else{
                    Get.back();
                    _controller.addProductCategory(categoryName: categoryNameController.text, context: context).then((value){
                      categoryNameController.clear();
                      categoryDescriptionController.clear();
                    });
                  }},
                buttonBorder: greenPea, btnTitle: "Create",
                borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
              ),
            ],
          ),
        ),
      ), backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), isDismissible: false, isScrollControlled: true
    );
  }

  final _productController = Get.put(ProductController());

  Future<void> addProduct(RegistrationController controller, {required String name, XFile? imageFile, required String productName, required XFile productImage, required String productPrice, required String description})async{
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      widget.isFromProductScreen == true ? await controller.addProductFromApp(categoryName: name, imageFile: imageFile ?? null, productName: productName, productImage: productImage,
          productPrice: productPrice, description: description, inStock: showAvailability == true ? 1 : 0) :
      await controller.addVendorProduct(categoryName: name, imageFile: imageFile ?? null, productName: productName, productImage: productImage,
          productPrice: productPrice, description: description, inStock: showAvailability == true ? 1 : 0);
      if(controller.onHasAddProductIsLoading == true){
        if(widget.isFromProductScreen == true){
          await _productController.getAllProductOfShop();
          Get.back();
          Get.back();
          Get.offAll(() => VendorOverView());
        }else{
          Get.back();
          Get.offAll(() => VendorOverView());
        }
      } else if(controller.onHasAddProductIsLoading == false){
        Get.back();
        Get.snackbar("Something Went Wrong", controller.errorMessages ?? "Check your Internet connections", backgroundColor: persianRed, colorText: white);
      }
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<RegistrationController>(
          init: RegistrationController(),
            builder: (controller){
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: Text('Upload product photo', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Take a photo'),
                onPressed: () async {
                  Get.back();
                  _controller.onUploadProductPhoto(ImageSource.camera);
                  setState(() {});
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Choose from Gallery'),
                onPressed: () async {
                  Get.back();
                  _controller.onUploadProductPhoto(ImageSource.gallery);
                  setState(() {});
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  void initState() {
    widget.isFromProductScreen == null ? showNotification() : null;
    super.initState();
  }


  @override
  void dispose() {
    itemNameController.dispose();
    categoryNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    categoryDescriptionController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey <FormState>();
  final itemNameController = TextEditingController();
  final categoryNameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryDescriptionController = TextEditingController();
  bool showAvailability = true;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      init: Get.find<RegistrationController>(),
        builder: (controller){
      return SafeArea(top: false, bottom: false,
          child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              leading: GestureDetector(
                onTap: (){
                  widget.isFromProductScreen == null ? null:
                  Navigator.pop(context);
                  },
                child: const Icon(Iconsax.arrow_left, color: black,),
              ),
              elevation: 0.0, backgroundColor: white,
              title: Text("Add item", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
            ),
            body: Form(
              key: formKey,
              child: AnimatedColumn(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  const SizedBox(height: 22,),
                  Text('Product image',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  ),
                  const SizedBox(height: 8,),
                  GestureDetector(
                    onTap: (){
                      _selectImage(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 154, width: double.maxFinite,
                        decoration: BoxDecoration(color: Color(0xffEFEFF0),
                            borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xff868484))),
                        child: controller.productImage == null ? Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(AssetPath.upload, height: 40, width: 40),
                            const SizedBox(height: 16,),
                            Text('Upload product image',
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff9C9C9C)),
                            ),
                            const SizedBox(height: 4,),
                            Text('W: 375px H: 200px',
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xff5B5B5B)),
                            ),
                          ],
                        ) : Image.file(File(controller.productImage!.path), fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(text: TextSpan(text: 'Kindly upload a clear shot or image of your product',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey,),
                  )),
                  const SizedBox(height: 24,),
                  Text('Item name',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  ),
                  const SizedBox(height: 8,),
                  DexterTextField(
                    controller: itemNameController,
                    keyboardType: TextInputType.name,
                    minLines: null, maxLines: 1, expands: false,
                    hintText: "",
                    validator: isRequired,
                  ),
                  const SizedBox(height: 5,),
                  RichText(text: TextSpan(text: 'Please, kindly provide name of the item', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                  )),
                  const SizedBox(height: 16,),
                  Text('Price', style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: black),),
                  const SizedBox(height: 8,),
                  DexterTextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    minLines: null, maxLines: 1, expands: false,
                    hintText: "",
                    validator: isRequired,
                  ),
                  const SizedBox(height: 5,),
                  RichText(text: TextSpan(text: 'Please, kindly provide price of the item in naira', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                  )),
                  const SizedBox(height: 16,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Item description', style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: black),),
                      Text(' Max. 50 words',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 12, color: persianRed),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  _descriptionForm(hintText: "Package content includes the following Chicken, French Fries, Soft drink", descriptionController: descriptionController),
                  RichText(text: TextSpan(text: 'Please ensure you provide a brief description of your Product/Package and its content', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey,)
                  )),
                  const SizedBox(height: 16,),
                  Text('Item category',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: (){
                      if(_controller.shopProductCategoryResponse!.data!.isEmpty || _controller.shopProductCategoryResponse!.data == []){
                        showCategoryDialog();
                      }else{
                        log("List is empty");
                      }
                    },
                    child: DropdownButtonFormField2(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                        errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                      ),
                      isExpanded: true,
                      hint: Text("Categories", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color(0xff868484), fontSize: 15)),
                      items: _controller.shopProductCategoryResponse!.data!.map((item) => DropdownMenuItem<String>(
                        value: item.name ?? "",
                        child: Text(item.name ?? "", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 15)),
                      )).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select product category';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        categoryNameController.text = value!;
                        controller.selectedCategory = value;
                        setState(() {});
                      },
                      buttonStyleData: ButtonStyleData(height: 48, padding: EdgeInsets.only(left: 0, right: 10),
                          decoration: BoxDecoration(color: Color(0xffEFEFF0), borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Color(0xff868484), width: 0.7))),
                      iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: black, size: 18,), iconSize: 30,),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35,),
                  GestureDetector(
                    onTap: (){
                      setState(() {});
                      showNewCategoryBottomSheet(context);
                    },
                    child: Text('+ New category',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14, color: greenPea),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(text: TextSpan(text: 'If your product do not fall under the provided categories, click here to add product category',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey),
                  )),
                  const SizedBox(height: 16,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Product Availability",style:Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14, color: black)),
                      CupertinoSwitch(value: showAvailability, activeColor: greenPea,
                          onChanged: (value){
                        setState(() {
                          showAvailability = value;
                        });
                      })
                    ],
                  ),
                  const SizedBox(height: 40,),
                  DexterPrimaryButton(
                    onTap: (){
                      if(_controller.shopProductCategoryResponse!.data!.isEmpty || _controller.shopProductCategoryResponse?.data == []){
                        Get.snackbar("Error", "Please add a category and attach the product to it");
                      }else if(controller.selectedCategory == null){
                        Get.snackbar("Error", "Please select a category");
                      }else if(controller.productImage == null){
                          Get.snackbar("Error", "Please pick a product image");
                      }else {
                        addProduct(controller, name: categoryNameController.text,
                            imageFile: controller.productCategoryImage,
                            productName: itemNameController.text, productImage:
                            controller.productImage!, productPrice: priceController.text,
                            description: descriptionController.text
                        ).then((value){
                          controller.productImage = null;
                        });
                      }
                    },
                    buttonBorder: greenPea, btnTitle: "Add",
                    borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
                  ),
                  const SizedBox(height: 41,),
                ],
              ),
            ),
          )
      );
    });
  }
}
