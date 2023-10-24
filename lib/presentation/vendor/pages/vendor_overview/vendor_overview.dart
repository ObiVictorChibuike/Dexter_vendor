import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/datas/services/notification/local_notification_services.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/presentation/message/page/chat_history.dart';
import 'package:dexter_vendor/presentation/settings/settings_page.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Booking/controller/booking_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Booking/pages/booking_screen.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Order/pages/order_screen.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class VendorOverView extends StatefulWidget {
  const VendorOverView({Key? key}) : super(key: key);

  @override
  State<VendorOverView> createState() => _VendorOverViewState();
}

class _VendorOverViewState extends State<VendorOverView> {
  HomeController homeController = Get.put(HomeController());
  checkBusinessType() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    homeController.serviceStatus = await LocalCachedData.instance.getIsBookableServiceStatus();
    setState(() {});
  }

  pushNotificationOnInitConfiguration() {
    // LocalNotificationService.initialize();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Get.to(() => const VendorOverView());
      }
    });
    //Is called when the app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {}
      LocalNotificationService.displayNotification(message);
    });
    //Only works When the app is in background but opened
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.data);
      Get.to(() => const VendorOverView());
    });
  }


  @override
  void initState() {
    pushNotificationOnInitConfiguration();
    checkBusinessType();
    super.initState();
  }

  List<Widget> businessPages = [
    const HomePage(),
    const BookingScreen(),
    // const Products(),
    // const ContactPage(),
    const ChatHistory(),
    const SettingsScreen()
  ];

  List<Widget> shopPages = [
    const HomePage(),
    const OrderScreen(),
    // const Products(),
    // const ContactPage(),
    const ChatHistory(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GetBuilder<HomeController>(
        init: HomeController(),
          builder: (controller){
        return Scaffold(
          body: homeController.serviceStatus == true ? businessPages[controller.selectedIndex.value] : shopPages[controller.selectedIndex.value],
          backgroundColor: Colors.white,
          bottomNavigationBar: SizedBox(
            height: 80,
            child: BottomNavigationBar(
              elevation: 0.0,
              type: BottomNavigationBarType.fixed,
              iconSize: 18,
              currentIndex: controller.selectedIndex.value,
              showUnselectedLabels: true,
              backgroundColor: white,
              unselectedItemColor: const Color(0xff292D32),
              selectedItemColor: greenPea,
              onTap: controller.changeIndex,
              items: [
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: const Icon(Iconsax.home),
                ),
                BottomNavigationBarItem(
                  label: homeController.serviceStatus == true? 'Bookings' :'Order',
                  icon: const Icon(Iconsax.activity),
                ),
                BottomNavigationBarItem(
                  label: 'Chats',
                  icon: const Icon(Iconsax.message),
                ),
                BottomNavigationBarItem(
                    label: 'Settings',
                    icon: const Icon(Iconsax.setting)
                ),
              ],
            ),
          ),
        );
      })
    );
  }
}
