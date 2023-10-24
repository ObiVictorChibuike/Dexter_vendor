import 'dart:developer';

import 'package:clean_dialog/clean_dialog.dart';
import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_primary_button.dart';
import 'package:dexter_vendor/app/shared/widgets/dexter_text_field.dart';
import 'package:dexter_vendor/app/shared/widgets/error_screen.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/account/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/account/pages/add_bank_account.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dexter_vendor/widget/circular_loading_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class BankAccountsPage extends StatefulWidget {
  const BankAccountsPage({super.key});

  @override
  State<BankAccountsPage> createState() => _BankAccountsPageState();
}

class _BankAccountsPageState extends State<BankAccountsPage> {
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

  void showAddEditBankBottomSheet({required String bankAccountId}){
    Get.bottomSheet(Container(decoration: BoxDecoration(color: white,borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2,), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
      child: StatefulBuilder(builder: (context, update){
        return ListView(
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
            Text("Edit Account Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 18, fontWeight: FontWeight.w600),),
            const SizedBox(height: 8,),
            Align(alignment: Alignment.centerLeft, child: Text("Kindly confirm changes by clicking the button below",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),),
            ),
            const SizedBox(height: 20,),
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
                        Get.back();
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
                      hint: Text(bankNameController.text.isEmpty ? "Select Your Account" : bankNameController.text , style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 15)),
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
            const SizedBox(height: 35,),
            DexterPrimaryButton(
              buttonBorder: greenPea, btnHeight: 52, btnTitleSize: 14, borderRadius: 35,
              btnTitle: "Confirm", btnColor: greenPea, titleColor: white,
              btnWidth: MediaQuery.of(context).size.width,
              onTap: (){
                Get.back();
                _controller.updateBankAccount(bankCodeController.text, accountNumber.text, bankAccountId);
              },
            ),
          ],
        );
      }),
    ), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
    ),
      isScrollControlled: true,
    );
  }

  showDeleteAccountDialog({required BankController controller, required String accountId}){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: 'Delete Account',
        content: "Are you sure you want to delete this account?",
        backgroundColor: greenPea,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Yes',
              textColor: greenPea,
              onPressed: (){
                Navigator.pop(context);
                controller.deleteBankAccount(bankAccountId: accountId);
              }
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

  Widget slideLeftBackground() {
    return Container(
      color: persianRed,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
final _controller = Get.put(BankController());
  void loadAccount() async{
    await _controller.getAllBankAccount().then((value){
      setState(() {});
    });
  }
  @override
  void initState() {
    loadAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BankController>(
      init: BankController(),
        builder: (controller){
      return SafeArea(top: false, bottom: false,
          child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              centerTitle: false, elevation: 0, backgroundColor: white,
              actions: [
                controller.bankAccountResponse == null || controller.bankAccountResponse!.data!.isEmpty || controller.bankAccountResponse!.data == [] ?
                const SizedBox() :
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> AddBankAccountPage()));
                  },
                  child: Container(margin: EdgeInsets.only(right: 15, top: 15, bottom: 15),padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: greenPea, borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(Iconsax.add, size: 20, color: white,),
                          Text("Add Account", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: white, fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                  ),
                )
              ],
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
              title: Text("Bank Account", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),),
            body: controller.onLoadingBankAccountsState == true && controller.onLoadingBankAccountErrorState == false ?
                CircularLoadingWidget() : controller.onLoadingBankAccountsState == false && controller.onLoadingBankAccountErrorState == false && controller.bankAccountResponse!.data!.isEmpty ?
            Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AssetPath.emptyFile, height: 120, width: 120,),
                  const SizedBox(height: 40,),
                  Text("No bank account added",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: dustyGray, fontSize: 14, fontWeight: FontWeight.w400),),
                  const SizedBox(height: 40,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> AddBankAccountPage()));
                    },
                    child: Text("Click here to add",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea, fontSize: 14,
                          fontWeight: FontWeight.w400, decoration: TextDecoration.underline),),
                  ),
                ],
              ),
            ) : controller.onLoadingBankAccountsState == false && controller.onLoadingBankAccountErrorState == false && controller.bankAccountResponse!.data!.isNotEmpty ?
            AnimatedColumn(children: [
              const SizedBox(height: 24,),
              ...List.generate(controller.bankAccountResponse!.data!.length, (index) =>
                  Dismissible(
                    direction: DismissDirection.endToStart,
                    background: const SizedBox(),
                    secondaryBackground: slideLeftBackground(),
                    key: ValueKey<String>(controller.bankAccountResponse!.data![index].id.toString()),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        controller.bankAccountResponse!.data!.removeAt(index);
                      });
                    },
                    confirmDismiss: (DismissDirection direction) async {
                      if (direction == DismissDirection.endToStart) {
                        return await showDeleteAccountDialog(controller: controller, accountId: controller.bankAccountResponse!.data![index].id.toString());
                      } else {
                        return null;
                      }
                    },
                    child: Column(
                      children: [
                        Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              Icon(Icons.account_balance, color: greenPea,),
                              const SizedBox(width: 15,),
                              Expanded(
                                child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(controller.bankAccountResponse?.data?[index].accountName ?? "", overflow: TextOverflow.ellipsis, maxLines: 1, style:
                                    Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w800),),
                                    const SizedBox(height: 6,),
                                    Text(controller.bankAccountResponse?.data?[index].bankName ?? "", style:
                                    Theme.of(context).textTheme.bodySmall?.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w400),),
                                  ],
                                ),
                              ),
                              Column(crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      accountNumber.text = controller.bankAccountResponse!.data![index].accountNumber!;
                                      bankNameController.text = controller.bankAccountResponse!.data![index].bankName!;
                                      final i = controller.bankResponse?.data?.indexWhere((element) => element.name.toString() == bankNameController.text);
                                      bankNameController.text = controller.bankResponse!.data![i!].name!.toString();
                                      bankCodeController.text = controller.bankResponse!.data![i].code!.toString();
                                      setState(() {});
                                      showAddEditBankBottomSheet(bankAccountId: controller.bankAccountResponse!.data![index].id!.toString());
                                    }, child: Icon(Icons.save_as_outlined, color: greenPea, size: 15,)),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Container(
                                        height: 8, width: 8,
                                        decoration: BoxDecoration(color: greenPea, shape: BoxShape.circle),
                                      ),
                                      const SizedBox(width: 2,),
                                      Text(controller.bankAccountResponse?.data?[index].accountNumber ?? "", style:
                                      Theme.of(context).textTheme.bodySmall?.copyWith(color: greenPea, fontSize: 13, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),),
                        const Divider()
                      ],
                    ),
                  )),
            ], padding: EdgeInsets.symmetric(horizontal: 20)) :
            controller.onLoadingBankAccountsState == false && controller.onLoadingBankAccountErrorState == true && controller.bankAccountResponse!.data!.isEmpty ?
            ErrorScreen() : CircularLoadingWidget(),
          ));
    });
  }
}
