import 'package:carousel_slider/carousel_slider.dart';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/presentation/auth/create_account/pages/create_account.dart';
import 'package:dexter_vendor/presentation/auth/login/pages/login.dart';
import 'package:dexter_vendor/presentation/intro/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GetBuilder<OnBoardingController>(
      init: OnBoardingController(),
        builder: (controller){
      return SafeArea(top: false, bottom: false,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(AssetPath.frame),
                  Expanded(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        scrollPhysics: NeverScrollableScrollPhysics(),
                          height: height, scrollDirection: Axis.vertical,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              controller.current = index;
                            });
                          }
                      ),
                      items: controller.dexterOptions.map((item) => Center(
                        child: Text(item, textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 28, fontWeight: FontWeight.w700),),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 56,),
                  DexterPrimaryButton(
                    onTap: (){
                      Get.to(()=> const CreateAccount());
                    },
                    buttonBorder: greenPea, btnTitle: "Create an account",
                    borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
                  ),
                  const SizedBox(height: 16,),
                  DexterPrimaryButton(
                    onTap: (){
                      Get.to(()=> const Login());
                    },
                    buttonBorder: tulipTree, btnTitle: "Login", btnColor: tulipTree,
                    borderRadius: 30, titleColor: black, btnHeight: 56, btnTitleSize: 16,
                  ),
                  const SizedBox(height: 42,)
                ],
              ),
            ),
          )
      );
    });
  }
}
