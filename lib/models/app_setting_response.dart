class AppSettingResponse {
  int? id;
  String? siteName;
  String? siteEmail;
  String? siteDescription;
  String? siteCopyright;
  String? facebookUrl;
  String? instagramUrl;
  String? twitterUrl;
  String? linkedinUrl;
  List<String>? languageOption;
  String? contactEmail;
  String? contactNumber;
  String? helpSupportUrl;
  String? createdAt;
  String? updatedAt;
  AppVersion? appVersion;
  CrispChat? crisp_chat;
  MobileGame? mobile_game;

  AppSettingResponse({
    this.id,
    this.siteName,
    this.siteEmail,
    this.siteDescription,
    this.siteCopyright,
    this.facebookUrl,
    this.instagramUrl,
    this.twitterUrl,
    this.linkedinUrl,
    this.languageOption,
    this.contactEmail,
    this.contactNumber,
    this.helpSupportUrl,
    this.createdAt,
    this.updatedAt,
    this.appVersion,
    this.crisp_chat,
    this.mobile_game,
  });

  AppSettingResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteName = json['site_name'];
    siteEmail = json['site_email'];
    siteDescription = json['site_description'];
    siteCopyright = json['site_copyright'];
    facebookUrl = json['facebook_url'];
    instagramUrl = json['instagram_url'];
    twitterUrl = json['twitter_url'];
    linkedinUrl = json['linkedin_url'];
    languageOption = json['language_option'].cast<String>();
    contactEmail = json['contact_email'];
    contactNumber = json['contact_number'];
    helpSupportUrl = json['help_support_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    appVersion = json['app_version'] != null
        ? new AppVersion.fromJson(json['app_version'])
        : null;
    crisp_chat = json['crisp_chat'] != null
        ? new CrispChat.fromJson(json['crisp_chat'])
        : null;
    mobile_game = json['mobile_game'] != null
        ? new MobileGame.fromJson(json['mobile_game'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site_name'] = this.siteName;
    data['site_email'] = this.siteEmail;
    data['site_description'] = this.siteDescription;
    data['site_copyright'] = this.siteCopyright;
    data['facebook_url'] = this.facebookUrl;
    data['instagram_url'] = this.instagramUrl;
    data['twitter_url'] = this.twitterUrl;
    data['linkedin_url'] = this.linkedinUrl;
    data['language_option'] = this.languageOption;
    data['contact_email'] = this.contactEmail;
    data['contact_number'] = this.contactNumber;
    data['help_support_url'] = this.helpSupportUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.appVersion != null) {
      data['app_version'] = this.appVersion!.toJson();
    }
    if (this.crisp_chat != null) {
      data['crisp_chat'] = this.crisp_chat!.toJson();
    }
    return data;
  }
}

class AppVersion {
  String? androidForceUpdate;
  String? androidVersionCode;
  String? playstoreUrl;
  String? iosForceUpdate;
  String? iosVersion;
  String? appstoreUrl;

  AppVersion(
      {this.androidForceUpdate,
      this.androidVersionCode,
      this.playstoreUrl,
      this.iosForceUpdate,
      this.iosVersion,
      this.appstoreUrl});

  AppVersion.fromJson(Map<String, dynamic> json) {
    androidForceUpdate = json['android_force_update'];
    androidVersionCode = json['android_version_code'];
    playstoreUrl = json['playstore_url'];
    iosForceUpdate = json['ios_force_update'];
    iosVersion = json['ios_version'];
    appstoreUrl = json['appstore_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['android_force_update'] = this.androidForceUpdate;
    data['android_version_code'] = this.androidVersionCode;
    data['playstore_url'] = this.playstoreUrl;
    data['ios_force_update'] = this.iosForceUpdate;
    data['ios_version'] = this.iosVersion;
    data['appstore_url'] = this.appstoreUrl;
    return data;
  }
}

class CrispChat {
  String? crispChatWebsiteId;
  bool? isCrispChatEnabled;

  CrispChat({this.crispChatWebsiteId, this.isCrispChatEnabled});

  CrispChat.fromJson(Map<String, dynamic> json) {
    crispChatWebsiteId = json['crisp_chat_website_id'];
    isCrispChatEnabled = json['is_crisp_chat_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crisp_chat_website_id'] = this.crispChatWebsiteId;
    data['is_crisp_chat_enabled'] = this.isCrispChatEnabled;
    return data;
  }
}

class MobileGame {
  bool? mobile_game_enabled;

  MobileGame({this.mobile_game_enabled});

  MobileGame.fromJson(Map<String, dynamic> json) {
    mobile_game_enabled = json['mobile_game_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['crisp_chat_website_id'] = this.mobile_game_enabled;
    return data;
  }
}
