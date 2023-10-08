import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/presentation/auth/reset_password/controller/password_reset_controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordEmailVerification extends StatefulWidget {
  const ResetPasswordEmailVerification({Key? key}) : super(key: key);

  @override
  State<ResetPasswordEmailVerification> createState() => _ResetPasswordEmailVerificationState();
}

class _ResetPasswordEmailVerificationState extends State<ResetPasswordEmailVerification> with FormMixin{
  final formKey = GlobalKey <FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordResetController>(
      init: PasswordResetController(),
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
                  Text("Reset Password", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 28, fontWeight: FontWeight.w700, color: black),),
                  const SizedBox(height: 8,),
                  Text("A verification code will be sent to your email, please \nenter your email address.", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),),
                  const SizedBox(height: 33,),
                  Text('Email',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DexterTextField(
                    // readOnly: controller.isSuccessFul == true ? true : false,
                    minLines: null, maxLines: 1, expands: false,
                    hintText: "abc@xyz.com",
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.emailController,
                    validator: isValidEmailAddress,
                  ),
                  // controller.isSuccessFul == true ?
                  // Column(crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const SizedBox(
                  //       height: 16,
                  //     ),
                  //     Text('We sent Verification Token to ${controller.emailController.text}. Please check your inbox and enter the Token received.',
                  //       style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400, fontSize: 14,),),
                  //     const SizedBox(
                  //       height: 16,
                  //     ),
                  //     Text('Verification Code',
                  //       style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  //           fontWeight: FontWeight.w400, fontSize: 14, color: black),
                  //     ),
                  //     const SizedBox(
                  //       height: 8,
                  //     ),
                  //     DexterTextField(
                  //       minLines: null, maxLines: 1, expands: false,
                  //       hintText: "Enter code",
                  //       keyboardType: TextInputType.visiblePassword,
                  //       controller: controller.verificationCode,
                  //       validator: isRequired,
                  //     ),
                  //   ],
                  // )
                  //     : const SizedBox(),
                  const SizedBox(height: 36,),
                  DexterPrimaryButton(
                    onTap: (){
                      if(formKey.currentState!.validate()){
                        // controller.isSuccessFul == true ?
                        // controller.confirmResetPasswordToken(email: controller.emailController.text, context: context, token: controller.verificationCode.text) :
                      controller.confirmResetPasswordEmail(email: controller.emailController.text, context: context);

                      }
                      // Get.to(()=> const SuccessScreen());
                    },
                    buttonBorder: greenPea, btnTitle: "Verify",
                    borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
                  ),
                  // const SizedBox(height: 48,),
                  // GestureDetector(
                  //   onTap: (){
                  //     Get.offAll(()=>Login());
                  //   },
                  //   child: Align(alignment: Alignment.center,
                  //     child: RichText(text: TextSpan(text: "Already have an account? ", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: dustyGray), children: [
                  //       TextSpan(text: "Sign in", style:  Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea)),
                  //     ])),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
      );
    });
  }
}
