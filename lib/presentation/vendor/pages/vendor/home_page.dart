import 'dart:async';
import 'dart:developer';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/custom_date.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/presentation/auth/create_account/controller/registration_controller.dart';
import 'package:dexter_vendor/presentation/message/controller/message_controller.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Booking/pages/booking_details.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/account/pages/account_page.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/request/pages/all_pending_booking_request_page.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/request/pages/all_pending_order_request_page.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/notification/notification.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/pages/products.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/view_profile_photo.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/withdraw/controller/controller.dart';
import 'package:dexter_vendor/widget/dexter_bottom_sheet.dart';
import 'package:dexter_vendor/widget/dexter_pop_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:money_formatter/money_formatter.dart';
import 'Order/pages/order_details.dart';
import 'business/pages/business.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = Get.find<HomeController>();
  ProductController productController = Get.put(ProductController());
  WithdrawalController withdrawalController = Get.put(WithdrawalController());

  void loadCategory()async{
    final registrationController = Get.put(RegistrationController());
    Get.put<LocalCachedData>(await LocalCachedData.create());
    await LocalCachedData.instance.getIsBookableServiceStatus().then((value) async {
      if(value != true){
        await registrationController.getCategory();
      }else{
        null;
      }
    });
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }if (hour < 17) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }
  bool isVisible = false;
  getPending() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final status = await LocalCachedData.instance.getIsBookableServiceStatus();
    if(status == true){
      homeController.getPendingBookings();
    }else{
      homeController.getPendingOrder();
    }
  }
  @override
  void initState() {
    checkBusinessType();
    loadCategory();
    getPending();
    withdrawalController.getAllBankAccount();
    homeController.getVendorProfile();
    homeController.getNotification();
    homeController. onInitializeLocalStorage();
    notificationCheckStatus();
    super.initState();
  }

  Timer interval(Duration duration, func) {
    Timer function() {
      Timer timer = Timer(duration, function);
      func(timer);
      return timer;
    }
    return Timer(duration, function);
  }

  notificationCheckStatus(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notificationStatus = await LocalCachedData.instance.getIsEnableNotificationStatus();
      if(notificationStatus == null && context.mounted){
        interval(const Duration(minutes: 10), (timer) {
          showEnableNotificationBottomSheet(context);
          if (kDebugMode) {
            print(homeController.enableNotificationPromptCount++);
          }
          if (homeController.enableNotificationPromptCount > 1) timer.cancel();
        });
      }else{
        null;
      }
    });
  }

  checkBusinessType() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    homeController.serviceStatus = await LocalCachedData.instance.getIsBookableServiceStatus();
    if(homeController.serviceStatus == true){
      homeController.getPendingBookings();
    }else{
      homeController.getPendingOrder();
    }
    setState(() {});
  }

  void deleteFcmToken(BuildContext context)async{
    Get.back();
    Get.back();
    homeController.deleteFcmToken();
  }

  void showEnableNotificationBottomSheet(BuildContext context){
    MyBottomSheet().showNonDismissibleBottomSheet(context: context, height: 320,
        children:[
          Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 30, width: 30, decoration: BoxDecoration(shape: BoxShape.circle, color: iron),
                    child: Center(
                      child: Icon(
                          Icons.clear, color: black, size: 23
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Image.asset(AssetPath.bell,width: 70, height: 70,),
              const SizedBox(height: 20,),
              Text("Enable Notifications?", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 20, fontWeight: FontWeight.w700, color: black),),
              const SizedBox(height: 11,),
              Text("We’ll send you offers and reminders. You’ll never miss a message or an appointment.",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: black),),
              const SizedBox(height: 40,),
              DexterPrimaryButton(
                onTap: (){
                  DexterPopUp(
                      apply1: () async {
                        Get.back();
                        Get.back();
                        await homeController.sendFcmToken();
                      },
                      apply: () {
                        deleteFcmToken(context);
                      },
                      btntext1: "Allow", btntext: "Don’t Allow",
                      context: context, title: "“Dexter” would like to send you notifications",
                      body: "Notifications may include alerts, sounds and icon badges, these can be configured in settings."
                  );
                },
                btnTitle: "Sounds good", btnTitleSize: 16, borderRadius: 35, btnHeight: 48,
                btnWidth: MediaQuery.of(context).size.width,
              )
            ],
          )
        ]);
  }

  void showTransactionApprovedBottomSheet(BuildContext context){
    MyBottomSheet().showNonDismissibleBottomSheet(context: context, height: 400,
        children:[
          Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 54,
              ),
              Image.asset(AssetPath.money),
              const SizedBox(
                height: 54,
              ),
              Text('Transaction approved',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w700, fontSize: 16, color: black),
              ),
              const SizedBox(
                height: 8,
              ),
              Text('Your money is on its way to your bank',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.w700, fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(
                height: 48,
              ),
              DexterPrimaryButton(
                onTap: (){
                },
                btnTitle: "Done", btnTitleSize: 16, borderRadius: 35, btnHeight: 56,
                btnWidth: MediaQuery.of(context).size.width,
              )
            ],
          )
        ]);
  }
  MessageController messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
        builder: (controller){
          MoneyFormatter formatWalletBalance = MoneyFormatter(
              amount: double.parse(homeController.vendorProfileResponse?.data?.availableBalance ?? "0.00"),
          );
      return SafeArea(top: false, bottom: false,
          child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              centerTitle: false, elevation: 0, backgroundColor: white,
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ViewProfilePhoto(controller.authUserResponse?.data?.image ?? profilePicturePlaceHolder);
                    }));
                  },
                  child: Hero(
                    tag: "profile_photo",
                    child: Container(
                      height: 36, width: 36,
                      decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(controller.authUserResponse?.data?.image ?? profilePicturePlaceHolder), fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ),
              title: Text("${controller.vendorShopResponse?.data?.name?? ""}",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: black)),
              actions: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0, top: 10),
                      child: GestureDetector(
                        onTap: () async {
                          Get.to(()=> const Notifications(),);
                        },
                        child: Container(
                          height: 36, width: 36,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Color(0xffD9D9D9))),
                          child: Center(child: Icon(Iconsax.notification, color: black,),
                          ),
                        ),
                      ),
                    ),
                    controller.notificationLength == 0 ? const SizedBox()
                    // Positioned(top: 11, left: 2,
                    //   child: Container(height: 8, width: 8,
                    //     decoration: BoxDecoration(shape: BoxShape.circle,
                    //         border: Border.all(color: persianRed), color: persianRed),
                    //   ),
                    // )
                        :
                    Positioned(top: 10, left: 0,
                      child: Container(height: 18, width: 18,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                            border: Border.all(color: persianRed), color: persianRed),
                        child: Center(child: Text(controller.notificationLength.toString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: (){
                      homeController.moveToChat();
                      // Get.offAll(()=>VendorOverView());
                      // homeController.selectedIndex = 2;
                      // setState(() {});
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 36, width: 36,
                          margin: EdgeInsets.only(right: 20, left: 5),
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Color(0xffD9D9D9))),
                          child: Center(
                            child: Icon(Iconsax.message, color: black,),
                          ),
                        ),
                        messageController.messageListTotal == 0 ? const SizedBox()
                        // Positioned(top: 2, left: 4,
                        //   child: Container(height: 8, width: 8,
                        //     decoration: BoxDecoration(shape: BoxShape.circle,
                        //         border: Border.all(color: persianRed), color: persianRed),
                        //   ),
                        // )
                            :
                        Container(height: 18, width: 18,
                          decoration: BoxDecoration(shape: BoxShape.circle,
                              border: Border.all(color: persianRed), color: persianRed),
                          child: Center(child: Text(messageController.messageListTotal.toString(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text("${greeting()}, ", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color(0xff999999), fontWeight: FontWeight.w500, fontSize: 12),),
                          const SizedBox(width: 10,),
                          greeting() == "Good morning" ? Icon(Icons.cloud, color: tulipTree, size: 15,) : greeting() == "Good afternoon" ? Icon(Icons.sunny, color: tulipTree, size: 15,) : Icon(Icons.nightlight_round, color: tulipTree, size: 15,),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Text("${controller.authUserResponse?.data?.firstName ?? ""}", style: Theme.of(context).textTheme.bodyLarge?.
                          copyWith(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),),
                          const SizedBox(width: 10,),
                          Image.asset("assets/png/hi.png", height: 15, width: 15,),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12,),
                  Container(
                    height: MediaQuery.of(context).size.height / 6.8,
                    width: double.maxFinite, decoration: BoxDecoration(color: greenPea, borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 8,),
                        Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Wallet Balance", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15, fontWeight: FontWeight.w400, color: white)),
                              ],
                            ),
                            Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text( isVisible == false ? "*******" : "NGN ${formatWalletBalance.output.nonSymbol}",
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 25, fontWeight: FontWeight.w700, color: white)),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  }, child: Icon(isVisible == false ? Icons.visibility : Icons.visibility_off, color: white,))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.to(()=> const AccountPage());
                          },
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 50, width: MediaQuery.of(context).size.width/2.5, decoration: BoxDecoration(color: Color(0xffE6E6E6), borderRadius: BorderRadius.circular(8)),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(AssetPath.moneyCalculator, height: 40, width: 40),
                                      const SizedBox(width: 2),
                                      Text("Accounts", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: greenPea)),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            homeController.serviceStatus == true ? Get.to(()=> BusinessPage()) : Get.to(()=> Products());
                          },
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 50, width: MediaQuery.of(context).size.width/2.5, decoration: BoxDecoration(color: Color(0xffE6E6E6), borderRadius: BorderRadius.circular(8)),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(AssetPath.vendor, height: 40, width: 40),
                                      const SizedBox(width: 2),
                                      Text(homeController.serviceStatus == true ? "View Business": "View Shop",
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 13, fontWeight: FontWeight.w500, color: greenPea)),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  homeController.serviceStatus == true ?
                  Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Pending Requests", style:
                          Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: black)),
                          controller.pendingBookingsResponseModel == null || controller.pendingBookingsResponseModel!.isEmpty || controller.pendingBookingsResponseModel == [] ?
                          Text("See all", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12,
                              fontWeight: FontWeight.w600, color: Color(0xff999999))) :
                          InkWell(
                              onTap: (){
                                Get.to(()=> const AllPendingBookingPage());
                              },
                              child: Text("See all", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12,
                                  fontWeight: FontWeight.w600, color: greenPea))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      controller.pendingBookingsResponseModel == null && controller.getPendingBookingsLoadingState == true && controller.getPendingBookingsErrorState == false ?
                      Center(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height/6,),
                            CupertinoActivityIndicator(),
                            const SizedBox(height: 10,),
                            Text("Please wait...", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),)
                          ],
                        ),
                      ) :
                      controller.pendingBookingsResponseModel == null || controller.pendingBookingsResponseModel!.isEmpty || controller.pendingBookingsResponseModel == [] ?
                      Column(
                        children: [
                          Image.asset("assets/png/man_holding_money.png", height: 200, width: 200,),
                          Text("Nothing to see here!",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),),
                          const SizedBox(height: 10,),
                          Text("You have no pending request yet", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w400),),
                        ],
                      ) :
                      Column(
                        children: [
                          ...List.generate(controller.pendingBookingsResponseModel!.length, (index){
                            final item = controller.pendingBookingsResponseModel![index];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Get.to(()=> BookingDetails(bookingId: item.id.toString()));
                                  },
                                  child: Container(
                                    width: double.maxFinite, padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration( borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: dustyGray)),
                                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(borderRadius: BorderRadius.circular(80),
                                              child: Container(height: 40, width: 40, decoration: BoxDecoration(shape: BoxShape.circle),
                                                child: Image.network(
                                                  item.user?.coverImage ??
                                                      imagePlaceHolder , height: 40, width: 40, fit: BoxFit.cover,),
                                              ),
                                            ),
                                            const SizedBox(width: 15,),
                                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${item.user?.firstName ?? ""} ${item.user?.lastName ?? ""}",
                                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14, fontWeight: FontWeight.w600),),
                                                Text(CustomDate.slash(item.scheduledDate.toString()),
                                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color(0xff8F92A1), fontSize: 12, fontWeight: FontWeight.w600),),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: black, borderRadius: BorderRadius.circular(2)),
                                          child: Text(item.status ?? "",  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: white, fontSize: 10, fontWeight: FontWeight.w700),),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                              ],
                            );
                          })
                        ],
                      ),
                    ],
                  ) : Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Pending Requests", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: black)),
                              controller.pendingOrderResponseModel == null || controller.pendingOrderResponseModel!.isEmpty || controller.pendingOrderResponseModel == [] ?
                              Text("See all", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12,
                                  fontWeight: FontWeight.w600, color: Color(0xff999999))) :
                              InkWell(
                                  onTap: (){
                                    Get.to(()=> const AllPendingOrderRequestScreen());
                                  },
                                  child: Text("See all", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12,
                                      fontWeight: FontWeight.w600, color: greenPea))),
                            ],
                          ),
                          const SizedBox(height: 16),
                          controller.pendingOrderResponseModel == null && controller.getPendingOrderLoadingState == true && controller.getPendingOrderErrorState == false ?
                          Center(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height/6,),
                                CupertinoActivityIndicator(),
                                const SizedBox(height: 10,),
                                Text("Please wait...", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),)
                              ],
                            ),
                          ) : controller.pendingOrderResponseModel == null || controller.pendingOrderResponseModel!.isEmpty || controller.pendingOrderResponseModel == [] ?
                          Column(
                            children: [
                              Image.asset("assets/png/man_holding_money.png", height: 200, width: 200,),
                              Text("Nothing to see here!",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),),
                              const SizedBox(height: 10,),
                              Text("You have no pending request yet", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w400),),
                            ],
                          ) :
                          Column(
                            children: [
                              ...List.generate(controller.pendingOrderResponseModel!.length, (index){
                                final item = controller.pendingOrderResponseModel![index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> OrderDetails(orderId: item.id.toString(),)));
                                      },
                                      child: Container(
                                        width: double.maxFinite, padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration( borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: dustyGray)),
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                ClipRRect(borderRadius: BorderRadius.circular(80),
                                                  child: Container(height: 40, width: 40, decoration: BoxDecoration(shape: BoxShape.circle),
                                                    child: Image.network(
                                                      item.user?.coverImage ??
                                                          imagePlaceHolder , height: 40, width: 40, fit: BoxFit.cover,),
                                                  ),
                                                ),
                                                const SizedBox(width: 15,),
                                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${item.user?.firstName ?? ""} ${item.user?.lastName ?? ""}",
                                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14, fontWeight: FontWeight.w600),),
                                                    Text(CustomDate.slash(item.createdAt.toString()),
                                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color(0xff8F92A1), fontSize: 12, fontWeight: FontWeight.w600),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: black, borderRadius: BorderRadius.circular(2)),
                                              child: Text(item.status ?? "",  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: white, fontSize: 10, fontWeight: FontWeight.w700),),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                  ],
                                );
                              })
                            ],
                          ),
                        ],
                      )
                ],
              ),
            ),
          )
      );
    });
  }
}
