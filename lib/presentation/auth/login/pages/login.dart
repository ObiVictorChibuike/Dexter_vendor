import 'dart:io';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/presentation/auth/create_account/pages/create_account.dart';
import 'package:dexter_vendor/presentation/auth/login/controller/login_controller.dart';
import 'package:dexter_vendor/presentation/auth/reset_password/pages/password_reset.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with FormMixin{

  //Keys
  final scaffoldKey = GlobalKey <ScaffoldState>();
  final formKey = GlobalKey <FormState>();

  void underConstruction(BuildContext context) async {
    // show the loading dialog
    showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // Some text
                  Center(child: Text('Still Under Construction'))
                ],
              ),
            ),
          );
        });
  }

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
        builder: (controller){
      return SafeArea(top: false, bottom: false,
          child: Scaffold(
            key: scaffoldKey, backgroundColor: Colors.white,
            body: Form(
              key: formKey,
              child: AnimatedColumn(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  const SizedBox(height: 84,),
                  Text("Welcome back", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 28, fontWeight: FontWeight.w700, color: black),),
                  const SizedBox(height: 8,),
                  Text("Login to your account in few clicks", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w400),),
                  const SizedBox(height: 33,),
                  Text('Email',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DexterTextField(
                    minLines: null, maxLines: 1, expands: false,
                    hintText: "abc@xyz.com",
                    controller: controller.emailController,
                    validator: isValidEmailAddress,
                  ),
                  const SizedBox(height: 24,),
                  Text('Password',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DexterTextField(
                    obscureText: _obscureText,
                    minLines: null, maxLines: 1, expands: false,
                    hintText: "*********",
                    controller: controller.passwordController,
                    validator: (value){
                      return null;
                    },
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                          _obscureText ? Iconsax.eye_slash : Iconsax.eye,
                          size: 16,
                          color: const Color(0xff292D32)),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  GestureDetector(
                    onTap: (){
                      Get.to(()=> const ResetPasswordEmailVerification());
                    },
                    child: Align(alignment: Alignment.centerRight,
                        child: Text("Forgot Password?", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: greenPea),)),
                  ),
                  const SizedBox(height: 54,),
                  DexterPrimaryButton(
                    onTap: (){
                      if(formKey.currentState!.validate()){
                        formKey.currentState!.save();
                        controller.login();
                      }
                    },
                    buttonBorder: greenPea, btnTitle: "Sign In",
                    borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
                  ),
                  const SizedBox(height: 24,),
                  Align(alignment: Alignment.center,
                      child: Text("Or, login with...",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),)),
                  const SizedBox(height: 32,),
                  Platform.isAndroid ? Align(alignment: Alignment.center,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            // controller.handleSignIn();
                            underConstruction(context);
                          },
                          child: Container(
                            height: 80, width: 85,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Container(
                                height: 30, width: 30,
                                child: Image.asset(AssetPath.google, fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text("Google", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: dustyGray),)
                      ],
                    ),
                  ) : Align(alignment: Alignment.center,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            underConstruction(context);
                          },
                          child: Container(
                            height: 80, width: 85,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Container(
                                height: 30, width: 30,
                                child: Image.asset(AssetPath.apple, fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text("Apple", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w600, color: dustyGray),)
                      ],
                    ),
                  ),
                  const SizedBox(height: 70,),
                  Align(alignment: Alignment.center,
                    child: RichText(text: TextSpan(text: "Don't have an account? ", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: dustyGray), children: [
                      TextSpan(text: "Create one",  recognizer: new TapGestureRecognizer()..onTap = () => Get.to(()=>const CreateAccount()),
                          style:  Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea))
                    ])),
                  ),
                ],
              ),
            ),
          )
      );
    });
  }
}
