// import 'package:another_flushbar/flushbar.dart';
// import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class FlushBarHelper{
//   BuildContext c;
//   Flushbar? flush;
//   String? message;
//   String? title;
//   FlushBarHelper(this.c, this.message, this.title);
//
//   showFlushBar({Color? color}){
//     flush = Flushbar(
//       titleText: Text(title!, style: Theme.of(c).textTheme.bodyText1?.copyWith(color: Colors.white, fontSize: 16),),
//       messageText:  Text(message!, style: Theme.of(c).textTheme.bodyText1?.copyWith(color: Colors.white, fontSize: 14),),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       flushbarPosition: FlushbarPosition.TOP,
//       backgroundColor:  color ?? Colors.white,
//       // mainButton: Icon(icon, color: iconColor ?? Colors.white, size: 25,),
//       margin: EdgeInsets.all(15),
//       borderRadius: BorderRadius.circular(15),
//       isDismissible: true,
//       duration: const Duration(seconds: 3),
//     )..show(c);
//   }
//
//   get showErrorBar => FlushBarHelper(c, message, title).
//   showFlushBar(color: accentRed[100]);
//
//   get showSuccessBar => FlushBarHelper(c, message, title).
//   showFlushBar(color: greenPea);
//
// }