import 'dart:developer';
import 'dart:io';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/pages/edit_shop_detials.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class EditShop extends StatefulWidget {
  const EditShop({Key? key}) : super(key: key);

  @override
  State<EditShop> createState() => _EditShopState();
}

class _EditShopState extends State<EditShop> with FormMixin{
  final _controller = Get.put(ProductController());
  final descriptionController = TextEditingController();
  String? imageUrl;

  Widget _businessDescriptionForm({required BuildContext context}){
    var maxLine = 11;
    return Container(height: maxLine * 18.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),),
      child: TextFormField(
        validator: (value){
          List<String> words = value!.trim().split(' ');
          words = words.where((word) => word.isNotEmpty).toList();
          if (words.length < 5) {
            return 'Please enter at least 5 words';
          }else if(words.length > 50){
            return 'Word has exceeded the maximum count';
          }
          return null;
        },
        controller: descriptionController, textCapitalization: TextCapitalization.sentences,
        cursorHeight: 18,
        textInputAction: TextInputAction.none, keyboardType: TextInputType.text,
        maxLines: maxLine,
        decoration: InputDecoration(
          counterText: " ",
          hintText: "Describe your business to your audience",
          hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: const Color(0xff868484), fontSize: 14),
          labelStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: const Color(0xff868484), fontSize: 14),
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


  _showImagePickerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<ProductController>(
            init: ProductController(),
            builder: (controller){
              return SimpleDialog(
                backgroundColor: Colors.white,
                title: Text('Upload cover photo', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),),
                children: [
                  SimpleDialogOption(
                    padding: EdgeInsets.all(20),
                    child: Text('Take a photo'),
                    onPressed: () async {
                      Get.back();
                      _controller.onUploadShopCoverPhoto(ImageSource.camera);
                      setState(() {});
                    },
                  ),
                  SimpleDialogOption(
                    padding: EdgeInsets.all(20),
                    child: Text('Choose from Gallery'),
                    onPressed: () async {
                      Get.back();
                      _controller.onUploadShopCoverPhoto(ImageSource.gallery);
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
    initializeShopDetails();
    super.initState();
  }

  initializeShopDetails() async {
    log("message");
    Get.put<LocalCachedData>(await LocalCachedData.create());
    await LocalCachedData.instance.getCreateShopResponse().then((value) async {
      nameController.text = value?.data?.name ?? "";
      log(value?.data?.name ?? "No data");
      descriptionController.text = value?.data?.biography ?? "";
      imageUrl = value?.data?.coverImage;
      setState(() {});
      if(imageUrl != null && imageUrl != ""){
        await getImage(url: imageUrl!);
        setState(() {});
      }else{
        null;
      }
    });
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
      _controller.coverPhoto = xFile;
    });
    return file;
  }

  final formKey = GlobalKey <FormState>();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        init: ProductController(),
        builder: (controller){
          return SafeArea(top: false, bottom: false,
              child: Scaffold( backgroundColor: white,
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
                  title: Text("Edit Shop", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
                ),
                body: Form(
                  key: formKey,
                  child: AnimatedColumn(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    children: [
                      // Align(alignment: Alignment.centerLeft,
                      //     child: Text("Edit Shop", style: Theme.of(context).textTheme.bodySmall!.
                      //     copyWith(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xff333333)),)),
                      // const SizedBox(height: 8,),
                      Align(alignment: Alignment.centerLeft,
                        child: Text("Edit your business details to suit the correct data", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),),
                      ),
                      const SizedBox(height: 24,),
                      Text('Shop Name ',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14, color: black),
                      ),
                      const SizedBox(height: 8,),
                      DexterTextField(
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        minLines: null, maxLines: 1, expands: false,
                        hintText: "Name of your Business/Shop",
                        validator: isRequired,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(text: TextSpan(text: "Notice: ", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w800, fontSize: 8, color: Colors.red, ),children: [
                        TextSpan(text: 'Please ensure you provide the name of the shop/business as this would be visible to your customers',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w400, fontSize: 8, color: black))
                      ]
                      )),
                      const SizedBox(height: 16,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shop Bio',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w400, fontSize: 14, color: black),
                          ),
                          Text(' Max. 50 words',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w700, fontSize: 11, color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      _businessDescriptionForm(context: context),
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
                      Text('Shop Brand/Cover Photo',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14, color: black),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: (){
                          _showImagePickerDialog(context);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 154, width: double.maxFinite,
                            decoration: BoxDecoration(color: Color(0xffE6E6E6),
                                borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xff868484))),
                            child: controller.coverPhoto == null ? Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AssetPath.photo),
                                const SizedBox(height: 16,),
                                Text('Add Cover',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w400, fontSize: 14, color: black),
                                ),
                                const SizedBox(height: 4,),
                                Text('W: 375px H: 200px',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xff5B5B5B)),
                                ),
                              ],
                            ) : Image.file(File(controller.coverPhoto!.path), fit: BoxFit.cover,),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(text: TextSpan(text: "Kindly upload your business branding image or logo that represent your shop",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 8, color: black),
                      )),
                      const SizedBox(height: 31,),
                      DexterPrimaryButton(
                        onTap: (){
                          if(formKey.currentState!.validate()){
                            formKey.currentState!.save();
                            if(controller.coverPhoto == null){
                              Get.snackbar("Error","Please add your business cover photo");
                            }else if (descriptionController.text.isEmpty){
                              Get.snackbar("Error","Please enter description to proceed");
                            }else{
                              Get.to(()=> EditShopDetails(name: nameController.text, bio: descriptionController.text,));
                            }
                          }
                        },
                        btnTitle: "Confirm", btnTitleSize: 16, borderRadius: 35, btnHeight: 56,
                        btnWidth: MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(height: 52,),
                    ],
                  ),
                ),
              )
          );
        });
  }
}
