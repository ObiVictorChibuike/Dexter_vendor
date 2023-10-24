import 'dart:io';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/data/location_data/get_location.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/presentation/auth/create_account/controller/registration_controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ServiceDetails extends StatefulWidget {
  final String? openTime;
  final String? closeTime;
  final String? chargeAmount;
  final String? serviceName;
  final String? businessAddress;
  const ServiceDetails({Key? key, this.openTime, this.closeTime, this.chargeAmount, this.serviceName, this.businessAddress}) : super(key: key);

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> with FormMixin{
  final _controller = Get.find<RegistrationController>();
  _showImagePickerDialog(BuildContext context, int index) async {
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
                      _controller.onUploadBusinessServiceSampleImages(ImageSource.camera, index);
                      setState(() {});
                    },
                  ),
                  SimpleDialogOption(
                    padding: EdgeInsets.all(20),
                    child: Text('Choose from Gallery'),
                    onPressed: () async {
                      Get.back();
                      _controller.onUploadBusinessServiceSampleImages(ImageSource.gallery, index);
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
          // else if(words.length > 50){
          //   return 'Word has exceeded the maximum count';
          // }
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

  final formKey = GlobalKey <FormState>();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final descriptionController = TextEditingController();
  final phone = TextEditingController();


  @override
  void dispose() {
    streetController.dispose();
    cityController.dispose();
    descriptionController.dispose();
    phone.dispose();
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
                      child: Text("Business Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xff333333)),)),
                  const SizedBox(height: 8,),
                  Align(alignment: Alignment.centerLeft,
                    child: Text("We will need basic information about your Business/Service you plan to offer on DexterApp", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 13),),
                  ),
                  const SizedBox(height: 24,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Service Description',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14, color: black),
                      ),
                      Text(' Max. 50 words',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red, ),
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
                  RichText(text: TextSpan(text: 'Please ensure you provide a '
                      'detailed description of the service you'
                      ' render. These would help customers to know '
                      'what you represent and stand for.', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey, )
                  )),
                  const SizedBox(height: 16,),
                  // Text('Sample your work',
                  //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  //       fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  // ),
                  // const SizedBox(
                  //   height: 12,
                  // ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1 / 1, crossAxisCount: 2, mainAxisSpacing: 10,
                      crossAxisSpacing: 10,),
                    itemCount: 4,
                    itemBuilder: (_,index){
                      return GestureDetector(
                        onTap: (){
                          _showImagePickerDialog(context, index);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0), border: Border.all(color: Color(0xff868484)),
                              color: const Color(0xffEFEFF0),
                            ),
                            width: MediaQuery.of(context).size.width * .42,
                            child: index == 0 && controller.photo1 != null ?
                            ClipRRect(borderRadius: BorderRadius.circular(15.0),
                              child: FittedBox(child: Image.file(File(controller.photo1!.path), fit: BoxFit.cover,),
                                fit: BoxFit.cover, clipBehavior: Clip.hardEdge,),
                            ) : index == 1 && controller.photo2 != null ?
                            ClipRRect(borderRadius: BorderRadius.circular(15.0),
                              child: FittedBox(child: Image.file(File(controller.photo2!.path), fit: BoxFit.cover,),
                                fit: BoxFit.cover, clipBehavior: Clip.hardEdge,),
                            ) : index == 2 && controller.photo3 != null ?
                            ClipRRect(borderRadius: BorderRadius.circular(15.0),
                                child: FittedBox(child: Image.file(File(controller.photo3!.path), fit: BoxFit.cover,),
                                  fit: BoxFit.cover, clipBehavior: Clip.hardEdge,)) :
                            index == 3 && controller.photo4 != null ?
                            ClipRRect(borderRadius: BorderRadius.circular(15.0),
                                child: FittedBox(child: Image.file(File(controller.photo4!.path,),),
                                  fit: BoxFit.cover, clipBehavior: Clip.hardEdge,)) : Icon(Icons.add, size: 45, color: greenPea,)
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(text: TextSpan(text: 'Sample your previous work as this gives you credibility and move views', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey),
                  )),
                  const SizedBox(height: 50,),
                  DexterPrimaryButton(
                    onTap: () async {
                      Get.put<LocalCachedData>(await LocalCachedData.create());
                      final serviceId = await LocalCachedData.instance.getSelectedServiceId();
                      final regResponse = await LocalCachedData.instance.getRegistrationResponse();
                      final location = await GetLocation.instance?.checkLocation;
                      if(formKey.currentState!.validate()){
                        if(controller.photo1 == null || controller.photo2 == null || controller.photo3 == null || controller.photo4 == null ){
                          Get.snackbar("Error", "Kindly attach images on the entire boxes");
                        }else{
                          controller.createABusiness(
                              name: widget.serviceName,
                              biography: descriptionController.text,
                              coverImage: controller.coverPhoto,
                              openingTime: widget.openTime,
                              closingTime: widget.closeTime,
                              contactAddress: widget.businessAddress,
                              contactEmail: regResponse.data!.user!.email!,
                              contactPhone: regResponse.data!.user!.phone!,
                              latitude: location?.latitude ?? 0.0,
                              longitude: location?.longitude ?? 0.0,
                              serviceId: serviceId.toString(),
                              serviceCharge: widget.chargeAmount,
                              businessImages: [controller.photo1!, controller.photo2!, controller.photo3!, controller.photo4!]
                          );
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
