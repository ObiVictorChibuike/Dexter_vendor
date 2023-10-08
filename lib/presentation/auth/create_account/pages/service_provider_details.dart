import 'dart:developer';
import 'dart:io';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/presentation/auth/create_account/controller/registration_controller.dart';
import 'package:dexter_vendor/presentation/auth/create_account/pages/service_details.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ServiceProviderDetails extends StatefulWidget {
  const ServiceProviderDetails({Key? key}) : super(key: key);

  @override
  State<ServiceProviderDetails> createState() => _ServiceProviderDetailsState();
}

class _ServiceProviderDetailsState extends State<ServiceProviderDetails>  with FormMixin{
  final _controller = Get.find<RegistrationController>();
  String? openTimeText;
  String? closeTimeText;
  Future<TimeOfDay?> _selectOpeningTime({
    required BuildContext context,
    String? title,
    TimeOfDay? initialTime,
    String? cancelText,
    String? confirmText,
  }) async {
    TimeOfDay? time = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      cancelText: cancelText ?? "Cancel",
      confirmText: confirmText ?? "Save",
      helpText: title ?? "Select time",
      builder: (context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    openingTime.text = "${time!.format(context)} ${time.period.toString().split('.')[1]}";
    openTimeText = "${time.format(context)}";
    log(openTimeText!);
    return time;
  }

  Future<TimeOfDay?> _selectCloseTime({
    required BuildContext context,
    String? title,
    TimeOfDay? initialTime,
    String? cancelText,
    String? confirmText,
  }) async {
    TimeOfDay? time = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      cancelText: cancelText ?? "Cancel",
      confirmText: confirmText ?? "Save",
      helpText: title ?? "Select time",
      builder: (context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    closeTime.text = "${time!.format(context)} ${time.period.toString().split('.')[1]}";
    closeTimeText = "${time.format(context)}";
    log(closeTimeText!);
    return time;
  }
  _showImagePickerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<RegistrationController>(
            init: Get.find<RegistrationController>(),
            builder: (controller){
              return SimpleDialog(
                backgroundColor: Colors.white,
                title: Text('Upload Image', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),),
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
  final serviceTitle = TextEditingController();
  final priceController = TextEditingController();
  final businessAddress = TextEditingController();
  final openingTime = TextEditingController();
  final closeTime = TextEditingController();

  @override
  void dispose() {
    serviceTitle.dispose();
    priceController.dispose();
    businessAddress.dispose();
    openingTime.dispose();
    closeTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      init: Get.find<RegistrationController>(),
        builder: (controller){
      return SafeArea(top: false, bottom: false,
          child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              elevation: 0.0, backgroundColor: white,
            ),
            body: Form(
              key: formKey,
              child: AnimatedColumn(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  Align(alignment: Alignment.centerLeft,
                      child: Text("Create Business", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xff333333)),)),
                  const SizedBox(height: 8,),
                  Align(alignment: Alignment.centerLeft,
                    child: Text("We will need basic information about your Business/Service you plan to offer on DexterApp",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 13),),
                  ),
                  const SizedBox(height: 24,),
                  Text('Business Name',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, color: black),),
                  const SizedBox(height: 8,),
                  DexterTextField(
                    keyboardType: TextInputType.text,
                    controller: serviceTitle,
                    minLines: null, maxLines: 1, expands: false,
                    hintText: "Walconzy Ac Repair",
                    validator: isRequired,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(text: TextSpan(text: 'Please provide the name of your business. This would be visible to your customers',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                  )),
                  const SizedBox(height: 16,),
                  Text('Business Cover Photo',
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
                        decoration: BoxDecoration(color: Color(0xffEFEFF0),
                            borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xff868484))),
                        child: controller.coverPhoto == null ? Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AssetPath.photo),
                            const SizedBox(height: 16,),
                            Text('Add Business Cover Picture',
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
                  RichText(text: TextSpan(text: 'Kindly upload your business branding image or logo that represent your business',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                  )),
                  const SizedBox(height: 16,),
                  Text('Average Service Charge',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: black),),
                  const SizedBox(height: 8,),
                  DexterTextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    minLines: null, maxLines: 1, expands: false,
                    hintText: "₦ 2000",
                    validator: isRequired,
                  ),
                  const SizedBox(height: 5,),
                  RichText(text: TextSpan(text: 'Provide a generic average business charge for your services. Could be changed in the business page',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey, )
                  )),
                  const SizedBox(height: 16,),
                  Text('Business Address',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DexterTextField(
                    controller: businessAddress,
                    minLines: null, maxLines: 1, expands: false,
                    hintText: "3, Joy Street, Lagos, Nigeria",
                    validator: isRequired,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(text: TextSpan(text: 'Please ensure you follow the hint format and provide address to your business office',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                  )),
                  const SizedBox(height: 16,),
                  Text('Business Hours',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: black),),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(flex: 3,
                        child: DexterTextField(
                          validator: isRequired,
                          onTap: (){
                            _selectOpeningTime(context: context);
                          },
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14),
                          minLines: null, maxLines: 1, expands: false, readOnly: true,
                          hintText: "Start Time",controller: openingTime,
                          suffixIcon: Icon(Icons.keyboard_arrow_down, color: black,),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(flex: 3,
                        child: DexterTextField(
                          validator: isRequired,
                          onTap: (){
                            _selectCloseTime(context: context);
                          },
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14),
                          minLines: null, maxLines: 1, expands: false, readOnly: true,
                          hintText: "End Time",controller: closeTime,
                          suffixIcon: Icon(Icons.keyboard_arrow_down, color: black,),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(text: TextSpan(text: 'Ensure you provide time of availability as this would be visible to your customers',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey, ),
                  )),
                  const SizedBox(height: 50,),
                  DexterPrimaryButton(
                    onTap: (){
                      if(formKey.currentState!.validate()){
                        formKey.currentState!.save();
                        if(controller.coverPhoto == null){
                          Get.snackbar("Error", "Please select a cover photo for your business");
                        }else{
                          Get.to(()=> ServiceDetails(
                            openTime: openTimeText,
                            closeTime: closeTimeText,
                            chargeAmount: priceController.text,
                            serviceName: serviceTitle.text,
                            businessAddress: businessAddress.text,
                          ));
                        }
                      }
                    },
                    btnTitle: "Continue", btnTitleSize: 16, borderRadius: 35, btnHeight: 56,
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
