import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/presentation/message/page/contact_page.dart';
import 'package:dexter_vendor/widget/message_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChatHistory extends StatefulWidget {
   const ChatHistory({Key? key}) : super(key: key);

   @override
   State<ChatHistory> createState() => _ChatHistoryState();
 }

 class _ChatHistoryState extends State<ChatHistory> {
   @override
   Widget build(BuildContext context) {
     return SafeArea(top: false, bottom: false,
       child: Scaffold(
         backgroundColor: Colors.white,
         appBar: AppBar(
           elevation: 0.0, backgroundColor: Colors.white,
           title: Text("Message", style:
           Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),),
         ),
         // floatingActionButton: FloatingActionButton(onPressed: (){Get.to(()=> const ContactPage());},
         //   child: Image.asset("assets/png/contact-us.png", color: Colors.white, height: 35, width: 35,),
         // ),
         body: MessageHistoryWidget(),
       ),
     );
   }
 }
