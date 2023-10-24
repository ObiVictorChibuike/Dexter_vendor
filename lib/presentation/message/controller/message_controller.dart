import 'package:dexter_vendor/datas/chat/msg.dart';
import 'package:dexter_vendor/datas/model/user/mylocation.dart';
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_error.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dexter_vendor/domain/remote/network_services/dio_service_config/dio_location_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_vendor/app/shared/constants/firestore_constants.dart';
import 'package:dexter_vendor/domain/local/local_storage.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class MessageController extends GetxController{
  List<QueryDocumentSnapshot<Msg>> messageList = <QueryDocumentSnapshot<Msg>>[].obs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  var currentUserId;
  var listener;

  Future<void> getUserId() async {
    Get.put<LocalCachedData>(await LocalCachedData.create());
    currentUserId = await LocalCachedData.instance.getCurrentUserId();
  }

 final refreshController =  RefreshController(initialRefresh: true);

  void onRefresh(){
    asyncLoadAllData().then((_){
      refreshController.refreshCompleted(resetFooterState: true);
      update();
    }).catchError((_){
      refreshController.refreshFailed();
    });
  }

  void onLoading(){
    asyncLoadAllData().then((_){
      refreshController.loadComplete();
      update();
    }).catchError((_){
      refreshController.loadFailed();
    });
  }

  getFcmToken()async{
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if(fcmToken != null){
      var user = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where("id", isEqualTo: currentUserId).get();
      if(user.docs.isNotEmpty){
        var docId = user.docs.first.id;
        await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(docId).update({"fcmtoken": fcmToken});
      }
    }
  }

  int messageListTotal = 0;
  
  Future<void> asyncLoadAllData()async{
    Get.put<LocalCachedData>(await LocalCachedData.create());
    final currentUserId = await LocalCachedData.instance.getCurrentUserId();
    var fromMessages = await firebaseFirestore.collection(FirestoreConstants.pathMessageCollection).withConverter(
        fromFirestore: Msg.fromFirestore, 
        toFirestore: (Msg msg, option)=>msg.toFirestore()
    ).where("from_uid", isEqualTo: currentUserId).get();

    var toMessage = await firebaseFirestore.collection(FirestoreConstants.pathMessageCollection).withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, option)=>msg.toFirestore()
    ).where("to_uid", isEqualTo: currentUserId).get();
    messageList.clear();
    update();
    if(fromMessages.docs.isNotEmpty){
      messageList.assignAll(fromMessages.docs);
      messageListTotal = messageList.length;
      update();
    }
    if(toMessage.docs.isNotEmpty){
      messageList.assignAll(toMessage.docs);
      messageListTotal = messageList.length;
      update();
    }
  }

  // getUserLocation({required String key})async{
  //   Get.put<LocalCachedData>(await LocalCachedData.create());
  //   final currentUserId = await LocalCachedData.instance.getCurrentUserId();
  //   try{
  //     final location = await Location().getLocation();
  //     String address = "${location.latitude}, ${location.longitude}";
  //     var response = await DioLocationClient().call(path: "/maps/api/geocode/json?address=${address}&key=${key}",
  //       method: RequestMethod.get,);
  //     MyLocation locationResponse = MyLocation.fromJson(response!.data);
  //     if(locationResponse.status == "OK"){
  //       String? myAddress = locationResponse.results?.first.formattedAddress;
  //       if(myAddress != null){
  //         var userLocation = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where("id", isEqualTo: currentUserId).get();
  //         if(userLocation.docs.isNotEmpty){
  //           var docId = userLocation.docs.first.id;
  //           await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(docId).update({"location": myAddress});
  //         }
  //       }
  //     }
  //   }on dio.DioError catch (err) {
  //     final errorMessage = Future.error(ApiError.fromDio(err));
  //     update();
  //     throw errorMessage;
  //   } catch (err) {
  //     update();
  //     throw err.toString();
  //   }
  // }


  @override
  void onReady() {
    // getUserLocation(key: "");
    getFcmToken();
    super.onReady();
  }

  @override
  void onInit() {
    getUserId();
    super.onInit();
  }
}