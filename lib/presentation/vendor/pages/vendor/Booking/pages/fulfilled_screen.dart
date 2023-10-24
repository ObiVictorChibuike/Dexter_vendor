import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/custom_date.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Booking/controller/booking_controller.dart';
import 'package:dexter_vendor/widget/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'booking_details.dart';

class FulfilledBookingScreen extends StatefulWidget {
  const FulfilledBookingScreen({Key? key}) : super(key: key);

  @override
  State<FulfilledBookingScreen> createState() => _FulfilledBookingScreenState();
}

class _FulfilledBookingScreenState extends State<FulfilledBookingScreen> {
  final _controller = Get.find<BookingController>();
  @override
  void initState() {
    _controller.getFulfilledBookings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(
      init: BookingController(),
        builder: (controller){
      return Builder(builder: (context){
        if(_controller.fulfilledBookingsResponseModel == null || _controller.fulfilledBookingsResponseModel!.isEmpty && _controller.getFulfilledBookingsLoadingState == true && _controller.getFulfilledBookingsErrorState == false){
          return CircularLoadingWidget();
        }else if(_controller.fulfilledBookingsResponseModel == null || _controller.fulfilledBookingsResponseModel!.isEmpty && _controller.getFulfilledBookingsLoadingState == false && _controller.getFulfilledBookingsErrorState == false ){
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AssetPath.emptyFile, height: 120, width: 120,),
                const SizedBox(height: 40,),
                Text("You have no delivered bookings",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: dustyGray, fontSize: 14, fontWeight: FontWeight.w400),),
              ],
            ),
          );
        }else if(_controller.fulfilledBookingsResponseModel != null || _controller.fulfilledBookingsResponseModel!.isNotEmpty && _controller.getFulfilledBookingsLoadingState == false && _controller.getFulfilledBookingsErrorState == false){
          return Column(
            children: [
              const SizedBox(height: 10,),
              ...List.generate( _controller.fulfilledBookingsResponseModel!.length, (index){
                final item = _controller.fulfilledBookingsResponseModel![index];
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
                                      item.user?.coverImage ?? imagePlaceHolder , height: 40, width: 40, fit: BoxFit.cover,),
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
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.deepOrangeAccent, borderRadius: BorderRadius.circular(2)),
                              child: Text(item.status?.toLowerCase() == "fulfilled" ? "Delivered" : "",  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: white, fontSize: 10, fontWeight: FontWeight.w700),),
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
          );
        }
        return CircularLoadingWidget();
      });
    });
  }
}
