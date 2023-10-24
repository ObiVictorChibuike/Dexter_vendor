import 'package:clean_dialog/clean_dialog.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationDetails extends StatefulWidget {
  final String title;
  final String body;
  final String id;
  final dynamic readAt;
  const NotificationDetails({super.key, required this.title, required this.body, required this.id, this.readAt});

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  HomeController controller = Get.find<HomeController>();
  showAlertDialog({required String notificationId}){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: 'Mark As Read',
        content: "Do you want to mark this notification as Read",
        backgroundColor: greenPea,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Confirm Request',
              textColor: persianRed,
              onPressed: (){
                Navigator.pop(context);
                controller.markAsRead(context: context, notificationId: notificationId, isNotificationDetails: true);
              }
          ),
          CleanDialogActionButtons(
              actionTitle: 'Decline Request',
              textColor: greenPea,
              onPressed: (){
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller){
          return SafeArea(top: false, bottom: false,
              child: Scaffold(
                backgroundColor: white,
                appBar: AppBar(
                  centerTitle: true,
                  leading: GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(color: Color(0xffF2F2F2), shape: BoxShape.circle),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      )),
                  elevation: 0.0, backgroundColor: white,
                  title: Text("Notifications Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: ListView(
                    children: [
                      const SizedBox(height: 10,),
                      Container(
                          decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(13)),
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.title ?? "", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 16, fontWeight: FontWeight.w600),),
                                const SizedBox(height: 10,),
                                Text(widget.body ?? "", style: Theme.of(context).textTheme.bodySmall?.
                                copyWith(color: Color(0xff8F92A1), fontSize: 12,
                                    fontWeight: widget.readAt == null ? FontWeight.w600 : FontWeight.w400),),
                                widget.readAt == null ? const SizedBox(height: 5,) : const SizedBox(),
                                widget.readAt == null ? Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        showAlertDialog(notificationId: widget.id.toString());
                                      },
                                      child: Align(alignment: Alignment.centerRight,
                                        child: Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), width: MediaQuery.of(context).size.width/ 3.5,
                                          decoration:BoxDecoration(color: greenPea, borderRadius: BorderRadius.circular(30)),
                                          child: Center(child: Text("Mark as read",  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: white, fontSize: 12, fontWeight: FontWeight.w600),)),),
                                      ),
                                    ),
                                  ],
                                ) : const SizedBox(),
                              ]))
                    ],
                  ),
                ),
              )
          );
        });
  }
}
