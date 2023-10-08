import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/presentation/auth/create_account/pages/vendor_type.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuildLines extends StatelessWidget {
  const GuildLines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final guildLines = [
      {
        "header": "A clear headshot of yourself: ",
        "body": "Preferably a photo having a light coloured background."
      },
      {
        "header": "Your basic details: ",
        "body": "Such as your full name, highest school qualification, state and city located, etc."
      },
      {
        "header": "Your Business name: ",
        "body": "This gives you a distinct name and makes it easier for potential customers to find you"
      },
      {
        "header": "Your Bio: ",
        "body": "A good bio helps you establish credibility, build trust with potential customers, increase your visibility and differentiate you from other vendors."
      },
      {
        "header": "A business cover: ",
        "body": "This is optional, but it helps customers recognise your profile at a glance."
      },
      {
        "header": "National Identification Number: ",
        "body": "The National Identification Number (NIN) is the unique number which identifies you for life and is issued to you by NIMC after your enrolment."
      },
      {
        "header": "Tax Identification Number (TIN): ",
        "body": "Your TIN is a unique number used to track tax returns, payments, and other financial transactions."
      },
    ];

    return SafeArea(top: false, bottom: false,
        child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: white,
            title: Text("Registration Preparation", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700, fontSize: 20)),
          ),
          body: AnimatedColumn(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              const SizedBox(height: 8,),
              Text("To make your registration less seamless, kindly \nfollow the checklist numbered below:", textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 14, color: Color(0xff666666))),
              const SizedBox(height: 32,),
              Container(
                decoration: BoxDecoration(color: white,
                    borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xffE6E6E6))),
                child: Column(
                  children: [
                    const SizedBox(height: 24,),
                    ClipRRect(borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 100, width: 100, decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Center(
                          child: Image.asset("assets/png/avi.png"),
                        ),
                      ),
                    ),
                    ...List.generate(guildLines.length, (index){
                      return  ListTile(dense: true,
                        visualDensity: VisualDensity(vertical: -4),
                        minVerticalPadding: 15,
                        horizontalTitleGap: -20,
                        leading: Text("${index + 1}", style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700, fontSize: 15, color: black)),
                        title: RichText(text: TextSpan(text: guildLines[index]["header"],
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w700, fontSize: 12, color: black),
                            children: [
                              TextSpan(text: guildLines[index]["body"],  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xff666666)))
                            ])),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16,),
              DexterPrimaryButton(
                onTap: (){
                  Get.to(()=> const VendorType());
                },
                buttonBorder: greenPea, btnTitle: "Proceed",
                borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
              ),
              const SizedBox(height: 40,),
            ],
          ),
        )
    );
  }
}
