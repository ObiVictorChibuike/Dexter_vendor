import 'package:clean_dialog/clean_dialog.dart';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/custom_date.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/Booking/controller/booking_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/business/controller/controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dexter_vendor/widget/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetails extends StatefulWidget {
  final String bookingId;
  const BookingDetails({super.key, required this.bookingId});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  final _controller = Get.put(BookingController());
  final _businessController = Get.put(BusinessController());
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    _controller.getBookingDetails(bookingId: widget.bookingId);
    super.initState();
  }

  late DateTime _selectedDate = DateTime.now();
  final dateController = TextEditingController();
  final serviceProviderType = TextEditingController();
  final serviceProvider = TextEditingController();
  final chargeAmount = TextEditingController();
  String? dateTimeString;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
      helpText: 'SCHEDULE APPOINTMENT DATE',
      confirmText: 'SELECT',
    );
    if (picked != null ) {
      setState(() {
        _selectedDate = picked;
        dateController.text = getDate(_selectedDate.toString());
      });
    }
  }
  final formKey = GlobalKey <FormState>();
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

  void showConfirmAppointmentBottomSheet({required BookingController controller}){
    dateController.text = getDate(controller.bookingDetailsResponse?.data?.scheduledDate?.toString() ?? DateTime.now().toString());
    chargeAmount.text = controller.bookingDetailsResponse?.data?.subtotalAmount ?? "";
    Get.bottomSheet(Container(decoration: BoxDecoration(color: white,borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2.2,), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            const SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 30, width: 30, decoration: BoxDecoration(shape: BoxShape.circle, color: iron),
                    child: Center(
                      child: Icon(
                        Icons.clear, color: black,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Text("Confirm appointment", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 18, fontWeight: FontWeight.w600),),
            const SizedBox(height: 38,),
            // Align(alignment: Alignment.centerLeft, child:
            // Text("Kindly confirm your appointment by providing your charge amount and time of availability. Please kindly note that this would be sent to the customer",
            //   style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),),
            // ),
            // const SizedBox(height: 20,),
            Text('Charge Amount',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400, fontSize: 14, color: black),
            ),
            const SizedBox(
              height: 8,
            ),
            DexterTextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: chargeAmount,
              keyboardType: TextInputType.phone,
              minLines: null, maxLines: 1, expands: false,
              hintText: "Enter Charge Amount",
              validator: (value){
                if(value!.isEmpty){
                  return "Please enter charge amount";
                }
                return null;
              },
            ),
            const SizedBox(height: 16,),
            Text('Scheduled Date',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400, fontSize: 14, color: black),
            ),
            const SizedBox(
              height: 8,
            ),
            DexterTextField(
              onTap: ()=>_selectDate(context),
              controller: dateController,
              readOnly: true,
              minLines: null, maxLines: 1, expands: false,
              hintText: "Enter Appointment Date",
              validator: (value){
                if(value!.isEmpty){
                  return "Please select appointment date";
                }
                return null;
              },
              // validator: isRequired,
            ),
            const SizedBox(height: 35,),
            DexterPrimaryButton(
              buttonBorder: greenPea, btnHeight: 52, btnTitleSize: 14, borderRadius: 35,
              btnTitle: "Confirm", btnColor: greenPea, titleColor: white,
              btnWidth: MediaQuery.of(context).size.width,
              onTap: (){
                if(formKey.currentState!.validate()){
                  Get.back();
                  controller.confirmBooking(amount: chargeAmount.text, date: dateTimeString.toString(), bookingId: widget.bookingId).then((value){
                    if(value?.statusCode == 200 || value?.statusCode == 201){
                      Get.back();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog.fullscreen(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28.0),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(AssetPath.success, height: 200, width: 200,),
                                    const SizedBox(height: 10),
                                    Text('Success!', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 22, fontWeight: FontWeight.bold),),
                                    const SizedBox(height: 15),
                                    RichText(textAlign: TextAlign.center, text: TextSpan(text: "Your appointment has confirmed to be on the ",
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 12, fontWeight: FontWeight.w400,), children: [
                                          TextSpan(text: "${dateController.text}", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.bold,),),
                                          TextSpan(text: " with ", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 12, fontWeight: FontWeight.w400,),),
                                          TextSpan(text: "${controller.bookingDetailsResponse?.data?.user?.firstName ?? ""} ${controller.bookingDetailsResponse?.data?.user?.lastName ?? ""}.",
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.bold,),),
                                          TextSpan(text: " Please ensure to update the appointment status when it is completed. Thank you for choosing dexter",
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 12, fontWeight: FontWeight.w400,),)
                                        ])),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        homeController.moveToBooking();
                                      },
                                      child: Text('Close', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 18, fontWeight: FontWeight.bold),),
                                    ),
                                    //
                                    // const SizedBox(height: 50,),
                                    // DexterPrimaryButton(
                                    //   onTap: (){
                                    //     Navigator.pop(context);
                                    //     Get.to(()=> BookingDetails(bookingId: value!.data["data"]["id"].toString()));
                                    //   },
                                    //   buttonBorder: greenPea, btnTitle: "View Details",
                                    //   borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    }
                  });
                }
              },
            ),
          ],
        ),
      )
    ), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
    ),
      isScrollControlled: true,
    );
  }

  getDate(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(date);
    dateTimeString = inputFormat.parse(date).toString();
    var outputFormat = DateFormat('dd/MM/yyyy');
    return outputFormat.format(inputDate);
  }
  String greeting({required DateTime date}) {
    var hour = date.hour;
    if (hour < 12) {
      return 'Morning';
    }if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(
      init: BookingController(),
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
              title: Text("Appointment Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
            ),
            body: Builder(builder: (context){
              if(controller.bookingDetailsResponse == null && controller.getBookingDetailsLoadingState == true && controller.getBookingDetailsErrorState == false){
                return CircularLoadingWidget();
              }else if(controller.bookingDetailsResponse == null && controller.getBookingDetailsLoadingState == false && controller.getBookingDetailsErrorState == false ){
                return Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(AssetPath.emptyFile, height: 120, width: 120,),
                      const SizedBox(height: 40,),
                      Text("Booking details not available",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: dustyGray, fontSize: 14, fontWeight: FontWeight.w400),),
                    ],
                  ),
                );
              } else if(controller.bookingDetailsResponse != null && controller.getBookingDetailsLoadingState == false && controller.getBookingDetailsErrorState == false){
                return  AnimatedColumn(children: [
                  const SizedBox(height: 10,),
                  Text("Location",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: dustyGray, fontWeight: FontWeight.w500, fontSize: 13),),
                  const SizedBox(height: 6,),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12), border: Border.all(color: greenPea)),
                    child: Center(
                      child:  Row(
                        children: [
                          Icon(Icons.location_on, color: greenPea,),
                          Expanded(
                            child: Text(controller.bookingDetailsResponse?.data?.address?.fullAddress ?? "", overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontWeight: FontWeight.w500, fontSize: 13),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12), border: Border.all(color: greenPea)),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Time/Date",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontWeight: FontWeight.w500, fontSize: 13),),
                            Text(CustomDate.slash(controller.bookingDetailsResponse?.data?.scheduledDate.toString() ?? DateTime.now().toString())),
                          ],
                        ),
                        const Divider(),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Reference Number",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontWeight: FontWeight.w500, fontSize: 13),),
                            Text(controller.bookingDetailsResponse?.data?.reference ?? "",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontWeight: FontWeight.w600, fontSize: 13),),
                          ],
                        ),
                        const Divider(),
                        controller.bookingDetailsResponse?.data?.notes == null ? const SizedBox():
                        Align(alignment: Alignment.centerLeft,
                          child: Text("Message",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontWeight: FontWeight.w500, fontSize: 13),),
                        ),
                        controller.bookingDetailsResponse?.data?.notes == null ? const SizedBox(): const SizedBox(height: 10,),
                        controller.bookingDetailsResponse?.data?.notes == null ? const SizedBox():
                        Align(alignment: Alignment.centerLeft,
                          child: Text(controller.bookingDetailsResponse?.data?.notes ?? "", textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 13, fontWeight: FontWeight.w400),),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Text("Vendor Details",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontWeight: FontWeight.w500, fontSize: 13),),
                  const SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12), border: Border.all(color: greenPea)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(borderRadius: BorderRadius.circular(50),
                              child: Container(height: 50, width: 50, decoration: BoxDecoration(shape: BoxShape.circle),
                                  child: Image.network(controller.bookingDetailsResponse?.data?.user?.coverImage ?? imagePlaceHolder, fit: BoxFit.cover,)
                              ),
                            ),
                            const SizedBox(width: 15,),
                            Expanded(child:
                            Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${controller.bookingDetailsResponse?.data?.user?.firstName ?? ""} ${controller.bookingDetailsResponse?.data?.user?.lastName ?? ""}",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontWeight: FontWeight.w600, fontSize: 16),),
                                    const SizedBox(height: 5,),
                                    Text("₦ ${MoneyFormatter(amount: double.parse(controller.bookingDetailsResponse?.data?.subtotalAmount ?? "0.00"),).output.nonSymbol}",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontWeight: FontWeight.w400, fontSize: 14),),
                                    const SizedBox(height: 5,),
                                    Text("N:B: This fee is exclusive \nof items or parts that \nneed to be bought.",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontWeight: FontWeight.w400, fontSize: 12),)
                                  ],
                                ),
                              ],
                            )),
                            Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 10, width: 10, decoration: BoxDecoration(color:
                                controller.bookingDetailsResponse?.data?.status == "pending" ? black :
                                controller.bookingDetailsResponse?.data?.status == "completed" ? greenPea :
                                controller.bookingDetailsResponse?.data?.status == "confirmed" ? tulipTree :
                                controller.bookingDetailsResponse?.data?.status == "cancelled" ? persianRed :
                                controller.bookingDetailsResponse?.data?.status == "fulfilled" ? Colors.deepOrangeAccent : Colors.transparent,
                                    shape: BoxShape.circle),
                                ),
                                Text(controller.bookingDetailsResponse?.data?.status == "pending" ? "Pending" :
                                controller.bookingDetailsResponse?.data?.status == "confirmed" ? "Confirmed" :
                                controller.bookingDetailsResponse?.data?.status == "completed" ? "Completed" :
                                controller.bookingDetailsResponse?.data?.status == "cancelled" ? "Cancelled" :
                                controller.bookingDetailsResponse?.data?.status == "fulfilled" ? "Fulfilled" : "",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontWeight: FontWeight.w400, fontSize: 14),),
                              ],
                            )
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 10,),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Service Price",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontWeight: FontWeight.w500, fontSize: 13),),
                            Text("NGN ${MoneyFormatter(
                              amount: double.parse(controller.bookingDetailsResponse?.data?.subtotalAmount ?? "0.00"),).output.nonSymbol}",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontWeight: FontWeight.w600, fontSize: 13),),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        controller.bookingDetailsResponse?.data?.notes == null ? const SizedBox() :
                        Align(alignment: Alignment.centerLeft,
                          child: Text(controller.bookingDetailsResponse?.data?.notes ?? "", textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: dustyGray, fontSize: 13, fontWeight: FontWeight.w400),),
                        ),
                      ],
                    ),
                  ),
                  controller.bookingDetailsResponse!.data!.bookingImages != [] && controller.bookingDetailsResponse!.data!.bookingImages!.isNotEmpty ?
                  const SizedBox(height: 29,) : const SizedBox.shrink(),
                  controller.bookingDetailsResponse!.data!.bookingImages != [] && controller.bookingDetailsResponse!.data!.bookingImages!.isNotEmpty ? Wrap(alignment: WrapAlignment.spaceAround,
                      children: List.generate(controller.bookingDetailsResponse!.data!.bookingImages!.length, (index){
                        final data = controller.bookingDetailsResponse!.data!.bookingImages;
                        return Card(
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                            height: 100, width:80,
                            child: Image.network(data![index]),
                          ),
                        );
                      })
                  ) : const SizedBox.shrink(),
                  const SizedBox(height: 50,),
                  controller.bookingDetailsResponse?.data?.status == "pending" ?
                  DexterPrimaryButton(
                    onTap: (){
                      showMarkDialog(onPressed: (){
                        Get.back();
                        controller.confirmBooking(amount: controller.bookingDetailsResponse!.data!.totalAmount!.toString(), date: controller.bookingDetailsResponse!.data!.scheduledDate!.toString(), bookingId: widget.bookingId).then((value){
                          if(value?.statusCode == 200 || value?.statusCode == 201){
                            Get.back();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                context: context,
                                builder: (_) => Dialog.fullscreen(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(AssetPath.success, height: 200, width: 200,),
                                          const SizedBox(height: 10),
                                          Text('Success!', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 22, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 15),
                                          RichText(textAlign: TextAlign.center, text: TextSpan(text: "Your appointment has confirmed to be on the ",
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 12, fontWeight: FontWeight.w400,), children: [
                                                TextSpan(text: "${dateController.text}", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.bold,),),
                                                TextSpan(text: " with ", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 12, fontWeight: FontWeight.w400,),),
                                                TextSpan(text: "${controller.bookingDetailsResponse?.data?.user?.firstName ?? ""} ${controller.bookingDetailsResponse?.data?.user?.lastName ?? ""}.",
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.bold,),),
                                                TextSpan(text: " Please ensure to update the appointment status when it is completed. Thank you for choosing dexter",
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 12, fontWeight: FontWeight.w400,),)
                                              ])),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              homeController.moveToBooking();
                                            },
                                            child: Text('Close', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 18, fontWeight: FontWeight.bold),),
                                          ),
                                          //
                                          // const SizedBox(height: 50,),
                                          // DexterPrimaryButton(
                                          //   onTap: (){
                                          //     Navigator.pop(context);
                                          //     Get.to(()=> BookingDetails(bookingId: value!.data["data"]["id"].toString()));
                                          //   },
                                          //   buttonBorder: greenPea, btnTitle: "View Details",
                                          //   borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                          }
                        });
                      }, title: "Mark as confirmed?", content: "Are you sure you want to mark this booking as confirmed?");
                      // showConfirmAppointmentBottomSheet(controller: controller);
                    },
                    buttonBorder: greenPea, btnTitle: "Confirm Booking",
                    borderRadius: 30, titleColor: white, btnHeight: 53, btnTitleSize: 16,
                  ) : controller.bookingDetailsResponse?.data?.status == "confirmed" ?
                  DexterPrimaryButton(
                    onTap: (){
                      showMarkDialog(onPressed: (){
                        Get.back();
                        controller.markBookingAsDelivered(bookingId: widget.bookingId).then((value){
                          if(value?.statusCode == 200 || value?.statusCode == 201){
                            Get.back();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog.fullscreen(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(AssetPath.success, height: 200, width: 200),
                                        const SizedBox(height: 10),
                                        Text('Success!', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 22, fontWeight: FontWeight.bold),),
                                        const SizedBox(height: 15),
                                        RichText(textAlign: TextAlign.center, text: TextSpan(text: "Your appointment with",
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w400,), children: [
                                              TextSpan(text: " ${controller.bookingDetailsResponse?.data?.user?.firstName ?? ""} ${controller.bookingDetailsResponse?.data?.user?.lastName ?? ""}.",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.bold,),),
                                              TextSpan(text: " has been confirmed and completed. Thank you choosing dexter",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w400,),)
                                            ])),
                                        TextButton(
                                          onPressed: () {
                                            homeController.moveToBooking();
                                          },
                                          child: Text('Close', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 18, fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          }
                        });
                      }, title: "Mark as Delivered", content: "Are you sure you want to make this order as delivered?");
                    },
                    buttonBorder: greenPea, btnTitle: "Mark as delivered",
                    borderRadius: 30, titleColor: white, btnHeight: 53, btnTitleSize: 16,
                  ) : const SizedBox(),
                  controller.bookingDetailsResponse?.data?.status == "pending" ? const SizedBox(height: 15,) : const SizedBox(),
                  controller.bookingDetailsResponse?.data?.status == "pending" ?
                  DexterPrimaryButton(
                    onTap: (){
                      showConfirmAppointmentBottomSheet(controller: controller);
                    },
                    buttonBorder: Color(0xffFCEFEF), btnTitle: "Reschedule", btnColor: Color(0xffFCEFEF),
                    borderRadius: 30, titleColor: Color(0xffCC2929), btnHeight: 56, btnTitleSize: 16,
                  ) : const SizedBox()
                ], padding: EdgeInsets.symmetric(horizontal: 20));
              }
              return CircularLoadingWidget();
            })
          )
      );
    });
  }
}
