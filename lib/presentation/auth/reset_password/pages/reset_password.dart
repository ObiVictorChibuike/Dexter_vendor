import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/utils/form_mixin.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/presentation/auth/reset_password/controller/password_reset_controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> with FormMixin{
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _controller = PasswordResetController();
  bool _obscureText = true;
  bool _obscureConfirmPassword = true;
  final formKey = GlobalKey <FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(top: false, bottom: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0, backgroundColor: white,
        ),
        body: Form(
          key: formKey,
          child: AnimatedColumn(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              Text("Reset password", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black),),
              const SizedBox(height: 8,),
              Text("A verification code will be sent to your email, please enter your email address.", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),),
              const SizedBox(height: 33,),
              Text('New Password',
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
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                validator: validatePassword(
                    shouldContainSpecialChars: true,
                    shouldContainCapitalLetter: true,
                    shouldContainNumber: true,
                    minLength: 8,
                    maxLength: 32,
                    errorMessage:
                    "Password must be up to 8 characters",
                    onNumberNotPresent: () {
                      return "Password must contain number";
                    },
                    onSpecialCharsNotPresent: () {
                      return "Password must contain special characters";
                    },
                    onCapitalLetterNotPresent: () {
                      return "Password must contain capital letters";
                    }),
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
              const SizedBox(height: 16,),
              Text('Confirm New Password',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 14, color: black),
              ),
              const SizedBox(
                height: 8,
              ),
              DexterTextField(
                obscureText: _obscureConfirmPassword,
                minLines: null, maxLines: 1, expands: false,
                hintText: "*********",
                keyboardType: TextInputType.visiblePassword,
                controller: confirmPasswordController,
                validator: (value){
                  if(value == "" || value!.isEmpty){
                    Get.snackbar("Error", "Please confirm password to continue");
                  }else if(value != passwordController.text){
                    Get.snackbar("Error", "Password mismatch");
                  }
                  return null;
                },
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  child: Icon(
                      _obscureConfirmPassword ? Iconsax.eye_slash : Iconsax.eye,
                      size: 16,
                      color: const Color(0xff292D32)),
                ),
              ),
              const SizedBox(height: 36,),
              DexterPrimaryButton(
                onTap: (){
                  if(formKey.currentState!.validate()){
                    _controller.resetPassword(email: _controller.emailController.text,
                        token: _controller.verificationCode.text,
                        password: passwordController.text,
                        confirmPassword: confirmPasswordController.text, context: context);
                  }
                },
                buttonBorder: greenPea, btnTitle: "Reset password",
                borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
              ),
              const SizedBox(height: 48,),
            ],
          ),
        ),
      ),
    );
  }
}
