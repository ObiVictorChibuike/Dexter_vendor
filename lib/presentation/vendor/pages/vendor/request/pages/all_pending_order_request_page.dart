import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/custom_date.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Order/pages/order_details.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dexter_vendor/widget/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllPendingOrderRequestScreen extends StatefulWidget {
  const AllPendingOrderRequestScreen({super.key});

  @override
  State<AllPendingOrderRequestScreen> createState() => _AllPendingOrderRequestScreenState();
}

class _AllPendingOrderRequestScreenState extends State<AllPendingOrderRequestScreen> {

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
              title: Text("Pending Order Requests", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
            ),
            body: _controller.pendingOrderResponseModel == null || _controller.pendingOrderResponseModel!.isEmpty && _controller.getPendingOrderLoadingState == true && _controller.getPendingOrderErrorState == false ?
                CircularLoadingWidget() :
            _controller.pendingOrderResponseModel == null || _controller.pendingOrderResponseModel!.isEmpty && _controller.getPendingOrderLoadingState == false &&
                _controller.getPendingOrderErrorState == false ?
            Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/png/man_holding_money.png", height: 200, width: 200,),
                  Text("Nothing to see here!",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),),
                  const SizedBox(height: 10,),
                  Text("You have no pending request yet", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w400),),
                ],
              ),
            ) : _controller.pendingOrderResponseModel != null || _controller.pendingOrderResponseModel!.isNotEmpty && _controller.getPendingOrderLoadingState == false &&
          _controller.getPendingOrderErrorState == false ?
            AnimatedColumn(children: [
              ...List.generate( controller.pendingOrderResponseModel!.length, (index){
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
                                Image.network(
                                  item.user?.coverImage ?? imagePlaceHolder , height: 40, width: 40,),
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
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: tulipTree, borderRadius: BorderRadius.circular(2)),
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
            ], padding: EdgeInsets.symmetric(horizontal: 20)) : Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/6,),
                  CupertinoActivityIndicator(),
                  const SizedBox(height: 10,),
                  Text("Please wait...", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),)
                ],
              ),
            ),
          )
      );
    });
  }
  final _controller = Get.find<HomeController>();

  @override
  void initState() {
    _controller.getPendingOrder();
    super.initState();
  }
}
