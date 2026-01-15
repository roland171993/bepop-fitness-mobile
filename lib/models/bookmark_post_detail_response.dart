import '../utils/shared_import.dart';

class BookmarkPostModel {
  Pagination? pagination;
  List<BookmarkData>? data;

  BookmarkPostModel({this.pagination, this.data});

  BookmarkPostModel.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <BookmarkData>[];
      json['data'].forEach((v) {
        data!.add(new BookmarkData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookmarkData {
  int? id;
  int? userId;
  int? postingId;
  String? displayName;
  PostData? posts;
  String? username;
  String? profileImage;

  BookmarkData(
      {this.id,
      this.userId,
      this.postingId,
      this.displayName,
      this.posts,
      this.username,
      this.profileImage});

  BookmarkData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    postingId = json['posting_id'];
    displayName = json['display_name'];
    posts = json['posts'] != null ? new PostData.fromJson(json['posts']) : null;
    username = json['username'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['posting_id'] = this.postingId;
    data['display_name'] = this.displayName;
    if (this.posts != null) {
      data['posts'] = this.posts!.toJson();
    }
    data['username'] = this.username;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
