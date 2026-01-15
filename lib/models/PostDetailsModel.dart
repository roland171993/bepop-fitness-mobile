import '../utils/shared_import.dart';

class PostDetailModel {
  PostData? data;

  PostDetailModel({this.data});

  PostDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PostData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
