import 'dart:io';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/utils/flush_bar.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/presentation/auth/create_account/controller/registration_controller.dart';
import 'package:dexter_vendor/presentation/auth/create_account/pages/shop_details.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class CreateVendor extends StatefulWidget {
  const CreateVendor({Key? key}) : super(key: key);

  @override
  State<CreateVendor> createState() => _CreateVendorState();
}

class _CreateVendorState extends State<CreateVendor> with FormMixin{
  final _controller = Get.put(RegistrationController());
  final descriptionController = TextEditingController();
  Widget _businessDescriptionForm(){
    var maxLine = 11;
    return Container(height: maxLine * 18.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(13),),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        validator: (value){
          List<String> words = value!.trim().split(' ');
          words = words.where((word) => word.isNotEmpty).toList();
          if (words.length < 5) {
            return 'Please enter at least 5 words';
          }
          return null;
        },
        controller: descriptionController, textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        minLines: null,
        maxLines: null,  // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
        expands: true,
        // maxLines: 11,
        decoration: InputDecoration(
          counterText: " ",
          hintText: "Describe your business and provide other details",
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
          contentPadding: const EdgeInsets.all(13),
        ),
      ),
    );
  }


  _showImagePickerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<RegistrationController>(
            init: RegistrationController(),
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
                      _controller.onUploadCoverPhoto(ImageSource.camera);
                      setState(() {});
                    },
                  ),
                  SimpleDialogOption(
                    padding: EdgeInsets.all(20),
                    child: Text('Choose from Gallery'),
                    onPressed: () async {
                      Get.back();
                      _controller.onUploadCoverPhoto(ImageSource.gallery);
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

  final formKey = GlobalKey <FormState>();
  final nameController = TextEditingController();
  final bioController = TextEditingController();


  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      init: RegistrationController(),
        builder: (controller){
      return SafeArea(top: false, bottom: false,
          child: Scaffold(backgroundColor: white,
            appBar: AppBar(elevation: 0.0, backgroundColor: white,),
            body: Form(
              key: formKey,
              child: AnimatedColumn(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  Align(alignment: Alignment.centerLeft,
                      child: Text("Create Shop", style: Theme.of(context).textTheme.bodySmall!.
                      copyWith(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xff333333)),)),
                  const SizedBox(height: 8,),
                  Align(alignment: Alignment.centerLeft,
                    child: Text("Provide your business details ", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),),
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
                    hintText: "",
                    validator: isRequired,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(text: TextSpan(text: "Please ensure you provide the name of the shop/business as this would be visible to your customers",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey,),
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
                            fontWeight: FontWeight.w500, fontSize: 11, color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  _businessDescriptionForm(),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(text: TextSpan(text: 'Please ensure you provide a detailed description of your shop or'
                      ' enter mission and vision. These would help customers to know '
                      'what you represent and stand for.', style: Theme.of(context).textTheme.bodyLarge!.
                  copyWith(fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey, ),)),
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
                  RichText(text: TextSpan(text: 'Kindly upload your business branding image or logo that represent your shop',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey),
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
                          Get.to(()=> ShopDetails(name: nameController.text, bio: descriptionController.text,));
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
