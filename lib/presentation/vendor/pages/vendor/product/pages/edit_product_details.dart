import 'dart:developer';
import 'dart:io';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/core/state/view_state.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/controller/controller.dart';
import 'package:dexter_vendor/widget/custom_snack.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class EditProductDetails extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final bool inStock;
  final String productName;
  final String productPrice;
  final String imageUrl;
  final String description;
  final int productId;
  const EditProductDetails({Key? key, required this.productName, required this.productPrice, required this.imageUrl, required this.productId, required this.description, required this.inStock, required this.categoryId, required this.categoryName}) : super(key: key);

  @override
  State<EditProductDetails> createState() => _EditProductDetailsState();
}

class _EditProductDetailsState extends State<EditProductDetails> with FormMixin{
  final _controller = Get.find<ProductController>();
  final formKey = GlobalKey <FormState>();
  String? imageUrl;
  int? categoryId;
  int? productId;
  final itemNameController = TextEditingController();
  final priceController = TextEditingController();
  bool? showAvailability;

  covertImageUrlToFile(){
    imageUrl = widget.imageUrl;
    if(imageUrl != null && imageUrl != ""){
      getImage(url: imageUrl!);
    }else{
      null;
    }
  }

  final categoryNameController = TextEditingController();
  String selectedCategory = "";
  final categoryDescriptionController = TextEditingController();


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
                    Text(' Max. 150 words',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff999999)),
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                _descriptionForm(context: context, hintText: "Describe this category", descriptionController: categoryDescriptionController),
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

  final descriptionController = TextEditingController();
  Widget _descriptionForm({required BuildContext context, required String hintText, required TextEditingController descriptionController}){
    var maxLine = 11;
    return Container(height: maxLine * 18.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),),
      child: TextFormField(
        validator: (value){
          if(value!.isEmpty){
            return "Please enter business description";
          }else if (value.split(" ").length > 40){
            return "Reached max words";
          }else if(value.split(" ").length < 30){
            return "Must not be less than 30 words";
          }
          return null;
        },
        controller: descriptionController, textCapitalization: TextCapitalization.sentences,
        cursorHeight: 18,
        textInputAction: TextInputAction.none, keyboardType: TextInputType.text,
        maxLines: maxLine,
        decoration: InputDecoration(
          counterText: " ",
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff868484), fontSize: 14),
          labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xff868484), fontSize: 14),
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
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }

  Future<File> getImage({required String url}) async {
    /// Get Image from server
    final dio.Response res = await dio.Dio().get<List<int>>(
      url, options: dio.Options(
      responseType: dio.ResponseType.bytes,
    ),);
    /// Get App local storage
    final Directory appDir = await getApplicationDocumentsDirectory();
    /// Generate Image Name
    final String imageName = url.split('/').last;
    /// Create Empty File in app dir & fill with new image
    final File file = File(join(appDir.path, imageName));
    file.writeAsBytesSync(res.data as List<int>);
    XFile xFile = new XFile(file.path);
    setState(() {
      _controller.productImage = xFile;
    });
    return file;
  }

  @override
  void initState() {
    // _controller.getCategory();
    productId = widget.productId;
    itemNameController.text = widget.productName;
    priceController.text = widget.productPrice.toString();
    descriptionController.text = widget.description;
    showAvailability = widget.inStock;
    categoryNameController.text = widget.categoryName;
    selectedCategory = widget.categoryName;
    categoryId = widget.categoryId;
    covertImageUrlToFile();
    setState(() {});
    super.initState();
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: white,
          title: Text('Create a Post', style: Theme.of(context).textTheme.bodyLarge?.copyWith(),),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      init: ProductController(),
        builder: (controller){
          void updateProduct(BuildContext context, ProductController controller)async{
            await controller.onUpdateProduct(name: itemNameController.text, imageFile: controller.productImage ?? null,
                context: context, productId: widget.productId, price: priceController.text, description: descriptionController.text ?? '',
                inStock: showAvailability == true ? 1 : 0, categoryId: categoryId!);
            if(controller.updateProductViewState.state == ResponseState.COMPLETE){
              Get.back();
              Get.snackbar("Success",  controller.updateProductViewState.data?.message ?? "Product updated successfully", colorText: white, backgroundColor: greenPea);
            }else if(controller.updateProductViewState.state == ResponseState.ERROR){
              Get.back();
              Get.snackbar("Something Went Wrong",  controller.errorMessage ?? "Check your Internet connections", colorText: white, backgroundColor: persianRed);
            }
          }
      return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          centerTitle: true,
          leading: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xffF2F2F2), shape: BoxShape.circle),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              )),
          title: Text("Edit Product Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
        ),
        body: AnimatedColumn(
            children: [
              const SizedBox(height: 22,),
              Text('Product image',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff9C9C9C)),
                        ),
                        const SizedBox(height: 4,),
                        Text('W: 375px H: 200px',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
              RichText(text: TextSpan(text: "Notice: ", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w800, fontSize: 8, color: Colors.red, ),children: [
                TextSpan(text: 'Kindly upload a clear shot or image of your product',
                    style: Theme.of(context).textTheme.bodyLarge!.
                    copyWith(fontWeight: FontWeight.w400, fontSize: 8, color: black))
              ]
              )),
              const SizedBox(height: 24,),
              Text('Item name',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 14, color: black),
              ),
              const SizedBox(height: 8,),
              DexterTextField(
                controller: itemNameController,
                keyboardType: TextInputType.name,
                minLines: null, maxLines: 1, expands: false,
                hintText: "Name of this item",
                validator: isRequired,
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(text: TextSpan(text: "Notice: ", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w800, fontSize: 8, color: Colors.red, ),children: [
                TextSpan(text: 'Kindly make correction to product name if any mistake',
                    style: Theme.of(context).textTheme.bodyLarge!.
                    copyWith(fontWeight: FontWeight.w400, fontSize: 8, color: black))
              ]
              )),
              const SizedBox(height: 16,),
              Text('Price',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 14, color: black),
              ),
              const SizedBox(height: 8,),
              DexterTextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                minLines: null, maxLines: 1, expands: false,
                hintText: "₦ 2000",
                validator: isRequired,
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(text: TextSpan(text: "Notice: ", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w800, fontSize: 8, color: Colors.red, ),children: [
                TextSpan(text: 'Kindly make corrections to the account if any mistake',
                    style: Theme.of(context).textTheme.bodyLarge!.
                    copyWith(fontWeight: FontWeight.w400, fontSize: 8, color: black))
              ]
              )),
              const SizedBox(height: 16,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shop Bio',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  ),
                  Text(' Max. 150 words',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500, fontSize: 11, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              _descriptionForm(context: context, hintText: "Describe your product to your audience", descriptionController: descriptionController),
              const SizedBox(
                height: 5,
              ),
              RichText(text: TextSpan(text: "Notice: ", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w800, fontSize: 8, color: Colors.red, ),children: [
                TextSpan(text: 'Please ensure you provide a detailed description of your shop or'
                    ' enter mission and vision. These would help customers to know '
                    'what you represent and stand for.', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: black))
              ]
              )),
              const SizedBox(height: 16,),
              Text('Item category',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 14, color: black),
              ),
              const SizedBox(
                height: 8,
              ),
              DropdownButtonFormField2(
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
                hint: Text(selectedCategory ?? "", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 15)),
                items: _controller.shopProductCategoryResponse == null || _controller.shopProductCategoryResponse?.data == [] ? [""].map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 15)),
                )).toList() : _controller.shopProductCategoryResponse!.data!.map((item) => DropdownMenuItem<String>(
                  value: item.id.toString() ?? "",
                  child: Text(item.name ?? "", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 15)),
                )).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select product category';
                  }
                  return null;
                },
                onChanged: (value) {
                  categoryId = int.parse(value!);
                  log(categoryId.toString());
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
              RichText(text: TextSpan(text: "Notice: ", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w800, fontSize: 8, color: Colors.red, ),children: [
                TextSpan(text: 'If your product do not fall under the provided categories, click here to add product category', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: black))
              ]
              )),
              const SizedBox(height: 16,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Product Availability",style:Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 14, color: black)),
                  CupertinoSwitch(value: showAvailability ?? true, activeColor: greenPea,
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
                  updateProduct(context, controller);
                },
                buttonBorder: greenPea, btnTitle: "Update",
                borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
              ),
          const SizedBox(height: 41,),
            ], padding: EdgeInsets.symmetric(horizontal: 20)),
      );
    });
  }
}
