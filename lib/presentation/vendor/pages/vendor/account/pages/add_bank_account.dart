import 'dart:developer';

import 'package:clean_dialog/clean_dialog.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/account/controller/controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddBankAccountPage extends StatefulWidget {
  const AddBankAccountPage({super.key});

  @override
  State<AddBankAccountPage> createState() => _AddBankAccountPageState();
}

class _AddBankAccountPageState extends State<AddBankAccountPage> {
  final accountNumber = TextEditingController();
  final bankNameController = TextEditingController();
  final bankCodeController = TextEditingController();
  final bankAccountIdController = TextEditingController();

  showBankListDialog({BankController? controller}){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: 'Error Alert',
        content: "Bank List is empty. Kindly check your network or refresh List",
        backgroundColor: greenPea,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Refresh Bank List',
              textColor: greenPea,
              onPressed: (){
                Navigator.pop(context);
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
            title: Text("Add Bank Account", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),),
          body: Form(
            key: formKey,
            child: AnimatedColumn(padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 24,),
              Text('Account Number',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400, fontSize: 14, color: black),
              ),
              const SizedBox(
                height: 8,
              ),
              DexterTextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
                controller: accountNumber,
                minLines: null, maxLines: 1, expands: false,
                hintText: "Enter Account Amount",
                validator: (value){
                  if(value!.isEmpty){
                    return "Please enter account number to proceed";
                  }
                  return null;
                },
                // validator: isRequired,
              ),
            const SizedBox(height: 16,),
            Text('Bank Name',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w400, fontSize: 14, color: black),
            ),
            const SizedBox(
              height: 8,
            ),
            GetBuilder<BankController>(
                init: BankController(),
                builder: (controller){
                  return GestureDetector(
                    onTap: (){
                      if(controller.bankResponse!.data!.isEmpty || controller.bankResponse?.data == []){
                        showBankListDialog(controller: controller);
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
                      hint: Text("Select Your Account", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Color(0xff868484), fontSize: 15)),
                      items: controller.bankResponse?.data?.map((item) => DropdownMenuItem<String>(
                        value: item.id.toString(),
                        child: Text(item.name ?? "", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 15)),
                      )).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select bank to proceed';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        bankAccountIdController.text = value.toString();
                        log(value.toString());
                        final index = controller.bankResponse?.data?.indexWhere((element) => element.id.toString() == value.toString());
                        bankNameController.text = controller.bankResponse!.data![index!].name!.toString();
                        bankCodeController.text = controller.bankResponse!.data![index].code!.toString();
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
        //     const SizedBox(height: 16,),
        //     Row(
        //         children: [
        //           Expanded(flex: 3,
        //             child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
        //               children: [
        //                 Text('Bank',
        //                   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //                       fontWeight: FontWeight.w400, fontSize: 14, color: black),
        //                 ),
        //                 const SizedBox(
        //                   height: 8,
        //                 ),
        //                 DexterTextField(
        //                   style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14),
        //                   minLines: null, maxLines: 1, expands: false, readOnly: true,
        //                   hintText: "Bank Name", controller: bankNameController,
        //                 ),
        //                 // const SizedBox(
        //                 //   height: 5,
        //                 // ),
        //                 // RichText(text: TextSpan(text: 'Selected Bank Account', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //                 //     fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
        //                 // )),
        //               ],
        //             ),
        //           ),
        //           const SizedBox(width: 15),
        //           Expanded(flex: 3,
        //             child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
        //               children: [
        //                 Text('Bank code',
        //                   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //                       fontWeight: FontWeight.w400, fontSize: 14, color: black),
        //                 ),
        //                 const SizedBox(
        //                   height: 8,
        //                 ),
        //                 DexterTextField(
        //                   style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14),
        //                   minLines: null, maxLines: 1, expands: false, readOnly: true,
        //                   hintText: "Code",controller: bankCodeController,
        //                 ),
        //                 // const SizedBox(
        //                 //   height: 5,
        //                 // ),
        //                 // RichText(text: TextSpan(text: 'Your Bank Code', style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //                 //     fontWeight: FontWeight.w400, fontSize: 8, color: Colors.grey)
        //                 // )),
        //               ],
        //             ),
        //           ),
        //     ],
        // ),
              const SizedBox(height: 100,),
              GetBuilder<BankController>(
                  init: BankController(),
                  builder: (controller){
                    return  DexterPrimaryButton(
                      onTap: () async {
                        if(controller.bankAccountResponse != null && controller.bankAccountResponse!.data!.isNotEmpty && controller.bankAccountResponse!.data!.length > 1){
                          Get.snackbar("Error", "You have reached your limit", backgroundColor: persianRed, colorText: white);
                        }else{
                          if(formKey.currentState!.validate()){
                            controller.addBankAccount(bankCodeController.text, accountNumber.text);
                          }
                        }
                      },
                      buttonBorder: greenPea, btnTitle: "Add Account",
                      borderRadius: 30, titleColor: white, btnHeight: 56, btnTitleSize: 16,
                    );
                  })]),
          ))
    );
  }
}
