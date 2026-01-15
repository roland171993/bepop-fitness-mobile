class FitBotListResponse {
  List<FitBotData>? data;

  FitBotListResponse({this.data});

  FitBotListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FitBotData>[];
      json['data'].forEach((v) {
        data!.add(new FitBotData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FitBotData {
  int? id;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;

  FitBotData(
      {this.id, this.question, this.answer, this.createdAt, this.updatedAt});

  FitBotData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
