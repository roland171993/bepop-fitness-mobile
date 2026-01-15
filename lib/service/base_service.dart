import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/login_response.dart';
import '../utils/app_constants.dart';

abstract class BaseService {
  CollectionReference? ref;

  BaseService({this.ref});

  Future<DocumentReference> addDocument(Map data) async {
    var doc = await ref!.add(data);
    doc.update({KEY_UID: doc.id});
    return doc;
  }

  Future<DocumentReference> addDocumentWithCustomId(
      String id, Map<String, dynamic> data) async {
    var doc = ref!.doc(id);

    return await doc.set(data).then((value) {
      return doc;
    }).catchError((e) {
      print(e);
      throw e;
    });
  }

  Future<void> updateDocument(Map<String, dynamic> data, String? id) async {
    await ref!.doc(id).update(data);
  }

  Future<void> removeDocument(String id) => ref!.doc(id).delete();

  // Future<bool> isUserExist(String? email) async {
  //   Query query = ref!.limit(1).where(KEY_EMAIL, isEqualTo: email);
  //   var res = await query.get();
  //
  //   print("Response Document::: ${res.docs}");
  //
  //   // ignore: unnecessary_null_comparison
  //   if (res.docs != null) {
  //     return res.docs.length == 1;
  //   } else {
  //     return false;
  //   }
  // }

  Future<Iterable> getList() async {
    var res = await ref!.get();
    Iterable it = res.docs;
    return it;
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
}
