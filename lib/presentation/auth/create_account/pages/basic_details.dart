import 'dart:developer';
import 'dart:io';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/utils/flush_bar.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/core/state/view_state.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/presentation/auth/create_account/controller/registration_controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dexter_vendor/widget/custom_snack.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'create_shop.dart';


class BasicDetail extends StatefulWidget {
  const BasicDetail({Key? key}) : super(key: key);

  @override
  State<BasicDetail> createState() => _BasicDetailState();
}

class _BasicDetailState extends State<BasicDetail> with FormMixin{
  final _controller = Get.put(RegistrationController());

  _showImagePickerDialog(BuildContext context) async {
    return showDialog(context: context,
      builder: (context) {
        return GetBuilder<RegistrationController>(
          init: RegistrationController(),
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
                  _controller.onUploadImage(ImageSource.camera);
                  setState(() {});
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Choose from Gallery'),
                onPressed: () async {
                  Get.back();
                  _controller.onUploadImage(ImageSource.gallery);
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
  final qualificationController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final ninController = TextEditingController();


  @override
  void dispose() {
    qualificationController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    ninController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      init: RegistrationController(),
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
                      child: Text("Basic Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xff333333)),)),
                  const SizedBox(height: 8,),
                  Align(alignment: Alignment.centerLeft,
                    child: Text("We’ll need your basic info to verify you", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),),
                  ),
                  const SizedBox(height: 24,),RichText(text: TextSpan(text: "Passport Photograph ",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize:12, color: black), children: [
                        TextSpan(text: "(Max. 10mb)", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 12,),)
                      ])),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          height: 84, width: 84, decoration: BoxDecoration(color: Color(0xffE6E6E6),
                            borderRadius: BorderRadius.circular(24)),
                          child: _controller.imageFile == null ? SvgPicture.asset(AssetPath.imageSvg): Image.file(File(_controller.imageFile!.path), fit: BoxFit.cover,),
                        ),
                      ),
                      const SizedBox(width: 24,),
                      GestureDetector(
                          onTap: (){
                            _controller.imageFile == null ? _showImagePickerDialog(context) : setState(()=> _controller.imageFile = null);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: greenPea, borderRadius: BorderRadius.circular(22)),
                            child: Center(child: Text(_controller.imageFile == null ? "Upload" : "Remove", style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              letterSpacing: 0.27,
                              color: white,
                            )),),
                          )
                      )
                    ],
                  ),
                  const SizedBox(height: 24,),
                  Text('Highest School Qualification', style: Theme.of(context).textTheme.bodyLarge!.
                  copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: black),),
                  const SizedBox(height: 8,),
                  DropdownButtonFormField2(
                    decoration: InputDecoration(
                      isDense: true, contentPadding: EdgeInsets.zero,
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Color(0xff868484), width: 0.7)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Color(0xff868484), width: 0.7)
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Color(0xff868484), width: 0.7)
                      ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Color(0xff868484), width: 0.7)
                      ),
                      errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Color(0xff868484), width: 0.7)
                      ),
                    ),
                    isExpanded: true,
                    hint: Text("Qualification", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color(0xff868484), fontSize: 15)),
                    items: controller.item.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 15)),
                    )).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select qualification';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      qualificationController.text = value!;
                      setState(() {});
                    },
                    buttonStyleData: ButtonStyleData(height: 48, padding: EdgeInsets.only(left: 0, right: 10),
                        decoration: BoxDecoration(color: Color(0xffEFEFF0), borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xff868484), width: 0.7))),
                    iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: black, size: 18,), iconSize: 30,),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(text: TextSpan(text: 'Provide your highest educational qualification', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                  )),
                  const SizedBox(height: 16,),
                  Text('National Identification Number(NIN) (Optional)',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DexterTextField(
                    keyboardType: TextInputType.number,
                    controller: ninController,
                    minLines: null, maxLines: 1, expands: false,
                    hintText: "",
                    validator: ninController.text.isEmpty ? (value){
                      return null;
                    } : (value){
                      if(value!.length >11 || value.length < 11){
                        return "Kindly provide a valid BVN";
                      }
                      return null;
                    },
                    // validator: isRequired,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(text: TextSpan(text: 'Please enter the ID number from you NIN identity card', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                  )),
                  const SizedBox(height: 16,),
                  Text('Street',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: black),),
                  const SizedBox(height: 8,),
                  DexterTextField(
                    keyboardType: TextInputType.streetAddress,
                    controller: streetController,
                    minLines: null, maxLines: 1, expands: false,
                    hintText: "",
                    validator: isRequired,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(text: TextSpan(text: 'Provide address to your residence. Please ensure you use the following format; 3, joy street, Lagos State, Nigeria', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                  )),
                  const SizedBox(height: 16,),
                  Text('City',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DexterTextField(
                    keyboardType: TextInputType.streetAddress,
                    controller: cityController,
                    minLines: null, maxLines: 1, expands: false,
                    hintText: "",
                    validator: isRequired,
                  ),
                  const SizedBox(height: 5,),
                  RichText(text: TextSpan(text: 'Provide city and ensure you provide an accurate data. Example Lekki Phase One, Lagos Island', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                  )),
                  // Text('State',
                  //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  //       fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  // DropdownButtonFormField2(
                  //   decoration: InputDecoration(
                  //     isDense: true,
                  //     contentPadding: EdgeInsets.zero,
                  //     enabledBorder: const OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(20)),
                  //         borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                  //     focusedBorder: const OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(20)),
                  //         borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                  //     focusedErrorBorder: const OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(20)),
                  //         borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                  //     border: const OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(20)),
                  //         borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                  //     errorBorder: const OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(20)),
                  //         borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                  //   ),
                  //   isExpanded: true,
                  //   hint: Text("Your state of residence", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color(0xff868484), fontSize: 15)),
                  //   items: controller.state.map((item) => DropdownMenuItem<String>(
                  //     value: item,
                  //     child: Text(item, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 15)),
                  //   )).toList(),
                  //   validator: (value) {
                  //     if (value == null) {
                  //       return 'Please select state of residence';
                  //     }
                  //     return null;
                  //   },
                  //   onChanged: (value) {
                  //     stateController.text = value!;
                  //     setState(() {});
                  //   },
                  //   buttonStyleData: ButtonStyleData(height: 48, padding: EdgeInsets.only(left: 0, right: 10),
                  //       decoration: BoxDecoration(color: Color(0xffEFEFF0), borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xff868484), width: 0.7))),
                  //   iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: black, size: 18,), iconSize: 30,),
                  //   dropdownStyleData: DropdownStyleData(
                  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 50,),
                  DexterPrimaryButton(
                    onTap: () async {
                      if(formKey.currentState!.validate()){
                        formKey.currentState!.save();
                        if(_controller.imageFile == null){
                          Get.snackbar("Error","Please add a passport photograph");
                        }else{
                          Get.put<LocalCachedData>(await LocalCachedData.create());
                          final regResponse = await LocalCachedData.instance.getRegistrationResponse();
                          await controller.createBasicDetails(
                              email: regResponse.data!.user!.email!,
                              firstName: regResponse.data!.user!.firstName!,
                              lastName: regResponse.data!.user!.lastName!,
                              // state: stateController.text,
                              phoneNumber: regResponse.data!.user!.phone!,
                              imageFile: controller.imageFile!,
                              qualification: qualificationController.text,
                              nin: ninController.text
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
