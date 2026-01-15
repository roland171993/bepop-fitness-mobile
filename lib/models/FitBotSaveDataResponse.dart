class FitBotSaveDataResponse {
  String? message;

  FitBotSaveDataResponse({this.message});

  FitBotSaveDataResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
