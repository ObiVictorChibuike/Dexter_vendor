import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/custom_date.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Booking/pages/booking_details.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dexter_vendor/widget/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllPendingBookingPage extends StatefulWidget {
  const AllPendingBookingPage({super.key});

  @override
  State<AllPendingBookingPage> createState() => _AllPendingBookingPageState();
}

class _AllPendingBookingPageState extends State<AllPendingBookingPage> {

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
              title: Text("Pending Booking Requests", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
            ),
            body:  _controller.pendingBookingsResponseModel == null || _controller.pendingBookingsResponseModel!.isEmpty && _controller.getPendingBookingsLoadingState == true && _controller.getPendingBookingsErrorState == false ?
            Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(height: MediaQuery.of(context).size.height/6,),
                  CupertinoActivityIndicator(),
                  const SizedBox(height: 10,),
                  Text("Please wait...", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),)
                ],
              ),
            ) :
            controller.pendingBookingsResponseModel == null || controller.pendingBookingsResponseModel!.isEmpty || controller.pendingBookingsResponseModel == [] ?
            CircularLoadingWidget() : _controller.pendingBookingsResponseModel == null || _controller.pendingBookingsResponseModel!.isEmpty && _controller.getPendingBookingsLoadingState == false && _controller.getPendingBookingsErrorState == false ?
            Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AssetPath.emptyFile, height: 120, width: 120,),
                  const SizedBox(height: 40,),
                  Text("You have no pending bookings",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: dustyGray, fontSize: 14, fontWeight: FontWeight.w400),),
                ],
              ),
            ) : _controller.pendingBookingsResponseModel != null || _controller.pendingBookingsResponseModel!.isNotEmpty && _controller.getPendingBookingsLoadingState == false && _controller.getPendingBookingsErrorState == false ?
            AnimatedColumn(children: [
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
            ], padding: EdgeInsets.symmetric(horizontal: 20)) :
            Center(
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
    _controller.getPendingBookings();
    super.initState();
  }
}
