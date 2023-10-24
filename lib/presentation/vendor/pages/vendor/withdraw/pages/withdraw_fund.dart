
import 'dart:developer';
import 'package:clean_dialog/clean_dialog.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/account/pages/add_bank_account.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/withdraw/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor_overview/vendor_overview.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WithdrawFunds extends StatefulWidget {
  const WithdrawFunds({super.key});

  @override
  State<WithdrawFunds> createState() => _WithdrawFundsState();
}

class _WithdrawFundsState extends State<WithdrawFunds> {
  final bankAccountController = TextEditingController();
  final amountController = TextEditingController();
  final bankCodeController = TextEditingController();
  final bankAccountNumber = TextEditingController();
  final bankNameController = TextEditingController();
  int charges = 0;

  showBankDialog(){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: 'Empty Account Notice',
        content: "You have not added any account yet. kindly add an account to proceed",
        backgroundColor: greenPea,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Add Account',
              textColor: greenPea,
              onPressed: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> AddBankAccountPage()));
              }
          ),
          CleanDialogActionButtons(
              actionTitle: 'Cancel',
              textColor: persianRed,
              onPressed: (){
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }

  final formKey = GlobalKey <FormState>();
  final _controller = Get.find<WithdrawalController>();

  @override
  void initState() {
    _controller.getAllBankAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text("Withdraw Funds", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),),
          body: Form(
            key: formKey,
            child: AnimatedColumn(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 24,),
                Text('Enter an amount to withdraw',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 14, color: black),
                ),
                const SizedBox(
                  height: 8,
                ),
                DexterTextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.phone,
                  controller: amountController,
                  minLines: null, maxLines: 1, expands: false,
                  hintText: "Enter Withdrawal Amount", onChanged: (value){
                    if(value.isNotEmpty){
                      charges = int.parse(value) ;
                          //+ 25;
                      setState(() {});
                    }},
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please enter amount to proceed";
                    }
                    return null;
                  },
                  // validator: isRequired,
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                // Row(mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Container(
                //       height: 10, width: 10,
                //       decoration: BoxDecoration(color: greenPea, borderRadius: BorderRadius.circular(19)),
                //     ),
                //     const SizedBox(width: 8,),
                //     RichText(text: TextSpan(text: "N25 Service fee", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                //         fontWeight: FontWeight.w400, fontSize: 10, color: Colors.grey)
                //     )),
                //   ],
                // ),
                const SizedBox(height: 16,),
                Text('Select bank account for funds to be sent to',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400, fontSize: 14, color: black),
                ),
                const SizedBox(
                  height: 8,
                ),
                GetBuilder<WithdrawalController>(
                  init: WithdrawalController(),
                    builder: (controller){
                  return GestureDetector(
                    onTap: (){
                      if(controller.bankAccountResponse!.data!.isEmpty || controller.bankAccountResponse?.data == []){
                        showBankDialog();
                      }else{
                        log("List is empty");
                      }
                    },
                    child: DropdownButtonFormField2(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                        errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xff868484), width: 0.7)),
                      ),
                      isExpanded: true,
                      hint: Text("Select Bank Account", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color(0xff868484), fontSize: 15)),
                      items: controller.bankAccountResponse?.data?.map((item) => DropdownMenuItem<String>(
                        value: item.id.toString(),
                        child: Text(item.accountName ?? "", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 15)),
                      )).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select bank to proceed';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        bankAccountController.text = value.toString();
                        final index = controller.bankAccountResponse?.data?.indexWhere((element) => element.id.toString() == value.toString());
                        bankNameController.text = controller.bankAccountResponse!.data![index!].bankName!.toString();
                        bankCodeController.text = controller.bankAccountResponse!.data![index].bankCode!.toString();
                        bankAccountNumber.text = controller.bankAccountResponse!.data![index].accountNumber!.toString();
                        setState(() {});
                      },
                      buttonStyleData: ButtonStyleData(height: 48, padding: EdgeInsets.only(left: 0, right: 10),
                          decoration: BoxDecoration(color: Color(0xffEFEFF0), borderRadius: BorderRadius.circular(20), border: Border.all(color: Color(0xff868484), width: 0.7))),
                      iconStyleData: const IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: black, size: 18,), iconSize: 30,),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 5,
                ),
               GetBuilder<WithdrawalController>(
                 init: WithdrawalController(),
                   builder: (controller){
                 return  Row(mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Icon(Icons.account_balance_wallet_rounded, color: greenPea, size: 15,),
                     const SizedBox(width: 8,),
                     RichText(text: TextSpan(text: 'Wallet Balance', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                         fontWeight: FontWeight.w400, fontSize: 10, color: greenPea), children: [
                       TextSpan(text: " ${controller.homeController.vendorProfileResponse?.data?.availableBalance}",style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                           fontWeight: FontWeight.w400, fontSize: 10, color: Colors.grey))
                     ]
                     )),
                   ],
                 );
               }),
                // const SizedBox(height: 16,),
                // Text('Account number',
                //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                //       fontWeight: FontWeight.w400, fontSize: 14, color: black),
                // ),
                // const SizedBox(
                //   height: 8,
                // ),
                // DexterTextField(
                //   readOnly: true,
                //   keyboardType: TextInputType.number,
                //   minLines: null, maxLines: 1, expands: false,
                //   hintText: "Account Number",
                //   controller: bankAccountNumber,
                // ),
                // const SizedBox(
                //   height: 5,
                // ),
                // RichText(text: TextSpan(text: 'Please provide general average shipping cost across all location', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                //     fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                // )),
                // const SizedBox(height: 16,),
                // Row(
                //   children: [
                //     Expanded(flex: 3,
                //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           Text('Bank',
                //             style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                //                 fontWeight: FontWeight.w400, fontSize: 14, color: black),
                //           ),
                //           const SizedBox(
                //             height: 8,
                //           ),
                //           DexterTextField(
                //             style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14),
                //             minLines: null, maxLines: 1, expands: false, readOnly: true,
                //             hintText: "Bank Name", controller: bankNameController,
                //           ),
                //           // const SizedBox(
                //           //   height: 5,
                //           // ),
                //           // RichText(text: TextSpan(text: 'Selected Bank Account', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                //           //     fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                //           // )),
                //         ],
                //       ),
                //     ),
                //     const SizedBox(width: 15),
                //     Expanded(flex: 3,
                //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           Text('Bank code',
                //             style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                //                 fontWeight: FontWeight.w400, fontSize: 14, color: black),
                //           ),
                //           const SizedBox(
                //             height: 8,
                //           ),
                //           DexterTextField(
                //             style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14),
                //             minLines: null, maxLines: 1, expands: false, readOnly: true,
                //             hintText: "code",controller: bankCodeController,
                //           ),
                //           // const SizedBox(
                //           //   height: 5,
                //           // ),
                //           // RichText(text: TextSpan(text: 'Your Bank Code', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                //           //     fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
                //           // )),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 100,),
               GetBuilder<WithdrawalController>(
                 init: WithdrawalController(),
                   builder: (controller){
                 return  DexterPrimaryButton(
                   onTap: () async {
                     if(formKey.currentState!.validate()){
                       controller.withdrawFunds(amountController.text, bankAccountController.text).then((value){
                         if(value.status == "success"){
                           Get.back();
                           showDialog(
                             context: context,
                             builder: (BuildContext context) => Dialog.fullscreen(
                               child: Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                 child: Column(
                                   mainAxisSize: MainAxisSize.min,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: <Widget>[
                                     Lottie.asset("assets/lottie/success.json"),
                                     const SizedBox(height: 10),
                                     Text('Success!', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 22, fontWeight: FontWeight.bold),),
                                     const SizedBox(height: 15),
                                     RichText(textAlign: TextAlign.center, text: TextSpan(text: "Your withdrawal was successful. Kindly view wallet balance on the dashboard",
                                         style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w400,))),
                                     TextButton(
                                       onPressed: () {
                                         Navigator.pop(context);
                                         Get.offUntil( MaterialPageRoute(builder: (context) => VendorOverView()), (Route<dynamic> route) => false);
                                       },
                                       child: Text('Close', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 18, fontWeight: FontWeight.bold),),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                           );
                           // Get.snackbar("Success", value.message ?? "Withdrawal Successful", colorText: white, backgroundColor: greenPea);
                         }
                       });
                     }
                   },
                   buttonBorder: greenPea, btnTitle: "Withdraw N${amountController.text.isEmpty ? "0.00" : charges}",
                   borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
                 );
               })
              ],
            ),
          ),
        )
    );
  }
}