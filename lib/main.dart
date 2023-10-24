import 'package:dexter_vendor/app/bingdings/app_bindings.dart';
import 'package:dexter_vendor/app/shared/theme_config/theme_config.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/presentation/auth/create_account/pages/add_product.dart';
import 'package:dexter_vendor/presentation/auth/login/controller/login_controller.dart';
import 'package:dexter_vendor/presentation/intro/page/onboarding_screen.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/account/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/withdraw/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor_overview/vendor_overview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:upgrader/upgrader.dart';
import 'datas/services/notification/local_notification_services.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );
  if (message.notification != null && Platform.isIOS) {
    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  await Firebase.initializeApp();
  Get.put<LocalCachedData>(await LocalCachedData.create());
  final loggedIn = await LocalCachedData.instance.getLoginStatus();
  final controller = Get.put(LoginController());
  final _controller = Get.put(BankController());
  await controller.getAppServices();
  await _controller.getAllBank();
  runApp(MyApp(loggedIn: loggedIn,));
}

class MyApp extends StatefulWidget {
  final bool? loggedIn;
  const MyApp({Key? key, this.loggedIn}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,));
    return UpgradeAlert(
      upgrader: Platform.isAndroid ? Upgrader(shouldPopScope: () => true) : Upgrader(shouldPopScope: () => true, dialogStyle: UpgradeDialogStyle.cupertino),
      child: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: GetMaterialApp(
          initialBinding: InitialBindings(),
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.applicationTheme(),
          home: widget.loggedIn == true ? VendorOverView() : OnBoardingScreen(),
        ),
      ),
    );
  }
}

