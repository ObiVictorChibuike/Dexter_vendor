// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dexter_vendor/app/shared/constants/firestore_constants.dart';
//
// class UserChatModel {
//   final String id;
//   final String? photoUrl;
//   final String? nickname;
//   final String? aboutMe;
//   final String userType;
//
//   const UserChatModel({required this.userType,required this.id,this.photoUrl, this.nickname, this.aboutMe});
//
//   Map<String, String> toJson() {
//     return {
//       FirestoreConstants.nickname: nickname == null ? "" : nickname!,
//       FirestoreConstants.aboutMe: aboutMe == null ? "" : aboutMe!,
//       FirestoreConstants.photoUrl: photoUrl == null ? "" : photoUrl!,
//       FirestoreConstants.userType: userType,
//     };
//   }
//
//   factory UserChatModel.fromDocument(DocumentSnapshot doc) {
//     String aboutMe = "";
//     String photoUrl = "";
//     String nickname = "";
//     String userType = "";
//     try {
//       aboutMe = doc.get(FirestoreConstants.aboutMe);
//     } catch (e) {}
//     try {
//       photoUrl = doc.get(FirestoreConstants.photoUrl);
//     } catch (e) {}
//     try {
//       nickname = doc.get(FirestoreConstants.nickname);
//     } catch (e) {}
//     try {
//       nickname = doc.get(FirestoreConstants.userType);
//     } catch (e) {}
//     return UserChatModel(
//       id: doc.id,
//       photoUrl: photoUrl,
//       nickname: nickname,
//       aboutMe: aboutMe,
//       userType: userType
//     );
//   }
// }
