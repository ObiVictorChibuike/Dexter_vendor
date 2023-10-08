import 'dart:developer';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/presentation/auth/create_account/controller/registration_controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class ShopDetails extends StatefulWidget {
  final String name;
  final String  bio;
  const ShopDetails({Key? key, required this.name, required this.bio}) : super(key: key);

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> with FormMixin{
  final openingTime = TextEditingController();
  final closeTime = TextEditingController();
  final businessAddress = TextEditingController();
  final businessDiscount = TextEditingController();
  final shoppingCost = TextEditingController();

  @override
  void dispose() {
    openingTime.dispose();
    closeTime.dispose();
    businessAddress.dispose();
    businessDiscount.dispose();
    shoppingCost.dispose();
    super.dispose();
  }
  String? openTimeText;
  String? closeTimeText;

  String getDate(String date) {
    final formattedDate = Jiffy(date).yMMMMd;
    return formattedDate;
  }

  initializeShopDetails() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    LocalCachedData.instance.getCreateShopResponse().then((value){

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
                    child: Text("Edit Shop Details ", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 26, fontWeight: FontWeight.w600, color: Color(0xff333333)),)),
                const SizedBox(height: 8,),
                Align(alignment: Alignment.centerLeft, child: Text("Provide your shop details ", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),),
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
                  hintText: "",
                  validator: isRequired,
                ),
                const SizedBox(
                  height: 5,
                ),
                RichText(text: TextSpan(text: 'Provide address to your office. Please ensure you use the following format; 3, joy street, Lagos State, Nigeria',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey, )
                )),
                const SizedBox(height: 16,),
                Text('General Discount (Optional)',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 14, color: black),
                ),
                const SizedBox(
                  height: 8,
                ),
                DexterTextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  minLines: null, maxLines: 1, expands: false,
                  hintText: "",
                  controller: businessDiscount,
                  // validator: isRequired,
                ),
                const SizedBox(
                  height: 5,
                ),
                RichText(text: TextSpan(text: 'Please ensure you provide a general discount for your enterprise if you have any',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                )),
                const SizedBox(height: 16,),
                Text('General Shopping Cost',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 14, color: black),
                ),
                const SizedBox(
                  height: 8,
                ),
                DexterTextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  minLines: null, maxLines: 1, expands: false,
                  hintText: "",
                  controller: shoppingCost,
                  validator: isRequired,
                ),
                const SizedBox(
                  height: 5,
                ),
                RichText(text: TextSpan(text: 'Please provide general average shipping cost across all location', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
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
                      child: Column(
                        children: [
                          DexterTextField(
                            validator: isRequired,
                            onTap: (){
                              _selectOpeningTime(context: context);
                            },
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14),
                            minLines: null, maxLines: 1, expands: false, readOnly: true,
                            hintText: "",controller: openingTime,
                            suffixIcon: Icon(Icons.keyboard_arrow_down, color: black,),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          RichText(text: TextSpan(text: 'Please provide the time you open your business', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(flex: 3,
                      child: Column(
                        children: [
                          DexterTextField(
                            validator: isRequired,
                            onTap: (){
                              _selectCloseTime(context: context);
                            },
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14),
                            minLines: null, maxLines: 1, expands: false, readOnly: true,
                            hintText: "",controller: closeTime,
                            suffixIcon: Icon(Icons.keyboard_arrow_down, color: black,),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          RichText(text: TextSpan(text: 'Please provide the time you close your business', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100,),
                DexterPrimaryButton(
                  onTap: () async {
                    Get.put<LocalCachedData>(await LocalCachedData.create());
                    final regResponse = await LocalCachedData.instance.getRegistrationResponse();
                    final selectedId = await LocalCachedData.instance.getSelectedServiceId();
                    // final response = await GetLocation.instance?.checkLocation;
                    if(formKey.currentState!.validate()){
                      formKey.currentState!.save();
                      if(closeTimeText == "" || closeTimeText == null){
                        Get.snackbar("Error", "Please select close time");
                      }else if(openTimeText == "" || openTimeText == null){
                        Get.snackbar("Error", "Please select open time");
                      }else{
                        controller.createShop(shopName: widget.name, biography: widget.bio,
                            coverImage: controller.coverPhoto!,
                            openTime: openTimeText!,
                            closeTime: closeTimeText!,
                            address: businessAddress.text,
                            email: regResponse.data!.user!.email!,
                            phoneNumber: regResponse.data!.user!.phone!,
                            discount: businessDiscount.text,
                            // lat: response?.latitude ?? 0.0,
                            // long: response?.longitude ?? 0.0,
                            shoppingCost: shoppingCost.text,
                            serviceId: selectedId.toString(),
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
