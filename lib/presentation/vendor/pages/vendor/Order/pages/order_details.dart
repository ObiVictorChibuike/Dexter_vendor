import 'package:clean_dialog/clean_dialog.dart';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/custom_date.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/error_screen.dart';
import 'package:dexter_vendor/data/location_data/get_location.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Booking/controller/booking_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Order/controller/order_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor_overview/vendor_overview.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dexter_vendor/widget/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:money_formatter/money_formatter.dart';

class OrderDetails extends StatefulWidget {
  final String orderId;
  const OrderDetails({super.key, required this.orderId});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final _controller = Get.put(OrderController());
  final bk = Get.lazyPut(()=>BookingController());
  GoogleMapController? _googleMapController;
  Marker? origin;
  double heightFactor = 0.3;
  addMarker(LatLng pos) {
    origin = Marker(markerId: const MarkerId("Origin"), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), position: pos);
  }

  double? longitude, latitude;

  Future<void> getLocation() async {
    final value = await GetLocation.instance!.checkLocation;
    longitude = value.longitude ?? 0.0;
    latitude = value.latitude ?? 0.00;
    addMarker(LatLng(value.latitude ?? 0.000, value.longitude ?? 0.00));
    setState(() {});
  }

  showMarkDialog({required void Function() onPressed, required String title, required String content}){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: title,
        content: content,
        backgroundColor: greenPea,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Yes',
              textColor: greenPea,
              onPressed: onPressed,
          ),
          CleanDialogActionButtons(
              actionTitle: 'No',
              textColor: persianRed,
              onPressed: (){
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    getLocation();
    _controller.getOrderDetails(orderId: widget.orderId);
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      init: OrderController(),
        builder: (controller){
          final _initialCameraPosition = CameraPosition(target: LatLng(latitude ?? 0.00, longitude ?? 0.00), zoom: 13);
      return SafeArea(top: false, bottom: false,
          child: Scaffold(backgroundColor: white,
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
              title: Text("Orders Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
            ),
            body: origin == null ? CircularLoadingWidget() :
            controller.getOrderDetailsLoadingState == true && controller.getOrderDetailsErrorState == false ?
                CircularLoadingWidget() : controller.getOrderDetailsLoadingState == false && controller.getOrderDetailsErrorState ==
                false && controller.orderDetailsResponse != null ?
            AnimatedColumn(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              children: [
                Text("Customer", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.w700),),
                const SizedBox(height: 5,),
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(40),
                        child: Image.network(controller.orderDetailsResponse?.data?.user?.coverImage ?? imagePlaceHolder, height: 40, width: 40, fit: BoxFit.cover,)),
                    const SizedBox(width: 10,),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${controller.orderDetailsResponse?.data?.user?.firstName} ${controller.orderDetailsResponse?.data?.user?.lastName}",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Color(0xff06161C), fontSize: 16, fontWeight: FontWeight.w600),),
                        Text(CustomDate.slash(controller.orderDetailsResponse?.data?.createdAt.toString() ?? DateTime.now().toString()),
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color(0xff8F92A1), fontSize: 12, fontWeight: FontWeight.w600),),
                        const SizedBox(height: 5,),
                        Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 10, width: 10, decoration: BoxDecoration(color:
                            controller.orderDetailsResponse?.data?.status == "pending" ? black :
                            controller.orderDetailsResponse?.data?.status == "confirmed" ? tulipTree :
                            controller.orderDetailsResponse?.data?.status == "confirmed" ? greenPea :
                            controller.orderDetailsResponse?.data?.status == "cancelled" ? persianRed :
                            controller.orderDetailsResponse?.data?.status == "fulfilled" ? Colors.deepOrangeAccent :
                            Colors.transparent,
                                shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 5,),
                            Text(controller.orderDetailsResponse?.data?.status == "pending" ? "Pending" :
                            controller.orderDetailsResponse?.data?.status == "confirmed" ? "Confirmed" :
                            controller.orderDetailsResponse?.data?.status == "completed" ? "Completed" :
                            controller.orderDetailsResponse?.data?.status == "cancelled" ? "Cancelled" :
                            controller.orderDetailsResponse?.data?.status == "fulfilled" ? "Delivered" :"",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontWeight: FontWeight.w400, fontSize: 14),),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Location", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w700),),
                    const SizedBox(width: 15,),
                    Expanded(flex: 4,
                      child: Text("${controller.orderDetailsResponse?.data?.address?.fullAddress ?? ""}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.w400),),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Container(
                  height: MediaQuery.of(context).size.height/3.5, width: double.infinity,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),),
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: true,
                    compassEnabled: false,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: _initialCameraPosition,
                    onMapCreated: (controller) => _googleMapController = controller,
                    markers: {
                      origin!,
                    },
                  ),
                ),
                const SizedBox(height: 15,),
                controller.orderDetailsResponse?.data?.notes == null ? const SizedBox() : Text("Message", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w400),),
                controller.orderDetailsResponse?.data?.notes == null ? const SizedBox() : const SizedBox(height: 5,),
                controller.orderDetailsResponse?.data?.notes  == null ? const SizedBox() : Text("${controller.orderDetailsResponse?.data?.notes ?? ""}",
                  textAlign: TextAlign.start,
                  maxLines: 5, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black,
                      fontSize: 14, fontWeight: FontWeight.w400),),
                const SizedBox(height: 15,),
                Text("Items", style: Theme.of(context).textTheme.bodySmall?.copyWith(color:
                Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w400),),
                const SizedBox(height: 5,),
                ...List.generate(controller.orderDetailsResponse!.data!.orderItems!.length, (index){
                  final data = controller.orderDetailsResponse!.data!.orderItems![index];
                  return  Container(
                    width: double.maxFinite, padding: EdgeInsets.all(10),
                    decoration: BoxDecoration( borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: dustyGray)),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(60),
                          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(60)), height: 40, width: 40,
                            child: Image.network(data.product?.image ?? imagePlaceHolder , height: 40, width: 40, fit: BoxFit.cover,),
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${ data.product?.name ?? ""}",
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14, fontWeight: FontWeight.w600),),
                              Text( data.product?.description ?? "", maxLines: 4,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color(0xff8F92A1), fontSize: 12, fontWeight: FontWeight.w600),),
                            ],
                          ),
                        ),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("NGN ${MoneyFormatter(amount: double.parse(data.product?.price ?? "0.00"),).output.nonSymbol}",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea, fontSize: 12, fontWeight: FontWeight.w700),),
                            Row(
                              children: [
                                Text("Quantity: ", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 13, fontWeight: FontWeight.w700),),
                                Text( data.quantity.toString() ?? "", maxLines: 4,
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color(0xff8F92A1), fontSize: 12, fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 15,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Order ID", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Color(0xff999999), fontSize: 13, fontWeight: FontWeight.w500),),
                    Text("#${controller.orderDetailsResponse?.data?.id}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 13, fontWeight: FontWeight.w400),),
                  ],
                ),
                const SizedBox(height: 6,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Order Reference", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Color(0xff999999), fontSize: 13, fontWeight: FontWeight.w500),),
                    Text("#${controller.orderDetailsResponse?.data?.reference}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 13, fontWeight: FontWeight.w400),),
                  ],
                ),
                const SizedBox(height: 6,),
                controller.orderDetailsResponse?.data?.paymentMethod == null ? const SizedBox() :
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Payment method", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Color(0xff999999), fontSize: 13, fontWeight: FontWeight.w500),),
                    Text("${controller.orderDetailsResponse?.data?.paymentMethod ?? ""}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 13, fontWeight: FontWeight.w400),),
                  ],
                ),
                const SizedBox(height: 6,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Amount", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Color(0xff999999), fontSize: 13, fontWeight: FontWeight.w500),),
                    Text("NGN ${MoneyFormatter(amount: double.parse(controller.orderDetailsResponse?.data?.totalAmount ?? "0.00"),).output.nonSymbol}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.w400),),
                  ],
                ),
                const SizedBox(height: 25,),
                controller.orderDetailsResponse?.data?.status == "pending" ?
                DexterPrimaryButton(
                  onTap: (){
                    showMarkDialog(onPressed: (){
                      Get.back();
                      controller.markOrderAsConfirmed(orderId: widget.orderId).then((value){
                        if(value?.statusCode == 200 || value?.statusCode == 201){
                          Get.back();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog.fullscreen(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(AssetPath.success, height: 200, width: 200,),
                                        const SizedBox(height: 10),
                                        Text('Success!', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 22, fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 15),
                                        RichText(textAlign: TextAlign.center, text: TextSpan(text: "Your order request with",
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w400,), children: [
                                              TextSpan(text: " ${controller.orderDetailsResponse?.data?.user?.firstName ?? ""} ${controller.orderDetailsResponse?.data?.user?.lastName ?? ""}.",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.bold,),),
                                              TextSpan(text: " has confirmed. Thank you choosing dexter",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w400,),)
                                            ])),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Get.offAll(()=> VendorOverView());
                                          },
                                          child: Text('Close', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 18, fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        }
                      });
                    }, title: "Mark as confirmed'", content: "Are you sure you want to make this order as confirmed?");
                  },
                  buttonBorder: greenPea, btnTitle: "Confirm Order",
                  borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
                ) : controller.orderDetailsResponse?.data?.status == "confirmed" ?
                DexterPrimaryButton(
                  onTap: (){
                    showMarkDialog(onPressed: (){
                      Get.back();
                      controller.markOrderAsFulfilled(orderId: widget.orderId).then((value){
                        if(value?.statusCode == 200 || value?.statusCode == 201){
                          Get.back();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog.fullscreen(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(AssetPath.success, height: 200, width: 200,),
                                        const SizedBox(height: 10),
                                        Text('Success!', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 22, fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 15),
                                        RichText(textAlign: TextAlign.center, text: TextSpan(text: "Your order request with",
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w400,), children: [
                                              TextSpan(text: " ${controller.orderDetailsResponse?.data?.user?.firstName ?? ""} ${controller.orderDetailsResponse?.data?.user?.lastName ?? ""}.",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.bold,),),
                                              TextSpan(text: " has confirmed and fulfilled. Thank you choosing dexter",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w400,),)
                                            ])),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Get.offAll(()=> VendorOverView());
                                          },
                                          child: Text('Close', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 18, fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        }
                      });
                    }, title: "Mark as fulfilled'", content: "Are you sure you want to make this order as fulfilled?");
                  },
                  buttonBorder: greenPea, btnTitle: "Mark as fulfilled",
                  borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
                ) : const SizedBox(),
                const SizedBox(height: 35,),
              ],
            )
                  : controller.getOrderDetailsLoadingState == false && controller.getOrderDetailsErrorState == true ?
            ErrorScreen() : const SizedBox(),
          )
      );
    });
  }
}
