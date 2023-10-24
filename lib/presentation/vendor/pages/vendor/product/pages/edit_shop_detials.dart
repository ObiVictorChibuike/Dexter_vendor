import 'dart:developer';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/controller/controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class EditShopDetails extends StatefulWidget {
  final String name;
  final String  bio;
  const EditShopDetails({Key? key, required this.name, required this.bio}) : super(key: key);

  @override
  State<EditShopDetails> createState() => _EditShopDetailsState();
}

class _EditShopDetailsState extends State<EditShopDetails> with FormMixin{
  final openingTime = TextEditingController();
  final closeTime = TextEditingController();
  final businessAddress = TextEditingController();
  final businessShippingCost = TextEditingController();
  final businessName = TextEditingController();
  final businessEmail = TextEditingController();
  final businessPhone = TextEditingController();
  final businessDiscount = TextEditingController();
  final shoppingCost = TextEditingController();
  final businessMinimumOrder = TextEditingController();
  String? openTimeText;
  String? closeTimeText;
  double? lat, long;

  String getDate(String date) {
    final formattedDate = Jiffy(date).yMMMMd;
    return formattedDate;
  }


  @override
  void initState() {
    initializeShopDetails();
    super.initState();
  }

  initializeShopDetails() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    LocalCachedData.instance.getCreateShopResponse().then((value) async {
      businessAddress.text = value?.data?.contactAddress?.fullAddress ?? "";
      businessDiscount.text = value?.data?.discount ?? "";
      shoppingCost.text = value?.data?.shippingCost ?? "";
      long = double.parse("${value?.data?.longitude ?? 0.0}");
      lat = double.parse("${value?.data?.latitude ?? 0.0}");
      openingTime.text = "${value?.data?.openingTime} am";
      closeTime.text = "${value?.data?.closingTime} pm";
      openTimeText = "${value?.data?.openingTime ?? ""}";
      closeTimeText = "${value?.data?.closingTime ?? ""}";
    });
  }

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
    log(openTimeText.toString());
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
    return time;
  }

  final formKey = GlobalKey <FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
        init: ProductController(),
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
                title: Text("Edit Shop Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
              ),
              body: Form(
                key: formKey,
                child: AnimatedColumn(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  children: [
                    // Align(alignment: Alignment.centerLeft,
                    //     child: Text("Shop Details ", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xff333333)),)),
                    // const SizedBox(height: 8,),
                    Align(alignment: Alignment.centerLeft, child: Text("Edit your shop details to suit the correct data",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),),
                    ),
                    const SizedBox(height: 24,),
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
                    RichText(text: TextSpan(text: "Notice: ", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w800, fontSize: 8, color: Colors.red, ),children: [
                      TextSpan(text: 'Please ensure you follow the hint format and provide address to your business office', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 8, color: black))
                    ]
                    )),
                    const SizedBox(height: 16,),
                    Text('General Discount (Optional)',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14, color: black),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DexterTextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      minLines: null, maxLines: 1, expands: false,
                      hintText: "Enter general discount",
                      controller: businessDiscount,
                      // validator: isRequired,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    RichText(text: TextSpan(text: "Notice: ", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w800, fontSize: 8, color: Colors.red, ),children: [
                      TextSpan(text: 'Please ensure you provide a general discount for your enterprise if you have any', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 8, color: black))
                    ]
                    )),
                    const SizedBox(height: 16,),
                    Text('General Shopping Cost',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14, color: black),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    DexterTextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      minLines: null, maxLines: 1, expands: false,
                      hintText: "Enter shipping cost",
                      controller: shoppingCost,
                      validator: isRequired,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    RichText(text: TextSpan(text: "Please provide general average shipping cost across all location",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 8, color: black),
                    )),
                    const SizedBox(height: 16,),
                    Text('Business Hours',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400, fontSize: 14, color: black),
                    ),
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
                    const SizedBox(height: 100,),
                    DexterPrimaryButton(
                      onTap: () async {
                        Get.put<LocalCachedData>(await LocalCachedData.create());
                        final regResponse = await LocalCachedData.instance.getVendorProfile();
                        if(formKey.currentState!.validate()){
                          formKey.currentState!.save();
                          if(closeTimeText == "" || closeTimeText == null){
                            Get.snackbar("Error", "Please select close time");
                          }else if(openTimeText == "" || openTimeText == null){
                            Get.snackbar("Error", "Please select open time");
                          }else{
                            controller.editShop(shopName: widget.name, biography: widget.bio,
                                coverImage: controller.coverPhoto!,
                                openTime: openTimeText!,
                                closeTime: closeTimeText!,
                                address: businessAddress.text,
                                email: regResponse!.data!.email!,
                                phoneNumber: regResponse.data!.phone!,
                                discount: businessDiscount.text,
                                lat: lat ?? 0.0,
                                long: lat ?? 0.0,
                                shoppingCost: shoppingCost.text,
                                context: context
                            );
                          }
                        }
                      },
                      buttonBorder: greenPea, btnTitle: "Confirm",
                      borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
                    ),
                    const SizedBox(height: 167,),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
