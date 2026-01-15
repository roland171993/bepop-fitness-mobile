import '../utils/shared_import.dart';

class PostList {
  Pagination? pagination;
  List<PostData>? data;

  PostList({this.pagination, this.data});

  PostList.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <PostData>[];
      json['data'].forEach((v) {
        data!.add(new PostData.fromJson(v));
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

class PostData {
  int? id;
  String? description;
  String? status;
  int? userId;
  List<PostingMediaArray>? postingMediaArray;
  Users? users;
  int? postingLikeCount;
  int? postingCommentCount;
  bool? canEdit;
  bool? isLiked;
  bool? isBookmark;
  String? createdAt;

  PostData(
      {this.id,
      this.description,
      this.status,
      this.userId,
      this.postingMediaArray,
      this.users,
      this.postingLikeCount,
      this.postingCommentCount,
      this.canEdit,
      this.isLiked,
      this.isBookmark,
      this.createdAt});

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    status = json['status'];
    userId = json['user_id'];
    if (json['posting_media_array'] != null) {
      postingMediaArray = <PostingMediaArray>[];
      json['posting_media_array'].forEach((v) {
        postingMediaArray!.add(new PostingMediaArray.fromJson(v));
      });
    }
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
    postingLikeCount = json['posting_like_count'];
    postingCommentCount = json['posting_comment_count'];
    canEdit = json['can_edit'];
    isLiked = json['is_liked'];
    isBookmark = json['is_bookmark'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    if (this.postingMediaArray != null) {
      data['posting_media_array'] =
          this.postingMediaArray!.map((v) => v.toJson()).toList();
    }
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    data['posting_like_count'] = this.postingLikeCount;
    data['posting_comment_count'] = this.postingCommentCount;
    data['can_edit'] = this.canEdit;
    data['is_liked'] = this.isLiked;
    data['is_bookmark'] = this.isBookmark;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class PostingMediaArray {
  int? id;
  String? url;
  String? mimeType;

  PostingMediaArray({this.id, this.url, this.mimeType});

  PostingMediaArray.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    mimeType = json['mime_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['mime_type'] = this.mimeType;
    return data;
  }
}

class Users {
  int? id;
  String? firstName;
  String? lastName;
  String? displayName;
  String? email;
  String? username;
  String? phoneNumber;
  String? profileImage;

  Users(
      {this.id,
      this.firstName,
      this.lastName,
      this.displayName,
      this.email,
      this.username,
      this.phoneNumber,
      this.profileImage});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    email = json['email'];
    username = json['username'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['display_name'] = this.displayName;
    data['email'] = this.email;
    data['username'] = this.username;
    data['phone_number'] = this.phoneNumber;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
