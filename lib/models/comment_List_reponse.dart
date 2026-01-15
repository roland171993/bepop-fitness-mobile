import '../utils/shared_import.dart';

class CommentListResponse {
  Pagination? pagination;
  List<CommentData>? data;

  CommentListResponse({this.pagination, this.data});

  CommentListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <CommentData>[];
      json['data'].forEach((v) {
        data!.add(new CommentData.fromJson(v));
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

class CommentData {
  int? id;
  String? comment;
  int? postingId;
  int? userId;
  Users? users;
  bool? canEdit;
  String? createdAt;
  int? commentReplyCount;
  List<CommentReply>? commentReply;

  CommentData(
      {this.id,
      this.comment,
      this.postingId,
      this.userId,
      this.users,
      this.canEdit,
      this.createdAt,
      this.commentReplyCount,
      this.commentReply});

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    postingId = json['posting_id'];
    userId = json['user_id'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
    canEdit = json['can_edit'];
    createdAt = json['created_at'];
    commentReplyCount = json['comment_reply_count'];
    if (json['comment_reply'] != null) {
      commentReply = <CommentReply>[];
      json['comment_reply'].forEach((v) {
        commentReply!.add(new CommentReply.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['posting_id'] = this.postingId;
    data['user_id'] = this.userId;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    data['can_edit'] = this.canEdit;
    data['created_at'] = this.createdAt;
    data['comment_reply_count'] = this.commentReplyCount;
    if (this.commentReply != null) {
      data['comment_reply'] =
          this.commentReply!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentReply {
  int? id;
  String? comment;
  int? userId;
  int? commentId;
  Users? users;
  bool? canEdit;
  String? createdAt;

  CommentReply(
      {this.id,
      this.comment,
      this.userId,
      this.commentId,
      this.users,
      this.canEdit,
      this.createdAt});

  CommentReply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    userId = json['user_id'];
    commentId = json['comment_id'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
    canEdit = json['can_edit'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['user_id'] = this.userId;
    data['comment_id'] = this.commentId;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    data['can_edit'] = this.canEdit;
    data['created_at'] = this.createdAt;
    return data;
  }
}
