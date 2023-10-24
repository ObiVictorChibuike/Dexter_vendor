import 'package:dexter_vendor/presentation/auth/create_account/controller/registration_controller.dart';
import 'package:dexter_vendor/presentation/auth/login/controller/login_controller.dart';
import 'package:dexter_vendor/presentation/auth/reset_password/controller/password_reset_controller.dart';
import 'package:dexter_vendor/presentation/intro/controller/controller.dart';
import 'package:dexter_vendor/presentation/message/controller/chat_controller.dart';
import 'package:dexter_vendor/presentation/message/controller/contact_controller.dart';
import 'package:dexter_vendor/presentation/message/controller/image_view_controller.dart';
import 'package:dexter_vendor/presentation/message/controller/message_controller.dart';
import 'package:dexter_vendor/presentation/message/controller/profile_controller.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Booking/controller/booking_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Order/controller/order_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/account/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/business/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/transaction/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/withdraw/controller/controller.dart';
import 'package:get/get.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(
      LoginController(),
      // permanent: true,
    );
    Get.put<RegistrationController>(
      RegistrationController(),
      // permanent: true,
    );
    Get.put<PasswordResetController>(
      PasswordResetController(),
      // permanent: true,
    );
    Get.put<OnBoardingController>(
      OnBoardingController(),
      // permanent: true,
    );
    Get.put<ChatController>(
      ChatController(),
      // permanent: true,
    );
    Get.put<ContactController>(
      ContactController(),
      // permanent: true,
    );
    Get.put<ImageViewController>(
      ImageViewController(),
      // permanent: true,
    );
    Get.put<MessageController>(
      MessageController(),
      // permanent: true,
    );
    Get.put<ProfileController>(
      ProfileController(),
      // permanent: true,
    );
    Get.put<HomeController>(
      HomeController(),
      // permanent: true,
    );
    Get.put<BankController>(
      BankController(),
      // permanent: true,
    );
    Get.put<BookingController>(
      BookingController(),
      // permanent: true,
    );
    Get.put<BookingController>(
      BookingController(),
      // permanent: true,
    );
    Get.put<BusinessController>(
      BusinessController(),
      // permanent: true,
    );
    Get.put<OrderController>(
      OrderController(),
      // permanent: true,
    );
    Get.put<ProductController>(
      ProductController(),
      // permanent: true,
    );
    Get.put<TransactionController>(
      TransactionController(),
      // permanent: true,
    );
    Get.put<WithdrawalController>(
      WithdrawalController(),
      // permanent: true,
    );
  }
}