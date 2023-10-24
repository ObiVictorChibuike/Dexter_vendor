import 'package:dexter_vendor/app/shared/app_assets/assets_path.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/presentation/vendor/controller/home_controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/business/controller/controller.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor/business/pages/edit_business_details.dart';
import 'package:dexter_vendor/presentation/vendor/pages/vendor_overview/vendor_overview.dart';
import 'package:dexter_vendor/widget/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BusinessPage extends StatefulWidget {
  const BusinessPage({super.key});

  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> {
  final _scrollController = ScrollController();
  final _controller = Get.put(BusinessController());

  @override
  void initState() {
    _controller.getABusiness();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(
      init: BusinessController(),
        builder: (controller){
      return SafeArea(top: false, bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              GestureDetector(
                onTap: (){
                  Get.to(()=> EditBusinessDetails());
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
            title: Text("Business Details", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
          ),
          body: _controller.businessResponseModel == null && _controller.getBusinessLoadingState == true && _controller.getBusinessErrorState == false ?
          CircularLoadingWidget() : _controller.businessResponseModel == null && _controller.getBusinessLoadingState == false && _controller.getBusinessErrorState == false ?
          Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AssetPath.emptyFile, height: 120, width: 120,),
                const SizedBox(height: 40,),
                Text("No Records",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: dustyGray, fontSize: 14, fontWeight: FontWeight.w400),),
              ],
            ),
          ) : _controller.businessResponseModel != null && _controller.getBusinessLoadingState == false &&
              _controller.getBusinessErrorState == false ? ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                    height: MediaQuery.of(context).size.height / 4, width: double.maxFinite,
                    decoration: BoxDecoration(
                        image: DecorationImage(image:
                        NetworkImage(_controller.businessResponseModel?.data?.coverImage ?? imagePlaceHolder),
                            fit: BoxFit.cover))
                ),
                Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 8),
                    child: Column(
                      children: [
                        const SizedBox(height: 5,),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_controller.businessResponseModel?.data?.name ?? "", overflow: TextOverflow.fade,
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 16,color: black, fontWeight: FontWeight.w600,),),
                            Row(
                              children: [
                                Icon(Icons.timer_outlined, color: greenPea, size: 15,),
                                Text("Open from ${_controller.businessResponseModel?.data?.openingTime ?? ""} - ${_controller.businessResponseModel?.data?.closingTime ?? ""}", overflow: TextOverflow.fade,
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
                                Text("${_controller.businessResponseModel?.data?.contactAddress?.fullAddress ?? ""}",
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea, fontSize: 12, fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        // Row(crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text("Location: ", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea, fontSize: 13, fontWeight: FontWeight.w700),),
                        //     const SizedBox(width: 5,),
                        //     Expanded(
                        //       child: Text("${_controller.businessResponseModel?.data?.contactAddress?.fullAddress ?? ""}",
                        //         style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w400),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 5,),
                        // Row(
                        //   children: [
                        //     Text("Phone: ", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea, fontSize: 13, fontWeight: FontWeight.w700),),
                        //     const SizedBox(width: 5,),
                        //     Text("${_controller.businessResponseModel?.data?.contactPhone ?? ""}",
                        //       style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w400),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 5,),
                        // Row(
                        //   children: [
                        //     Text("Email: ", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea, fontSize: 13, fontWeight: FontWeight.w700),),
                        //     const SizedBox(width: 5,),
                        //     Text("${_controller.businessResponseModel?.data?.contactEmail ?? ""}",
                        //       style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 13, fontWeight: FontWeight.w400),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 5,),
                        // Row(
                        //   children: [
                        //     Container(
                        //       padding: EdgeInsets.all(8),
                        //       decoration: BoxDecoration(color: Color(0xffD9F2EA),
                        //           borderRadius: BorderRadius.circular(100)),
                        //       child: Text("Jobs completed: 0",
                        //         style: Theme.of(context).textTheme.bodySmall!.copyWith(color: greenPea, fontSize: 12, fontWeight: FontWeight.w600),
                        //       ),),
                        //     const SizedBox(width: 8,),
                        //     Container(
                        //       padding: EdgeInsets.all(8),
                        //       decoration: BoxDecoration(color: tulipTree.withOpacity(0.3),
                        //           borderRadius: BorderRadius.circular(100)),
                        //       child: Text("Seller rating: ${1.0}",
                        //         style: Theme.of(context).textTheme.bodySmall!.copyWith(color: tulipTree, fontSize: 12, fontWeight: FontWeight.w600),
                        //       ),),
                        //   ],
                        // ),
                        const Divider(color: greenPea,),
                        Align(alignment: Alignment.centerLeft,
                          child: Text("Bio",
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 8,),
                        Text(_controller.businessResponseModel?.data?.biography ?? "",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        const Divider(color: greenPea,),
                        const SizedBox(height: 8,),
                        Align(alignment: Alignment.centerLeft,
                            child: Text("Sample", style: Theme.of(context).textTheme.bodySmall!.
                            copyWith(color: black, fontSize: 16, fontWeight: FontWeight.w600),)),
                        const SizedBox(height: 8,),
                        // const Divider(color: greenPea,),
                        SizedBox(
                          child: GridView.builder(
                            shrinkWrap: true,
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1 / 1.02, crossAxisCount: 2, mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: _controller.businessImagesResponseModel?.data!.length ,
                            itemBuilder: (_,index){
                              return GestureDetector(
                                onTap: (){
                                  // Get.to(()=> ProductDetails(products: controller.viewState.data!.data![index],));
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
                                                    image: _controller.businessImagesResponseModel?.data![index].imageUrl == null || _controller.businessImagesResponseModel?.data![index].imageUrl  == "" ?
                                                    const NetworkImage(imagePlaceHolder) :
                                                    NetworkImage(_controller.businessImagesResponseModel!.data![index].imageUrl!),fit: BoxFit.cover,)),
                                            ),
                                          ),
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
              ]) : CircularLoadingWidget(),
        ),
      );
    });
  }
}
