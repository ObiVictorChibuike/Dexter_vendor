import 'package:clean_dialog/clean_dialog.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/custom_date.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/core/state/view_state.dart';
import 'package:dexter_vendor/data/product_model/products_of_shop_model.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/product/controller/controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dexter_vendor/widget/circular_loading_widget.dart';
import 'package:dexter_vendor/widget/custom_snack.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'edit_product_details.dart';

class ProductDetails extends StatefulWidget {
  final Products products;

  const ProductDetails({Key? key, required this.products}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

final _controller = Get.find<ProductController>();
  oopsDialog(){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: 'Oops!',
        content: 'You cannot delete every product in your shop',
        backgroundColor: greenPea,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white,),
        actions: [
          CleanDialogActionButtons(
            actionTitle: 'Ok',
            textColor: greenPea,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  showAlertDialog(ProductController controller){
    showDialog(
      context: context,
      builder: (context) => CleanDialog(
        title: 'Do you Agree?',
        content: 'Are you sure you want to delete this product from your product catalog?',
        backgroundColor: greenPea,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,),
        contentTextStyle: const TextStyle(fontSize: 13, color: Colors.white,),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Accept',
              textColor: greenPea,
              onPressed: (){
                Navigator.pop(context);
                deleteProduct(controller);
              }
          ),
          CleanDialogActionButtons(
            actionTitle: 'Cancel',
            textColor: persianRed,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void deleteProduct(ProductController controller)async{
    await controller.onDeleteProduct(productId: widget.products.id!, context: context);
    if(controller.deleteProductViewState.state == ResponseState.COMPLETE){
      Get.back();
      Get.snackbar("Success", "Product deleted successfully", colorText: white, backgroundColor: greenPea);
    }else if(controller.deleteProductViewState.state == ResponseState.ERROR){
      Get.back();
      Get.snackbar("Something Went Wrong", controller.errorMessage ?? "Check your Internet connections", colorText: white, backgroundColor: persianRed);
    }
  }


  @override
  void initState() {
    _controller.getProductDetailsResponse(productId: widget.products.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      init: ProductController(),
        builder: (controller){
      return controller.productDetailsResponse == null && controller.productDetailsResponsesLoadingState == true && controller.productDetailsResponseErrorState == false ?
      CircularLoadingWidget() : controller.productDetailsResponse != null
          && controller.productDetailsResponsesLoadingState == false && controller.productDetailsResponseErrorState == false ?
        SafeArea(top: false, bottom: false,
          child: Scaffold(
            backgroundColor: const Color(0xffEEEEEE),
            appBar: AppBar(
              backgroundColor: const Color(0xffEEEEEE),
              elevation: 1,
              title: Text("Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 18, fontWeight: FontWeight.w500),),
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
              actions: [
                GestureDetector(
                  onTap: (){
                    controller.viewState.data!.data!.length == 1 ? oopsDialog() :
                    showAlertDialog(controller);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.delete_outline_rounded, color: Colors.red,),
                  ),
                ),
              ],
            ),
            body: AnimatedColumn(
                children: [
                  const SizedBox(height: 20,),
                  Container(
                    height: MediaQuery.of(context).size.height/2.7, width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child:  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(controller.productDetailsResponse?.data?.image ?? imagePlaceHolder, fit: BoxFit.cover,),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      Get.to(()=> EditProductDetails(
                        productName: controller.productDetailsResponse?.data?.name ?? "",
                        productPrice: controller.productDetailsResponse?.data?.price ?? "0",
                        imageUrl: controller.productDetailsResponse?.data?.image ?? "",
                        productId: controller.productDetailsResponse!.data!.id!,
                        description: controller.productDetailsResponse?.data?.description ?? '',
                        inStock: controller.productDetailsResponse!.data!.inStock!,
                        categoryId: controller.productDetailsResponse!.data!.categoryId!,
                        categoryName: controller.productDetailsResponse!.data!.category?.name ?? "",
                      ));
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.edit, color: greenPea, size: 15,),
                          Text("Edit", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: greenPea, fontSize: 14, fontWeight: FontWeight.w500, decoration: TextDecoration.underline),),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(controller.productDetailsResponse?.data?.name ?? "",
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 5,),
                          Text(controller.productDetailsResponse?.data?.description ?? "", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),),
                          RatingBar.builder(
                            glowColor:  const Color(0xffF2994A),
                            itemSize: 12,
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
                          const Divider(),
                          // const Text("Product Category",
                          //     style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black)),
                          // const SizedBox(height: 5,),
                          // Text(widget.products. ?? "", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),),
                          // const SizedBox(height: 10,),
                          const Text("Price",
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 5,),
                          Text("₦ ${controller.productDetailsResponse?.data?.price ?? ""}", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),),
                        ],
                      )
                  ),
                  const SizedBox(height: 10,),
                  const Text("Date added",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 5,),
                  Text(CustomDate.slash(controller.productDetailsResponse?.data?.createdAt?.toString() ?? DateTime.now().toString()), style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),),
                  const SizedBox(height: 10,),
                  const Text("Product Category",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 5,),
                  Text(controller.productDetailsResponse?.data?.category?.name ?? "", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),),
                  const SizedBox(height: 10,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Availability status",
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black)),
                          const SizedBox(height: 5,),
                          Text(controller.productDetailsResponse?.data?.inStock == true ? "In stock" : "Out of Stock",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w400),),
                        ],
                      ),
                      controller.productDetailsResponse?.data?.inStock == true ? const SizedBox() : Image.asset("assets/png/out-of-stock.png", height: 20, width: 20,)
                    ],
                  ),
                  const SizedBox(height: 15,),
                  const Text("Reviews",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black)),
                  const SizedBox(height: 10,),
                  controller.productReviewsResponse == null &&  controller.productReviewsResponse == [] || controller.productReviewsResponse!.isEmpty ?  SizedBox(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("No reviews for this product",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
                      ],
                    ),
                  ) :
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          ...List.generate(controller.productReviewsResponse!.length, (index){
                            final reviews = controller.productReviewsResponse?[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: black)),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(child: Image.network(profilePicturePlaceHolder), radius: 15, backgroundColor: Colors.transparent,),
                                        const SizedBox(width: 10,),
                                        Text("${reviews?.user?.firstName} ${reviews?.user?.lastName}",
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    Text(reviews?.comment ?? "", overflow: TextOverflow.ellipsis, maxLines: 5,)
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                ], padding: EdgeInsets.symmetric(horizontal: 20)),
          )
      ): CircularLoadingWidget();
    });
  }
}
