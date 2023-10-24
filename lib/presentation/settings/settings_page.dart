import 'dart:developer';
import 'package:clean_dialog/clean_dialog.dart';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/core/state/view_state.dart';
import 'package:dexter_vendor/presentation/settings/privacy_policy.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/view_profile_photo.dart';
import 'package:dexter_vendor/widget/progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../domain/local/local_storage.dart';
import 'contact_us.dart';
import 'faq.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with FormMixin{
  final _controller = Get.find<HomeController>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey <FormState>();
  Future<void> onInitializeLocalStorage() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    _controller.notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
    log(_controller.notificationStatus.toString());
    setState(() {});
  }

  @override
  void initState() {
    firstNameController.text = _controller.authUserResponse!.data!.firstName!;
    lastNameController.text = _controller.authUserResponse!.data!.lastName!;
    emailController.text = _controller.authUserResponse!.data!.email!;
    onInitializeLocalStorage();
    super.initState();
  }
  final dexterSettings = [
    {
      "assets": AssetPath.call,
      "title": "Contact Us"
    },
    {
      "assets": AssetPath.faq,
      "title": "FAQs"
    },
    {
      "assets": AssetPath.privacyPolicy,
      "title": "Privacy Policy"
    },
    {
      "assets": AssetPath.about,
      "title": "About Dexter"
    },
  ];

  void updateProfile(BuildContext context,)async{
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      progressIndicator(Get.context);
      await _controller.updateUserProfile(firstNameController.text, lastNameController.text, emailController.text);
      if(_controller.updateUserProfileViewState.state == ResponseState.COMPLETE){
        setState((){
          firstNameController.text = _controller.authUserResponse!.data!.firstName!;
          lastNameController.text = _controller.authUserResponse!.data!.lastName!;
          emailController.text = _controller.authUserResponse!.data!.email!;
        });
        Get.back();
        Get.snackbar("Success","Profile Updated Successfully", colorText: white, backgroundColor: greenPea);
      }else if(_controller.updateUserProfileViewState.state == ResponseState.ERROR){
        Get.back();
        Get.snackbar("Error", _controller.errorMessage ?? "", colorText: white, backgroundColor: persianRed);
      }
    }
  }

  showEditProfileDialog(){
    showDialog(
      context: context,
      builder: (context) => Form(
        key: formKey,
        child: CleanDialog(
          title: 'Edit Profile',
          content: "Are you sure you want to edit your profile?",
          backgroundColor: greenPea,
          titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
          actions: [
            CleanDialogActionButtons(
                actionTitle: 'Yes',
                textColor: persianRed,
                onPressed: (){
                  Get.back();
                  updateProfile(context);
                }
            ),
            CleanDialogActionButtons(
                actionTitle: 'No',
                textColor: greenPea,
                onPressed: (){
                  Navigator.pop(context);
                }
            ),
          ],
        ),
      ),
    );
  }


  void showEditProfileBottomSheet({required String imagePath}){
    Get.bottomSheet(Container(decoration: BoxDecoration(color: white,borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/1.5,), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListView(
        children: [
          const SizedBox(height: 10,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Edit Profile", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 18, fontWeight: FontWeight.w600),),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 30, width: 30, decoration: BoxDecoration(shape: BoxShape.circle, color: iron),
                  child: Center(
                    child: Icon(
                      Icons.clear, color: black,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20,),
          Align(alignment: Alignment.center, child: ClipRRect(borderRadius: BorderRadius.circular(40),
            child: Container(height: 80, width: 80, decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.network(imagePath, height: 80, width: 80, fit: BoxFit.cover,)),
          )),
          const SizedBox(height: 30,),
          Text('First Name',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: black),),
          const SizedBox(height: 8,),
          DexterTextField(
            minLines: null,
            maxLines: 1, expands: false,
            hintText: "John Doe",
            controller: firstNameController,
            validator: isRequired,
          ),
          const SizedBox(height: 16,),
          Text('Last Name',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w400, fontSize: 14, color: black),
          ),
          const SizedBox(
            height: 8,
          ),
          DexterTextField(
            minLines: null,
            maxLines: 1, expands: false,
            hintText: "John Doe",
            controller: lastNameController,
            validator: isRequired,
          ),
          const SizedBox(height: 16,),
          Text('Email',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.w400, fontSize: 14, color: black),
          ),
          const SizedBox(
            height: 8,
          ),
          DexterTextField(
            minLines: null,
            maxLines: 1, expands: false,
            hintText: "abc@xyz.com",
            controller: emailController,
            validator: isValidEmailAddress,
          ),
          const SizedBox(height: 26,),
          DexterPrimaryButton(
            buttonBorder: greenPea, btnHeight: 52, btnTitleSize: 14, borderRadius: 35,
            btnTitle: "Save changes", btnColor: greenPea, titleColor: white,
            btnWidth: MediaQuery.of(context).size.width,
            onTap: (){
              Get.back();
              showEditProfileDialog();
            },
          ),
        ],
      ),
    ), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
    ),
      isScrollControlled: true,
    );
  }

  Future<void> launchUrlStart({required String url}) async {
    if (!await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void showDeleteBottomSheet(){
    Get.bottomSheet(
      Container(decoration: BoxDecoration(color: white,borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2.5,), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListView(
        children: [
          const SizedBox(height: 10,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delete Account", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 16, fontWeight: FontWeight.w600),),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 30, width: 30, decoration: BoxDecoration(shape: BoxShape.circle, color: iron),
                  child: Center(
                    child: Icon(
                      Icons.clear, color: black,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 22,),
          Image.asset("assets/png/alert!.png", height: 50, width: 50,),
          const SizedBox(height: 24,),
          Text("Are you sure you want to delete your \naccount?", textAlign: TextAlign.center, style:
          Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 16, fontWeight: FontWeight.w600),),
          Text("We will hate to see you go.", textAlign: TextAlign.center, style:
          Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),),
          const SizedBox(height: 24,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  launchUrlStart(url: "https://getdexterapp.com/delete");
                },
                child: Container(height: 38, padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: Color(0xffFCEFEF)),
                  child: Center(
                    child: Text("Delete Account", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: persianRed, fontSize: 14, fontWeight: FontWeight.w600),),
                  ),),
              ),
              const SizedBox(width: 25,),
              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Container(height: 38, padding: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: greenPea),
                  child: Center(
                    child: Text("Cancel", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: white, fontSize: 14, fontWeight: FontWeight.w600),),
                  ),),
              ),
            ],
          )
        ],
      ),
    ), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
    ),
      isScrollControlled: true,
    );
  }

  showSignOutDialog(){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: 'Sign Out',
        content: "Do you want to sign out from dexter vendor app?",
        backgroundColor: greenPea,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Yes',
              textColor: greenPea,
              onPressed: () async {
                log("message");
                Get.back();
                _controller.logOut(context: context);
                Get.deleteAll();
              }
          ),
          CleanDialogActionButtons(
              actionTitle: 'No',
              textColor: persianRed,
              onPressed: (){
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
        builder: (controller){
      return SafeArea(top: false, bottom: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: white,
            appBar: AppBar(
              actions: [
                GestureDetector(
                  onTap: (){
                    showSignOutDialog();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 20),
                    child: Text("Sign out", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: persianRed, fontSize: 14, fontWeight: FontWeight.w600),),
                  ),
                ),
              ],
              elevation: 0.0, backgroundColor: white,
              title: Text("Settings", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 22,),
                  Align(alignment: Alignment.center, child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return ViewProfilePhoto(controller.authUserResponse?.data?.image ?? profilePicturePlaceHolder);
                      }));
                    },
                      child: Hero(
                        tag: "profile_photo",
                        child: Container(
                          height: 86, width: 86,
                          decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(controller.authUserResponse?.data?.image ?? profilePicturePlaceHolder), fit: BoxFit.cover)),
                        ),
                      ))),
                      //Image.network(controller.authUserResponse!.data!.image == null ? profilePicturePlaceHolder : controller.authUserResponse!.data!.image!, height: 86, width: 86, fit: BoxFit.cover,))),
                  const SizedBox(height: 8,),
                  GestureDetector(
                    onTap: (){
                      showEditProfileBottomSheet(imagePath: controller.authUserResponse?.data?.image ?? profilePicturePlaceHolder);
                    },
                    child: Align(alignment: Alignment.center,
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${firstNameController.text} ${lastNameController.text}",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 18, fontWeight: FontWeight.w700),),
                            Icon(Icons.mode_edit_outlined, color: greenPea, size: 15,)
                          ],
                        )),
                  ),
                  const SizedBox(height: 3,),
                  Align(alignment: Alignment.center,
                      child: Text(controller.authUserResponse!.data!.email!,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.w400),)),
                  const SizedBox(height: 5,),
                  const SizedBox(height: 39,),
                  Align(alignment: Alignment.centerLeft,
                      child: Text("Notification", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: dustyGray, fontSize: 14, fontWeight: FontWeight.w400),)),
                  const SizedBox(height: 10,),
                  Container(
                    child: Column(
                      children: [
                        Container(
                            height: 50,
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(AssetPath.pushNotification, height: 35, width: 35,),
                                    const SizedBox(width: 16,),
                                    Text("Push Notification", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: thunder, fontSize: 14),),
                                  ],
                                ),
                                CupertinoSwitch(
                                  activeColor: greenPea,
                                    value: _controller.notificationStatus ?? false, onChanged: (value) async {
                                  if(value == true){
                                    _controller.sendFcmToken();
                                  }else{
                                    _controller.deleteFcmToken();
                                  }
                                })
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24,),
                  Align(alignment: Alignment.centerLeft,
                      child: Text("Dexter", style:
                      Theme.of(context).textTheme.bodySmall!.
                      copyWith(color: dustyGray, fontSize: 14, fontWeight: FontWeight.w400),)),
                  const SizedBox(height: 15,),
                  ...List.generate(dexterSettings.length, (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      onTap: (){
                        index == 1 ? Get.to(()=> const Faqs()) : index == 2 ? Get.to(()=> PrivacyPolicyScreen()) :
                        index == 0 ? Get.to(()=> ContactUsScreen()) : null;
                      },
                      child: Container(
                          height: 50, width: double.maxFinite, color: Colors.white,
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(dexterSettings[index]["assets"]!, height: 35, width: 35,),
                                  const SizedBox(width: 16,),
                                  Text(dexterSettings[index]["title"]!, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: thunder, fontSize: 14),),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios_outlined, color: black, size: 16,)
                            ],
                          )
                      ),
                    ),
                  ),),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    child: GestureDetector(
                      onTap: (){
                        showDeleteBottomSheet();
                      },
                      child: Container(height: 38, padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: Color(0xffFCEFEF)),
                        child: Center(
                          child: Text("Delete Account", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: persianRed, fontSize: 14, fontWeight: FontWeight.w600),),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26,),
                ],
              ),
            ),
          )
      );
    });
  }
}
