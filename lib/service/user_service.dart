import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/login_response.dart';
import '../service/base_service.dart';

import '../../main.dart';
import '../extensions/constants.dart';
import '../extensions/shared_pref.dart';
import '../utils/app_common.dart';
import '../utils/app_constants.dart';

class UserService extends BaseService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  UserService() {
    ref = fireStore.collection(USER_COLLECTION);
  }

  Future<void> updateUserStatus(Map data, String id) async {
    return ref!.doc(id).update(data as Map<String, Object?>);
  }

  Future<UserModel> getUser({String? email}) {
    return ref!.where(KEY_EMAIL, isEqualTo: email).limit(1).get().then((value) {
      if (value.docs.length == 1) {
        return UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'User Not found';
      }
    });
  }

  Future<UserModel> getUserById({String? val}) {
    return ref!.where(KEY_UID, isEqualTo: val).limit(1).get().then((value) {
      if (value.docs.length == 1) {
        return UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'User Not found';
      }
    });
  }

  Stream<List<UserModel>> users({String? searchText}) {
    return ref!
        .where(KEY_CASE_SEARCH,
            arrayContains:
                searchText?.isEmpty ?? false ? null : searchText!.toLowerCase())
        .snapshots()
        .map((x) {
      return x.docs.map((y) {
        return UserModel.fromJson(y.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Query userWithPagination({String? searchText}) {
    return ref!
        .where(KEY_CASE_SEARCH,
            arrayContains:
                searchText?.isEmpty ?? false ? null : searchText!.toLowerCase())
        .orderBy(KEY_FIREBASE_CREATED_AT, descending: true);
  }

  Future<UserModel> userByEmail(String? email) async {
    return await ref!
        .where(KEY_EMAIL, isEqualTo: email)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'No User Found';
      }
    });
  }

  Stream<UserModel> singleUser(String? id, {String? searchText}) {
    return ref!.where(KEY_UID, isEqualTo: id).limit(1).snapshots().map((event) {
      return UserModel.fromJson(
          event.docs.first.data() as Map<String, dynamic>);
    });
  }

  Future<UserModel> getUserByUserId({String? id}) {
    return ref!.where(KEY_UID, isEqualTo: id).get().then((value) {
      print(value.docs);
      return UserModel.fromJson(
          value.docs.first.data() as Map<String, dynamic>);
    });
  }

  Future<UserModel> userByMobileNumber(String? phone) async {
    return await ref!
        .where(KEY_PHONE_NUMBER, isEqualTo: phone)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return UserModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw EXCEPTION_NO_USER_FOUND;
      }
    });
  }

  DocumentReference getUserReference({required String uid}) {
    return userService.ref!.doc(uid);
  }

  Future<void> removeDocument(String? id) => userService.ref!.doc(id).delete();

  Future<String> unBlockUser(Map<String, dynamic> data) async {
    return await ref!.doc(getStringAsync(UID)).update(data).then((value) {
      return "User Blocked";
    }).catchError((e) {
      toast(e.toString());
      throw errorSomethingWentWrong;
    });
  }

  Future<String> blockUser(Map<String, dynamic> data) async {
    return await ref!.doc(getStringAsync(UID)).update(data).then((value) {
      return "User Blocked";
    }).catchError((e) {
      toast(e.toString());
      throw errorSomethingWentWrong;
    });
  }

  Future<bool> isUserBlocked(String uid) async {
    return await userService.userByEmail(getStringAsync(EMAIL)).then((value) {
      return value.blockedTo!.contains(getUserReference(uid: uid));
    });
  }

  ///DeleteUserFirebase
  Future deleteUserFirebase() async {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!.delete();
      await FirebaseAuth.instance.signOut();
    }
  }
}
