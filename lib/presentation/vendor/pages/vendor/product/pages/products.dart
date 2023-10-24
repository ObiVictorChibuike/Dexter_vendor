import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/app/shared/widgets/empty_screen.dart';
import 'package:dexter_vendor/app/shared/widgets/error_screen.dart';
import 'package:dexter_vendor/core/state/view_state.dart';
import 'package:dexter_vendor/presentation/auth/create_account/pages/add_product.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/pages/edit_shop.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/pages/product_details.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor_overview/vendor_overview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final _scrollController = ScrollController();
  final _ctrl = Get.put(ProductController());
  final _homeController = Get.put(HomeController());

  @override
  void initState() {
    _ctrl.getAllProductOfShop();
    super.initState();
  }


  Widget buildProduct(ProductController controller){
    switch (controller.viewState.state){
      case ResponseState.LOADING:
        return Center(child: CupertinoActivityIndicator());
      case ResponseState.ERROR:
        return const ErrorScreen();
      case ResponseState.EMPTY:
        return const EmptyScreen();
      case ResponseState.COMPLETE:
        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
                height: MediaQuery.of(context).size.height / 4, width: double.maxFinite,
                decoration: BoxDecoration(
                    image: DecorationImage(image:
                    NetworkImage(_homeController.vendorShopResponse?.data?.coverImage ?? imagePlaceHolder),
                        fit: BoxFit.cover))
            ),
            Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 5,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_homeController.vendorShopResponse?.data?.name ?? "", overflow: TextOverflow.fade,
                          style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16,color: black, fontWeight: FontWeight.w600,),),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, color: greenPea, size: 15,),
                            Text("Open from ${_homeController.vendorShopResponse?.data?.openingTime ?? ""} - ${_homeController.vendorShopResponse?.data?.closingTime ?? ""}", overflow: TextOverflow.fade,
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 11,color: black, fontWeight: FontWeight.w700,),),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: greenPea, size: 20,),
                            Text("Location: ", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea, fontSize: 12, fontWeight: FontWeight.w600),),
                            const SizedBox(width: 5,),
                            Text("${_homeController.vendorShopResponse?.data?.contactAddress?.fullAddress ?? ""}",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea, fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // const SizedBox(height: 5,),
                    // Row(
                    //   children: [
                        // Container(
                        //   padding: EdgeInsets.all(8),
                        //   decoration: BoxDecoration(color: Color(0xffD9F2EA),
                        //       borderRadius: BorderRadius.circular(100)),
                        //   child: Text("Jobs completed: 0",
                        //     style: Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea, fontSize: 12, fontWeight: FontWeight.w600),
                        //   ),),
                        // const SizedBox(width: 8,),
                        // Container(
                        //   padding: EdgeInsets.all(8),
                        //   decoration: BoxDecoration(color: tulipTree.withOpacity(0.3),
                        //       borderRadius: BorderRadius.circular(100)),
                        //   child: Text("Seller rating: ${1.0}",
                        //     style: Theme.of(context).textTheme.bodySmall!.copyWith(color: tulipTree, fontSize: 12, fontWeight: FontWeight.w600),
                        //   ),),
                    //   ],
                    // ),
                    const SizedBox(height: 15,),
                    Align(alignment: Alignment.centerLeft,
                      child: Text("Bio",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8,),
                    Text(_homeController.vendorShopResponse?.data?.biography ?? "",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 15,),
                    const Divider(color: greenPea,),
                    const SizedBox(height: 8,),
                    Align(alignment: Alignment.centerLeft,
                        child: Text("My Products", style: Theme.of(context).textTheme.bodySmall!.
                        copyWith(color: black, fontSize: 16, fontWeight: FontWeight.w600),)),
                    const SizedBox(height: 8,),
                    // const Divider(color: greenPea,),
                SizedBox(
              child: GridView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.55, crossAxisCount: 2, mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: controller.viewState.data!.data!.length ,
                itemBuilder: (_,index){
                  return GestureDetector(
                    onTap: (){
                      Get.to(()=> ProductDetails(products: controller.viewState.data!.data![index],));
                    },
                    child: Card(elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                        // height: MediaQuery.of(context).size.height * .43,
                        width: MediaQuery.of(context).size.width * .42,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 130, width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: controller.viewState.data?.data![index].image == null || controller.viewState.data?.data![index].image == "" ?
                                        const NetworkImage(imagePlaceHolder) :
                                        NetworkImage(controller.viewState.data!.data![index].image!),fit: BoxFit.cover,)),
                                ),
                              ),
                              const SizedBox(height: 8,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(controller.viewState.data!.data![index].name.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2,),
                              RatingBar.builder(
                                glowColor:  const Color(0xffF2994A),
                                itemSize: 10,
                                initialRating: 5.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star, size: 12,
                                  color: Color(0xffF2994A),
                                ),
                                onRatingUpdate: (rating) {
                                  if (kDebugMode) {
                                    print(rating);
                                  }
                                },
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(controller.viewState.data!.data![index].description.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xff4F4F4F))),
                                  ),
                                ],
                              ),
                             Spacer(),
                              const Divider(),
                              const SizedBox(height: 5,),
                              Text('₦ ${MoneyFormatter(amount: double.parse(controller.viewState.data?.data?[index].price.toString() ?? "0.00"),).output.nonSymbol}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 5,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )),
            const SizedBox(height: 50,),
          ]);
    }
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      init: ProductController(),
        builder: (controller){
      return SafeArea(top: false, bottom: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              actions: [
                GestureDetector(
                  onTap: (){
                    Get.to(()=> EditShop());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.edit_note_sharp, color: greenPea, size: 25,),
                         // Text("Edit Shop", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline),),
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
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text("Shop Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: (){
                Get.to(()=> AddProducts(isFromProductScreen: true,));
              },
              label: Text('Add item'),
              icon: Icon(Icons.add),
            ),
            body: buildProduct(controller),
          )
      );
    });
  }
}
