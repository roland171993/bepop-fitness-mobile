import '../../utils/shared_import.dart';

class LocalLanguageResponse {
  String? screenID;
  String? screenName;
  List<ContentData>? keywordData;

  LocalLanguageResponse({this.screenID, this.screenName, this.keywordData});

  LocalLanguageResponse.fromJson(Map<String, dynamic> json) {
    screenID = json['screenID'];
    screenName = json['ScreenName'];
    if (json['keyword_data'] != null) {
      keywordData = <ContentData>[];
      json['keyword_data'].forEach((v) {
        keywordData!.add(new ContentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['screenID'] = this.screenID;
    data['ScreenName'] = this.screenName;
    if (this.keywordData != null) {
      data['keyword_data'] = this.keywordData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
