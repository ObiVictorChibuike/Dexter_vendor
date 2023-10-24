import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/account/pages/bank_account_page.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/sale_record.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/transaction/pages/all_transactions.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/withdraw/pages/withdraw_fund.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final dexterSettings = [
    {
      "assets": AssetPath.transaction,
      "title": "Transactions"
    },
    {
      "assets": AssetPath.withdrawFund,
      "title": "Withdraw Funds"
    },
    {
      "assets": AssetPath.bankAccount,
      "title": "Bank Accounts"
    },
    {
      "assets": AssetPath.sales,
      "title": "Sales"
    },
  ];

  void underConstruction(BuildContext context) async {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // Some text
                  Center(child: Text('Still Under Context'))
                ],
              ),
            ),
          );
        }
    );
  }
  
  void route({required int index, required BuildContext context}){
    if(index == 0){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> AllTransaction()));
    }else if(index == 1){
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> WithdrawFunds()));
      // underConstruction(context);
    }else if(index == 2){
      // underConstruction(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> BankAccountsPage()));
    }else if(index == 3){
      underConstruction(context);
      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> SalesRecord()));
    }
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text("Accounts", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
          ),
          body: AnimatedColumn(children: [
            const SizedBox(height: 20,),
            ...List.generate(dexterSettings.length, (index) => GestureDetector(
              onTap: ()=> route(index: index, context: context),
              child: Container(height: 65, color: Colors.white,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Image.asset(dexterSettings[index]["assets"]!, height: 35, width: 35,),
                        const SizedBox(width: 16,),
                        Text(dexterSettings[index]["title"]!, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: thunder, fontSize: 14),),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios_outlined, color: black, size: 16,)
                    ],
                 ),
              ),
            ),),
          ], padding: EdgeInsets.symmetric(horizontal: 20)
          ),
        )
    );
  }
}
