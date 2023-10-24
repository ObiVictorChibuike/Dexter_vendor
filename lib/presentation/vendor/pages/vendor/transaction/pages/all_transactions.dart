import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/custom_date.dart';
import 'package:dexter_vendor/app/shared/widgets/error_screen.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/transaction/controller/controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dexter_vendor/widget/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTransaction extends StatefulWidget {
  const AllTransaction({Key? key}) : super(key: key);

  @override
  State<AllTransaction> createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction> {



  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionController>(
      init: TransactionController(),
        builder: (controller){
      return SafeArea(top: false, bottom: false,
          child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              centerTitle: false, elevation: 0, backgroundColor: white,
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
              title: Text("Transactions", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),),
            body: controller.isLoadingTransactionHistory == true && controller.isLoadingTransactionHistoryHasError == false ? CircularLoadingWidget() :
                controller.isLoadingTransactionHistory == false && controller.isLoadingTransactionHistoryHasError == false &&
                controller.transactionHistoryResponseModel == null || controller.transactionHistoryResponseModel!.isEmpty ||
                controller.transactionHistoryResponseModel == [] ?
                Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/png/man_holding_money.png", height: 200, width: 200,),
                      Text("Nothing to see here!",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),),
                      const SizedBox(height: 10,),
                      Text("You have no transactions yet", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.w400),)
                    ],
                  ),
                ) :  controller.isLoadingTransactionHistory == false && controller.isLoadingTransactionHistoryHasError == false &&
                    controller.transactionHistoryResponseModel != null || controller.transactionHistoryResponseModel!.isNotEmpty ||
                    controller.transactionHistoryResponseModel != [] ?
                AnimatedColumn(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    const SizedBox(height: 16),
                    ...List.generate(controller.transactionHistoryResponseModel!.length, (index){
                          final item = controller.transactionHistoryResponseModel?[index];
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    item?.type == "debit" ?
                                    Container(height: 45, width: 45, decoration: BoxDecoration(color: persianRed.withOpacity(0.3), shape: BoxShape.circle),
                                        child: Center(child: Image.asset("assets/png/money-bag-red.png",height: 30, width: 30))
                                    ) : Container(height: 45, width: 45, decoration: BoxDecoration(color: greenPea.withOpacity(0.3), shape: BoxShape.circle),
                                        child: Center(child: Image.asset("assets/png/money-bag-green.png",height: 30, width: 30))
                                    ) ,
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(item?.description ?? "", maxLines: 3, overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: black)),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text("Status: ", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: black)),
                                              Text(item?.status ?? "", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color:
                                              item?.status == "pending" ? tulipTree : item?.status == "failed" ? persianRed : item?.status == "completed"? greenPea : black)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text( item?.type == "debit" ? "-N${item?.amount ?? "0.00"}" : "+N${item?.amount ?? "0.00"}",
                                            style: Theme.of(context).textTheme.bodySmall!.
                                            copyWith(fontSize: 12, fontWeight: FontWeight.w700, color:
                                            item?.type == "debit" ? persianRed : greenPea
                                            )),
                                        const SizedBox(height: 4),
                                        Text(CustomDate.slash(
                                          item?.createdAt?.toString() ??
                                            DateTime.now().toString()),
                                            style: Theme.of(context).textTheme.bodySmall!.
                                            copyWith(fontSize: 10, fontWeight: FontWeight.w700, color: dustyGray)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider()
                            ],
                          );
                        })
                  ],
                )
                  :  controller.isLoadingTransactionHistory == false && controller.isLoadingTransactionHistoryHasError == true ?
            ErrorScreen() : CircularLoadingWidget(),
          )
      );
    });
  }

  final _controller = Get.put(TransactionController());
  @override
  void initState() {
    _controller.getTransactionsHistory();
    super.initState();
  }
}
