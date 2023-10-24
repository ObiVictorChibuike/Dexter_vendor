import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/custom_date.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Order/controller/order_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Order/pages/order_details.dart';
import 'package:dexter_vendor/widget/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingOrderScreen extends StatefulWidget {
  const PendingOrderScreen({Key? key}) : super(key: key);

  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {
  final _controller = Get.find<OrderController>();


  @override
  void initState() {
    _controller.getPendingOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      init: OrderController(),
        builder: (controller){
      return _controller.pendingOrderResponseModel == null || _controller.pendingOrderResponseModel!.isEmpty && _controller.getPendingOrderLoadingState == true && _controller.getPendingOrderErrorState == false ?
      CircularLoadingWidget() : _controller.pendingOrderResponseModel == null || _controller.pendingOrderResponseModel!.isEmpty && _controller.getPendingOrderLoadingState == false &&
          _controller.getPendingOrderErrorState == false ?
      Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetPath.emptyFile, height: 120, width: 120,),
            const SizedBox(height: 40,),
            Text("You have no pending orders",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: dustyGray, fontSize: 14, fontWeight: FontWeight.w400),),
          ],
        ),
      ) : _controller.pendingOrderResponseModel != null || _controller.pendingOrderResponseModel!.isNotEmpty && _controller.getPendingOrderLoadingState == false &&
          _controller.getPendingOrderErrorState == false ?
      Column(
        children: [
          const SizedBox(height: 10,),
          ...List.generate( _controller.pendingOrderResponseModel!.length, (index){
            final item = _controller.pendingOrderResponseModel![index];
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
                            ClipRRect(borderRadius: BorderRadius.circular(40),
                              child: Image.network(
                                item.user?.coverImage ?? imagePlaceHolder , height: 40, width: 40, fit: BoxFit.cover,),
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
      ) : CircularLoadingWidget();
    });
  }
}
