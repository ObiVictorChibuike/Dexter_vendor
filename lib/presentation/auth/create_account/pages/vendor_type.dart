import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:dexter_vendor/app/shared/constants/firestore_constants.dart';
import 'package:dexter_vendor/app/shared/constants/strings.dart';
import 'package:dexter_vendor/data/app_services_model/get_all_services_response_model.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:dexter_vendor/presentation/auth/create_account/controller/registration_controller.dart';
import 'package:dexter_vendor/widget/animated_column.dart';
import 'package:dexter_vendor/widget/circular_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'basic_details.dart';


class VendorType extends StatefulWidget {
  const VendorType({Key? key}) : super(key: key);

  @override
  State<VendorType> createState() => _VendorTypeState();
}

class _VendorTypeState extends State<VendorType> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
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
                  Center(child: Text('Service temporarily unavailable'))
                ],
              ),
            ),
          );
        });
  }
  bool? signInWithGoogleFirebaseStatus;
  AppServicesResponse? appServicesResponse;
  final _controller = Get.put(RegistrationController());

  Future<void> onInitializeLocalStorage() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    signInWithGoogleFirebaseStatus = await LocalCachedData.instance.getIsSignInWithFireBaseStatus();
    appServicesResponse = await LocalCachedData.instance.getAppServices();
    setState(() {});
  }


  @override
  void initState() {
    onInitializeLocalStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(top: false, bottom: false,
        child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            centerTitle: false,
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
            title: Text("Services", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: black),),
          ),
          body: appServicesResponse == null || appServicesResponse!.data!.isEmpty || appServicesResponse!.data == [] ? CircularLoadingWidget() :
          AnimatedColumn(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              ...List.generate(appServicesResponse!.data!.length, (index){
                return GestureDetector(
                  onTap: () async {
                    // Initialize the local storage
                    Get.put<LocalCachedData>(await LocalCachedData.create());
                    final currentUserId = await LocalCachedData.instance.getCurrentUserId();
                    //Save service locally
                      await LocalCachedData.instance.cacheSelectedServicesId(selectedServiceId: appServicesResponse?.data?[index].id!);
                    await LocalCachedData.instance.cacheSelectedServicesName(selectedServiceName: appServicesResponse?.data?[index].name!);
                      var user = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where("id", isEqualTo: currentUserId).get();
                      if(user.docs.isNotEmpty && signInWithGoogleFirebaseStatus == true){
                        //update business type in firebase
                        var docId = user.docs.first.id;
                        await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(docId).update({"business_type": appServicesResponse?.data?[index].name});
                      }
                      _controller.serviceId =  appServicesResponse?.data?[index].id;
                      _controller.checkBookableService = appServicesResponse?.data?[index].isBookable;
                    appServicesResponse?.data?[index].isActive == true ?  Get.offAll(()=> const BasicDetail()) : underConstruction(context);
                    // _controller.checkBookableService == true ? Get.to(()=> const ServiceProviderDetails()) : Get.to(()=> const BasicDetail());
                    //underConstruction(context)
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: double.maxFinite, padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xffE6E6E6)),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: appServicesResponse?.data?[index].coverImage  ?? imagePlaceHolder,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 50, width: 50,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.colorBurn)),
                              ),
                            ),
                            placeholder: (context, url) => CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) => ClipRRect(borderRadius: BorderRadius.circular(40),
                                child: Image.network(imagePlaceHolder, height: 50, width: 50, fit: BoxFit.cover,)),
                            // errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                          const SizedBox(width: 12),
                          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appServicesResponse?.data?[index].name ?? "", style: Theme.of(context).textTheme.bodySmall!.
                              copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: black),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 115,)
            ],
          ),
        )
    );
  }
}
