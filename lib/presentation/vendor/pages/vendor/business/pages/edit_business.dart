import 'dart:developer';
import 'dart:io';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/data/location_data/get_location.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/presentation/auth/create_account/controller/registration_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/business/controller/controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class EditBusiness extends StatefulWidget {
  final String? openTime;
  final String? closeTime;
  final String? chargeAmount;
  final String? serviceName;
  final String? businessAddress;
  const EditBusiness({Key? key, this.openTime, this.closeTime, this.chargeAmount, this.serviceName, this.businessAddress}) : super(key: key);

  @override
  State<EditBusiness> createState() => _EditBusinessState();
}

class _EditBusinessState extends State<EditBusiness> with FormMixin{
  final _controller = Get.find<BusinessController>();
  _showImagePickerDialog(BuildContext context, int index) async {
    return showDialog(
      context: context,
      builder: (context) {
        return GetBuilder<BusinessController>(
            init: Get.find<BusinessController>(),
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

  Future<XFile> getImage({required String url}) async {
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
    return xFile;
  }

  initializeBusinessDetails() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    await LocalCachedData.instance.getBusinessResponse().then((value) async {
      descriptionController.text = value?.data?.biography ?? "";
      });
  }

  Future<void> getBusinessImages() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    await LocalCachedData.instance.getBusinessImages().then((value) async {
      if(value!.data!.isNotEmpty){
        for(var i = 0; i < value.data!.length; i++){
          if(i == 0){
            await getImage(url: value.data![i].imageUrl!).then((value){
              _controller.photo1 = value;
              setState(() {});
            });
          }else if (i == 1) {
            await getImage(url: value.data![i].imageUrl!).then((value){
              _controller.photo2 = value;
              setState(() {});
            });
          }else if(i == 2){
            await getImage(url: value.data![i].imageUrl!).then((value){
              _controller.photo3 = value;
              setState(() {});
            });
          }else if(i == 3){
            await getImage(url: value.data![i].imageUrl!).then((value){
              _controller.photo4 = value;
              setState(() {});
            });
          }
        }
      }else{
        null;
      }
    });

  }

  @override
  void initState() {
    initializeBusinessDetails();
    getBusinessImages();
    log(widget.openTime.toString());
    log(widget.closeTime.toString());
    log(widget.chargeAmount.toString());
    log(widget.serviceName.toString());
    log(widget.businessAddress.toString());
    super.initState();
  }

  Widget _businessDescriptionForm({required BuildContext context}){
    var maxLine = 11;
    return Container(height: maxLine * 18.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
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
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        minLines: null,
        maxLines: null,  // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
        expands: true,
        // maxLines: 11,
        decoration: InputDecoration(
          counterText: " ",
          hintText: "Describe your business to your audience",
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

  final formKey = GlobalKey <FormState>();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final descriptionController = TextEditingController();
  final phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(
        init: Get.find<BusinessController>(),
        builder: (controller){
          return SafeArea(top: false, bottom: false,
              child: Scaffold(
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
                  title: Text("Edit Business Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
                ),
                body: Form(
                  key: formKey,
                  child: AnimatedColumn(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    children: [
                      // Align(alignment: Alignment.centerLeft,
                      //     child: Text("Business Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xff333333)),)),
                      // const SizedBox(height: 8,),
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
                      _businessDescriptionForm(context: context),
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
                      Text('Sample your work',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14, color: black),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
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
                                child: index == 0 && _controller.photo1 != null ?
                                ClipRRect(borderRadius: BorderRadius.circular(15.0),
                                  child: FittedBox(child: Image.file(File(_controller.photo1!.path), fit: BoxFit.cover,),
                                    fit: BoxFit.cover, clipBehavior: Clip.hardEdge,),
                                ) : index == 1 && _controller.photo2 != null ?
                                ClipRRect(borderRadius: BorderRadius.circular(15.0),
                                  child: FittedBox(child: Image.file(File(_controller.photo2!.path), fit: BoxFit.cover,),
                                    fit: BoxFit.cover, clipBehavior: Clip.hardEdge,),
                                ) : index == 2 && _controller.photo3 != null ?
                                ClipRRect(borderRadius: BorderRadius.circular(15.0),
                                    child: FittedBox(child: Image.file(File(controller.photo3!.path), fit: BoxFit.cover,),
                                      fit: BoxFit.cover, clipBehavior: Clip.hardEdge,)) :
                                index == 3 && _controller.photo4 != null ?
                                ClipRRect(borderRadius: BorderRadius.circular(15.0),
                                    child: FittedBox(child: Image.file(File(_controller.photo4!.path,),),
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
                          if(formKey.currentState!.validate()){
                            if(controller.photo1 == null || controller.photo2 == null || controller.photo3 == null || controller.photo4 == null ){
                              Get.snackbar("Error", "Kindly attach images on the entire boxes");
                            }else{
                              Get.put<LocalCachedData>(await LocalCachedData.create());
                              final serviceId = await LocalCachedData.instance.getSelectedServiceId();
                              final regResponse = await LocalCachedData.instance.getVendorProfile();
                              final location = await GetLocation.instance?.checkLocation;
                              controller.updateBusiness(
                                  name: widget.serviceName,
                                  biography: descriptionController.text,
                                  coverImage: controller.coverPhoto,
                                  openingTime: widget.openTime,
                                  closingTime: widget.closeTime,
                                  contactAddress: widget.businessAddress,
                                  contactEmail: regResponse?.data?.email ?? "",
                                  contactPhone: regResponse?.data?.phone ?? "",
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
