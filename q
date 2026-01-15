[33mcommit 64698c4a9611f9f8e1302f881ba932cedc7d9ef0[m[33m ([m[1;36mHEAD[m[33m -> [m[1;32mmain[m[33m)[m
Author: Roland <roland171993@gmail.com>
Date:   Sat Sep 24 03:47:20 2022 +0000

    Moved from bitburket

 .gitignore                                         |   17 [32m+[m
 android/.gradle/8.14.2/checksums/checksums.lock    |  Bin [31m0[m -> [32m17[m bytes
 android/.gradle/8.14.2/checksums/md5-checksums.bin |  Bin [31m0[m -> [32m280069[m bytes
 .../.gradle/8.14.2/checksums/sha1-checksums.bin    |  Bin [31m0[m -> [32m926843[m bytes
 .../8.14.2/executionHistory/executionHistory.bin   |  Bin [31m0[m -> [32m17737046[m bytes
 .../8.14.2/executionHistory/executionHistory.lock  |  Bin [31m0[m -> [32m17[m bytes
 android/.gradle/8.14.2/expanded/expanded.lock      |  Bin [31m0[m -> [32m17[m bytes
 android/.gradle/8.14.2/fileChanges/last-build.bin  |  Bin [31m0[m -> [32m1[m bytes
 android/.gradle/8.14.2/fileHashes/fileHashes.bin   |  Bin [31m0[m -> [32m1531065[m bytes
 android/.gradle/8.14.2/fileHashes/fileHashes.lock  |  Bin [31m0[m -> [32m17[m bytes
 .../8.14.2/fileHashes/resourceHashesCache.bin      |  Bin [31m0[m -> [32m116591[m bytes
 android/.gradle/8.14.2/gc.properties               |    0
 .../buildOutputCleanup/buildOutputCleanup.lock     |  Bin [31m0[m -> [32m17[m bytes
 .../.gradle/buildOutputCleanup/cache.properties    |    2 [32m+[m
 android/.gradle/buildOutputCleanup/outputFiles.bin |  Bin [31m0[m -> [32m335051[m bytes
 android/.gradle/file-system.probe                  |  Bin [31m0[m -> [32m8[m bytes
 android/.gradle/noVersion/buildLogic.lock          |  Bin [31m0[m -> [32m17[m bytes
 android/.gradle/vcs-1/gc.properties                |    0
 android/app/build.gradle                           |    6 [32m+[m[31m-[m
 android/app/google-services.json                   |   48 [32m+[m
 android/app/src/debug/AndroidManifest.xml          |    8 [32m+[m
 android/app/src/main/AndroidManifest.xml           |  120 [32m+[m
 android/app/src/main/ic_launcher-playstore.png     |  Bin [31m0[m -> [32m22732[m bytes
 .../flutter/plugins/GeneratedPluginRegistrant.java |  229 [32m++[m
 .../assoh/bepopfitness/saas}/MainActivity.kt       |    2 [32m+[m[31m-[m
 .../res/drawable-hdpi-v31/android12branding.png    |  Bin [31m0[m -> [32m3244[m bytes
 .../drawable-hdpi/ic_stat_onesignal_default.png    |  Bin [31m0[m -> [32m986[m bytes
 .../res/drawable-mdpi-v31/android12branding.png    |  Bin [31m0[m -> [32m2299[m bytes
 .../drawable-mdpi/ic_stat_onesignal_default.png    |  Bin [31m0[m -> [32m631[m bytes
 .../drawable-night-hdpi-v31/android12branding.png  |  Bin [31m0[m -> [32m3244[m bytes
 .../drawable-night-mdpi-v31/android12branding.png  |  Bin [31m0[m -> [32m2299[m bytes
 .../src/main/res/drawable-night-v21/background.png |  Bin [31m0[m -> [32m69[m bytes
 .../res/drawable-night-v21/launch_background.xml   |    6 [32m+[m
 .../drawable-night-xhdpi-v31/android12branding.png |  Bin [31m0[m -> [32m3290[m bytes
 .../android12branding.png                          |  Bin [31m0[m -> [32m4750[m bytes
 .../android12branding.png                          |  Bin [31m0[m -> [32m8496[m bytes
 .../app/src/main/res/drawable-night/background.png |  Bin [31m0[m -> [32m69[m bytes
 .../main/res/drawable-night/launch_background.xml  |    6 [32m+[m
 .../app/src/main/res/drawable-v21/background.png   |  Bin [31m0[m -> [32m69[m bytes
 .../main/res/drawable-v21/launch_background.xml    |    6 [32m+[m
 .../res/drawable-xhdpi-v31/android12branding.png   |  Bin [31m0[m -> [32m3290[m bytes
 .../drawable-xhdpi/ic_stat_onesignal_default.png   |  Bin [31m0[m -> [32m1568[m bytes
 .../res/drawable-xxhdpi-v31/android12branding.png  |  Bin [31m0[m -> [32m4750[m bytes
 .../drawable-xxhdpi/ic_stat_onesignal_default.png  |  Bin [31m0[m -> [32m2354[m bytes
 .../res/drawable-xxxhdpi-v31/android12branding.png |  Bin [31m0[m -> [32m8496[m bytes
 .../drawable-xxxhdpi/ic_stat_onesignal_default.png |  Bin [31m0[m -> [32m3714[m bytes
 android/app/src/main/res/drawable/background.png   |  Bin [31m0[m -> [32m69[m bytes
 .../src/main/res/drawable/launch_background.xml    |    6 [32m+[m
 .../src/main/res/mipmap-anydpi-v26/ic_launcher.xml |    5 [32m+[m
 .../res/mipmap-anydpi-v26/ic_launcher_round.xml    |    5 [32m+[m
 .../app/src/main/res/mipmap-hdpi/ic_launcher.webp  |  Bin [31m0[m -> [32m1568[m bytes
 .../res/mipmap-hdpi/ic_launcher_foreground.webp    |  Bin [31m0[m -> [32m1662[m bytes
 .../main/res/mipmap-hdpi/ic_launcher_round.webp    |  Bin [31m0[m -> [32m2830[m bytes
 .../app/src/main/res/mipmap-mdpi/ic_launcher.webp  |  Bin [31m0[m -> [32m1036[m bytes
 .../res/mipmap-mdpi/ic_launcher_foreground.webp    |  Bin [31m0[m -> [32m1100[m bytes
 .../main/res/mipmap-mdpi/ic_launcher_round.webp    |  Bin [31m0[m -> [32m1844[m bytes
 .../app/src/main/res/mipmap-xhdpi/ic_launcher.webp |  Bin [31m0[m -> [32m2018[m bytes
 .../res/mipmap-xhdpi/ic_launcher_foreground.webp   |  Bin [31m0[m -> [32m2206[m bytes
 .../main/res/mipmap-xhdpi/ic_launcher_round.webp   |  Bin [31m0[m -> [32m4196[m bytes
 .../src/main/res/mipmap-xxhdpi/ic_launcher.webp    |  Bin [31m0[m -> [32m3114[m bytes
 .../res/mipmap-xxhdpi/ic_launcher_foreground.webp  |  Bin [31m0[m -> [32m3206[m bytes
 .../main/res/mipmap-xxhdpi/ic_launcher_round.webp  |  Bin [31m0[m -> [32m6548[m bytes
 .../src/main/res/mipmap-xxxhdpi/ic_launcher.webp   |  Bin [31m0[m -> [32m4058[m bytes
 .../res/mipmap-xxxhdpi/ic_launcher_foreground.webp |  Bin [31m0[m -> [32m4276[m bytes
 .../main/res/mipmap-xxxhdpi/ic_launcher_round.webp |  Bin [31m0[m -> [32m9304[m bytes
 android/app/src/main/res/values-night/styles.xml   |   18 [32m+[m
 .../src/main/res/values/ic_launcher_background.xml |    4 [32m+[m
 android/app/src/main/res/values/styles.xml         |   18 [32m+[m
 android/app/src/profile/AndroidManifest.xml        |    8 [32m+[m
 android/build.gradle                               |   46 [32m+[m
 android/gradle.properties                          |    8 [32m+[m
 android/gradle/wrapper/gradle-wrapper.jar          |  Bin [31m0[m -> [32m53636[m bytes
 android/gradle/wrapper/gradle-wrapper.properties   |    6 [32m+[m
 android/gradlew                                    |  160 [32m++[m
 android/gradlew.bat                                |   90 [32m+[m
 android/local.properties                           |    5 [32m+[m
 android/settings.gradle                            |   28 [32m+[m
 assets/Flag/ic_af.png                              |  Bin [31m0[m -> [32m1817[m bytes
 assets/Flag/ic_ar.png                              |  Bin [31m0[m -> [32m492[m bytes
 assets/Flag/ic_fr.png                              |  Bin [31m0[m -> [32m394[m bytes
 assets/Flag/ic_in.png                              |  Bin [31m0[m -> [32m713[m bytes
 assets/Flag/ic_pt.png                              |  Bin [31m0[m -> [32m10967[m bytes
 assets/Flag/ic_tr.png                              |  Bin [31m0[m -> [32m887[m bytes
 assets/Flag/ic_us.png                              |  Bin [31m0[m -> [32m1717[m bytes
 assets/Flag/ic_vi.png                              |  Bin [31m0[m -> [32m795[m bytes
 assets/android12splash.png                         |  Bin [31m0[m -> [32m15860[m bytes
 assets/backward.png                                |  Bin [31m0[m -> [32m20994[m bytes
 assets/broadcast.png                               |  Bin [31m0[m -> [32m13801[m bytes
 assets/coin.png                                    |  Bin [31m0[m -> [32m14161[m bytes
 assets/comu.png                                    |  Bin [31m0[m -> [32m16108[m bytes
 assets/cservice.png                                |  Bin [31m0[m -> [32m15113[m bytes
 assets/custom.png                                  |  Bin [31m0[m -> [32m8855[m bytes
 assets/empty_graph.png                             |  Bin [31m0[m -> [32m272[m bytes
 assets/fitness_language.json                       | 2216 [32m+++++++++++++++++[m
 assets/fitnesstext.png                             |  Bin [31m0[m -> [32m8383[m bytes
 assets/forward.png                                 |  Bin [31m0[m -> [32m20701[m bytes
 assets/full_graph.png                              |  Bin [31m0[m -> [32m198[m bytes
 assets/full_gym.png                                |  Bin [31m0[m -> [32m20050[m bytes
 assets/gameover.json                               |    1 [32m+[m
 assets/garage_gym.png                              |  Bin [31m0[m -> [32m949[m bytes
 assets/ic_apple.png                                |  Bin [31m0[m -> [32m938[m bytes
 assets/ic_assigned.png                             |  Bin [31m0[m -> [32m513[m bytes
 assets/ic_blog.png                                 |  Bin [31m0[m -> [32m727[m bytes
 assets/ic_bmi.png                                  |  Bin [31m0[m -> [32m7097[m bytes
 assets/ic_bmr.png                                  |  Bin [31m0[m -> [32m3543[m bytes
 assets/ic_bmr1.png                                 |  Bin [31m0[m -> [32m6059[m bytes
 assets/ic_bookmark.png                             |  Bin [31m0[m -> [32m6390[m bytes
 assets/ic_bot.png                                  |  Bin [31m0[m -> [32m674[m bytes
 assets/ic_build.png                                |  Bin [31m0[m -> [32m10582[m bytes
 assets/ic_call.png                                 |  Bin [31m0[m -> [32m751[m bytes
 assets/ic_calories.png                             |  Bin [31m0[m -> [32m1050[m bytes
 assets/ic_camera.png                               |  Bin [31m0[m -> [32m766[m bytes
 assets/ic_carbs.png                                |  Bin [31m0[m -> [32m1558[m bytes
 assets/ic_change_password.png                      |  Bin [31m0[m -> [32m823[m bytes
 assets/ic_checkbox.png                             |  Bin [31m0[m -> [32m596[m bytes
 assets/ic_comment.png                              |  Bin [31m0[m -> [32m1512[m bytes
 assets/ic_community.png                            |  Bin [31m0[m -> [32m1947[m bytes
 assets/ic_community_filled.png                     |  Bin [31m0[m -> [32m1471[m bytes
 assets/ic_crisps_chat.png                          |  Bin [31m0[m -> [32m17470[m bytes
 assets/ic_delete.png                               |  Bin [31m0[m -> [32m668[m bytes
 assets/ic_diet_fill.png                            |  Bin [31m0[m -> [32m724[m bytes
 assets/ic_diet_outline.png                         |  Bin [31m0[m -> [32m944[m bytes
 assets/ic_dumbbell.png                             |  Bin [31m0[m -> [32m718[m bytes
 assets/ic_edit.png                                 |  Bin [31m0[m -> [32m473[m bytes
 assets/ic_eye.png                                  |  Bin [31m0[m -> [32m887[m bytes
 assets/ic_eye_close.png                            |  Bin [31m0[m -> [32m592[m bytes
 assets/ic_facebook.png                             |  Bin [31m0[m -> [32m5091[m bytes
 assets/ic_fat.png                                  |  Bin [31m0[m -> [32m1629[m bytes
 assets/ic_fav_fill.png                             |  Bin [31m0[m -> [32m578[m bytes
 assets/ic_fav_outline.png                          |  Bin [31m0[m -> [32m672[m bytes
 assets/ic_favorite.png                             |  Bin [31m0[m -> [32m862[m bytes
 assets/ic_female.png                               |  Bin [31m0[m -> [32m37752[m bytes
 assets/ic_female_selected.png                      |  Bin [31m0[m -> [32m36992[m bytes
 assets/ic_fill_Schedule.png                        |  Bin [31m0[m -> [32m1569[m bytes
 assets/ic_fill_checkbox.png                        |  Bin [31m0[m -> [32m642[m bytes
 assets/ic_gmail.png                                |  Bin [31m0[m -> [32m985[m bytes
 assets/ic_google.png                               |  Bin [31m0[m -> [32m4302[m bytes
 assets/ic_help.png                                 |  Bin [31m0[m -> [32m950[m bytes
 assets/ic_home_fill.png                            |  Bin [31m0[m -> [32m573[m bytes
 assets/ic_home_outline.png                         |  Bin [31m0[m -> [32m795[m bytes
 assets/ic_ideal_weight.png                         |  Bin [31m0[m -> [32m2838[m bytes
 assets/ic_ideal_weight1.png                        |  Bin [31m0[m -> [32m6267[m bytes
 assets/ic_info.png                                 |  Bin [31m0[m -> [32m542[m bytes
 assets/ic_instagram.png                            |  Bin [31m0[m -> [32m3748[m bytes
 assets/ic_keep.png                                 |  Bin [31m0[m -> [32m13856[m bytes
 assets/ic_language.png                             |  Bin [31m0[m -> [32m369[m bytes
 assets/ic_languages.png                            |  Bin [31m0[m -> [32m1293[m bytes
 assets/ic_level.png                                |  Bin [31m0[m -> [32m267[m bytes
 assets/ic_like.png                                 |  Bin [31m0[m -> [32m1484[m bytes
 assets/ic_like_filled.png                          |  Bin [31m0[m -> [32m997[m bytes
 assets/ic_linkedin.png                             |  Bin [31m0[m -> [32m5925[m bytes
 assets/ic_login_new.png                            |  Bin [31m0[m -> [32m2068[m bytes
 assets/ic_logo.png                                 |  Bin [31m0[m -> [32m9927[m bytes
 assets/ic_logo2.png                                |  Bin [31m0[m -> [32m4337[m bytes
 assets/ic_logout.png                               |  Bin [31m0[m -> [32m537[m bytes
 assets/ic_lose.png                                 |  Bin [31m0[m -> [32m8908[m bytes
 assets/ic_loseweight.png                           |    0
 assets/ic_mail.png                                 |  Bin [31m0[m -> [32m767[m bytes
 assets/ic_male.png                                 |  Bin [31m0[m -> [32m58705[m bytes
 assets/ic_male_unselected.png                      |  Bin [31m0[m -> [32m52074[m bytes
 assets/ic_menu.png                                 |  Bin [31m0[m -> [32m368[m bytes
 assets/ic_messages.png                             |  Bin [31m0[m -> [32m1086[m bytes
 assets/ic_mobile.png                               |  Bin [31m0[m -> [32m753[m bytes
 assets/ic_noequpment.png                           |  Bin [31m0[m -> [32m1468[m bytes
 assets/ic_notification.png                         |  Bin [31m0[m -> [32m519[m bytes
 assets/ic_placeholder.jpg                          |  Bin [31m0[m -> [32m3888[m bytes
 assets/ic_podcast.png                              |  Bin [31m0[m -> [32m4418[m bytes
 assets/ic_protein.png                              |  Bin [31m0[m -> [32m2149[m bytes
 assets/ic_radio-button.png                         |  Bin [31m0[m -> [32m828[m bytes
 assets/ic_radio_button_fill.png                    |  Bin [31m0[m -> [32m990[m bytes
 assets/ic_rate_us.png                              |  Bin [31m0[m -> [32m711[m bytes
 assets/ic_reminder.png                             |  Bin [31m0[m -> [32m574[m bytes
 assets/ic_report.png                               |  Bin [31m0[m -> [32m13132[m bytes
 assets/ic_report_fill.png                          |  Bin [31m0[m -> [32m550[m bytes
 assets/ic_report_outline.png                       |  Bin [31m0[m -> [32m720[m bytes
 assets/ic_running.png                              |  Bin [31m0[m -> [32m4610[m bytes
 assets/ic_save.png                                 |  Bin [31m0[m -> [32m1351[m bytes
 assets/ic_save_filled.png                          |  Bin [31m0[m -> [32m891[m bytes
 assets/ic_schedule.png                             |  Bin [31m0[m -> [32m1637[m bytes
 assets/ic_search.png                               |  Bin [31m0[m -> [32m665[m bytes
 assets/ic_setting.png                              |  Bin [31m0[m -> [32m822[m bytes
 assets/ic_share.png                                |  Bin [31m0[m -> [32m596[m bytes
 assets/ic_share_community.png                      |  Bin [31m0[m -> [32m1271[m bytes
 assets/ic_sort.png                                 |  Bin [31m0[m -> [32m270[m bytes
 assets/ic_step.png                                 |  Bin [31m0[m -> [32m819[m bytes
 assets/ic_store_fill.png                           |  Bin [31m0[m -> [32m466[m bytes
 assets/ic_store_outline.png                        |  Bin [31m0[m -> [32m629[m bytes
 assets/ic_story.png                                |  Bin [31m0[m -> [32m6123[m bytes
 assets/ic_subscription_plan.png                    |  Bin [31m0[m -> [32m926[m bytes
 assets/ic_terms.png                                |  Bin [31m0[m -> [32m550[m bytes
 assets/ic_theme.png                                |  Bin [31m0[m -> [32m779[m bytes
 assets/ic_twitter.png                              |  Bin [31m0[m -> [32m5396[m bytes
 assets/ic_user.png                                 |  Bin [31m0[m -> [32m803[m bytes
 assets/ic_user_fill_icon.png                       |  Bin [31m0[m -> [32m483[m bytes
 assets/ic_video.png                                |  Bin [31m0[m -> [32m6386[m bytes
 assets/ic_walk1.png                                |  Bin [31m0[m -> [32m838188[m bytes
 assets/ic_walk2.png                                |  Bin [31m0[m -> [32m989223[m bytes
 assets/ic_walk3.png                                |  Bin [31m0[m -> [32m872781[m bytes
 assets/ic_walk_shape.png                           |  Bin [31m0[m -> [32m4140[m bytes
 assets/ic_wallpaper.png                            |  Bin [31m0[m -> [32m1506[m bytes
 assets/leaderboard.png                             |  Bin [31m0[m -> [32m43068[m bytes
 assets/lightBg.svg                                 |    1 [32m+[m
 assets/loading.json                                |    1 [32m+[m
 assets/logo_lockup_flutter_vertical.png            |  Bin [31m0[m -> [32m42324[m bytes
 assets/logo_lockup_flutter_vertical_wht.png        |  Bin [31m0[m -> [32m55007[m bytes
 assets/mental.png                                  |  Bin [31m0[m -> [32m2400[m bytes
 assets/mindgif.json                                |    1 [32m+[m
 assets/newlogo.png                                 |  Bin [31m0[m -> [32m78496[m bytes
 assets/no_data_found.png                           |  Bin [31m0[m -> [32m19586[m bytes
 assets/no_internet.png                             |  Bin [31m0[m -> [32m11664[m bytes
 assets/one_graph.png                               |  Bin [31m0[m -> [32m260[m bytes
 assets/person.svg                                  |    0
 assets/profile.png                                 |  Bin [31m0[m -> [32m71963[m bytes
 assets/scoreboard.png                              |  Bin [31m0[m -> [32m29296[m bytes
 assets/sounds/coins.mp3                            |  Bin [31m0[m -> [32m36780[m bytes
 assets/sounds/correct.mp3                          |  Bin [31m0[m -> [32m18720[m bytes
 assets/sounds/startplay.mp3                        |  Bin [31m0[m -> [32m45975[m bytes
 assets/sounds/wrong.mp3                            |  Bin [31m0[m -> [32m56832[m bytes
 assets/star.json                                   |    1 [32m+[m
 assets/subscribeBG.png                             |  Bin [31m0[m -> [32m189161[m bytes
 assets/two_graph.png                               |  Bin [31m0[m -> [32m245[m bytes
 assets/update.png                                  |  Bin [31m0[m -> [32m30645[m bytes
 devtools_options.yaml                              |    3 [32m+[m
 flutter_google_cast-master/.fvm/flutter_sdk        |    1 [32m+[m
 flutter_google_cast-master/.fvm/fvm_config.json    |    3 [32m+[m
 flutter_google_cast-master/.fvm/release            |    1 [32m+[m
 flutter_google_cast-master/.fvm/version            |    1 [32m+[m
 flutter_google_cast-master/.fvm/versions/stable    |    1 [32m+[m
 .../.github/PUBLISHING_SETUP.md                    |  153 [32m++[m
 .../.github/workflows/ci.yml                       |   91 [32m+[m
 .../.github/workflows/coverage.yml                 |  103 [32m+[m
 .../.github/workflows/publish.yml                  |   18 [32m+[m
 flutter_google_cast-master/.gitignore              |   31 [32m+[m
 flutter_google_cast-master/.metadata               |   33 [32m+[m
 .../ANDROID_BUILD_TROUBLESHOOTING.md               |  144 [32m++[m
 flutter_google_cast-master/CHANGELOG.md            |  213 [32m++[m
 flutter_google_cast-master/CUSTOMIZABLE_TEXTS.md   |  114 [32m+[m
 flutter_google_cast-master/IMPORT_GUIDE.md         |   77 [32m+[m
 .../KOTLIN_DOCUMENTATION_GUIDE.md                  |  498 [32m++++[m
 flutter_google_cast-master/LICENSE                 |   11 [32m+[m
 flutter_google_cast-master/NATIVE_ANDROID_GUIDE.md |  403 [32m++++[m
 flutter_google_cast-master/NATIVE_GUIDE.md         |  266 [32m+++[m
 flutter_google_cast-master/NATIVE_IOS_GUIDE.md     |  249 [32m++[m
 flutter_google_cast-master/README.md               |  875 [32m+++++++[m
 .../SWIFT_DOCUMENTATION_GUIDE.md                   |  344 [32m+++[m
 .../Screen_Recording_20250618_125333.mp4           |  Bin [31m0[m -> [32m4609766[m bytes
 .../Screenshot_20250618_130514.jpg                 |  Bin [31m0[m -> [32m310870[m bytes
 flutter_google_cast-master/TESTING_GUIDE.md        |  210 [32m++[m
 flutter_google_cast-master/analysis_options.yaml   |   59 [32m+[m
 flutter_google_cast-master/android/.gitignore      |    9 [32m+[m
 flutter_google_cast-master/android/build.gradle    |   58 [32m+[m
 .../android/gradle.properties                      |    8 [32m+[m
 .../android/gradle/wrapper/gradle-wrapper.jar      |  Bin [31m0[m -> [32m59821[m bytes
 .../gradle/wrapper/gradle-wrapper.properties       |    5 [32m+[m
 flutter_google_cast-master/android/gradlew         |  234 [32m++[m
 flutter_google_cast-master/android/gradlew.bat     |   89 [32m+[m
 .../android/proguard-rules.pro                     |   31 [32m+[m
 flutter_google_cast-master/android/settings.gradle |    1 [32m+[m
 .../android/src/main/AndroidManifest.xml           |    4 [32m+[m
 .../google_cast/CastContextMethodChannel.kt        |  185 [32m++[m
 .../google_cast/DiscoveryManagerMethodChannel.kt   |  274 [32m+++[m
 .../google_cast/GoogleCastOptionsProvider.kt       |   56 [32m+[m
 .../com/felnanuke/google_cast/GoogleCastPlugin.kt  |  120 [32m+[m
 .../google_cast/RemoteMediaClientMethodChannel.kt  |  365 [32m+++[m
 .../google_cast/SessionManagerMethodChannel.kt     |  220 [32m++[m
 .../google_cast/extensions/CastDeviceExtensions.kt |   54 [32m+[m
 .../google_cast/extensions/MediaInfoExtensions.kt  |   69 [32m+[m
 .../extensions/MediaLoadOptionsExtensions.kt       |   61 [32m+[m
 .../extensions/MediaStatusExtensions.kt            |   67 [32m+[m
 .../google_cast/extensions/MediaTrackExtensions.kt |   55 [32m+[m
 .../google_cast/extensions/MetadataExtensions.kt   |   84 [32m+[m
 .../google_cast/extensions/QueueItemsExtensions.kt |   51 [32m+[m
 .../extensions/SeekOptionsExtensions.kt            |   18 [32m+[m
 .../google_cast/extensions/SessionExtensions.kt    |   27 [32m+[m
 .../android/src/main/res/values/strings.xml        |    4 [32m+[m
 .../android_discovery_manager.dart.gcov.html       |  177 [32m++[m
 .../discovery_manager.dart.gcov.html               |  102 [32m+[m
 .../_discovery_manager/index-detail-sort-f.html    |  143 [32m++[m
 .../_discovery_manager/index-detail-sort-l.html    |  143 [32m++[m
 .../html/_discovery_manager/index-detail.html      |  143 [32m++[m
 .../html/_discovery_manager/index-sort-f.html      |  116 [32m+[m
 .../html/_discovery_manager/index-sort-l.html      |  116 [32m+[m
 .../coverage/html/_discovery_manager/index.html    |  116 [32m+[m
 .../ios_discovery_manager.dart.gcov.html           |  155 [32m++[m
 ...ogle_cast_context_method_channel.dart.gcov.html |  101 [32m+[m
 .../google_cast_context.dart.gcov.html             |  102 [32m+[m
 ..._cast_context_platform_interface.dart.gcov.html |   94 [32m+[m
 .../_google_cast_context/index-detail-sort-f.html  |  158 [32m++[m
 .../_google_cast_context/index-detail-sort-l.html  |  158 [32m++[m
 .../html/_google_cast_context/index-detail.html    |  158 [32m++[m
 .../html/_google_cast_context/index-sort-f.html    |  125 [32m+[m
 .../html/_google_cast_context/index-sort-l.html    |  125 [32m+[m
 .../coverage/html/_google_cast_context/index.html  |  125 [32m+[m
 ...ogle_cast_context_method_channel.dart.gcov.html |  102 [32m+[m
 ...mote_media_client_method_channel.dart.gcov.html |  345 [32m+++[m
 .../_remote_media_client/index-detail-sort-f.html  |  137 [32m++[m
 .../_remote_media_client/index-detail-sort-l.html  |  137 [32m++[m
 .../html/_remote_media_client/index-detail.html    |  137 [32m++[m
 .../html/_remote_media_client/index-sort-f.html    |  116 [32m+[m
 .../html/_remote_media_client/index-sort-l.html    |  116 [32m+[m
 .../coverage/html/_remote_media_client/index.html  |  116 [32m+[m
 ...mote_media_client_method_channel.dart.gcov.html |  310 [32m+++[m
 .../remote_media_client.dart.gcov.html             |  103 [32m+[m
 .../android_cast_session_manager.dart.gcov.html    |  182 [32m++[m
 .../cast_session_manager.dart.gcov.html            |  102 [32m+[m
 .../cast_session_manager_platform.dart.gcov.html   |  192 [32m++[m
 .../html/_session_manager/index-detail-sort-f.html |  134 [32m++[m
 .../html/_session_manager/index-detail-sort-l.html |  134 [32m++[m
 .../html/_session_manager/index-detail.html        |  134 [32m++[m
 .../html/_session_manager/index-sort-f.html        |  125 [32m+[m
 .../html/_session_manager/index-sort-l.html        |  125 [32m+[m
 .../coverage/html/_session_manager/index.html      |  125 [32m+[m
 .../ios_cast_session_manager.dart.gcov.html        |  176 [32m++[m
 flutter_google_cast-master/coverage/html/amber.png |  Bin [31m0[m -> [32m141[m bytes
 flutter_google_cast-master/coverage/html/cmd_line  |    1 [32m+[m
 .../coverage/html/common/break.dart.gcov.html      |  152 [32m++[m
 .../html/common/break_clips.dart.gcov.html         |  218 [32m++[m
 .../html/common/cast_status_event.dart.gcov.html   |  121 [32m+[m
 .../html/common/font_generic_family.dart.gcov.html |  128 [32m+[m
 .../html/common/hls_segment_format.dart.gcov.html  |  133 [32m++[m
 .../common/hls_video_segment_format.dart.gcov.html |  105 [32m+[m
 .../coverage/html/common/image.dart.gcov.html      |  121 [32m+[m
 .../coverage/html/common/index-detail-sort-f.html  |  257 [32m++[m
 .../coverage/html/common/index-detail-sort-l.html  |  257 [32m++[m
 .../coverage/html/common/index-detail.html         |  257 [32m++[m
 .../coverage/html/common/index-sort-f.html         |  242 [32m++[m
 .../coverage/html/common/index-sort-l.html         |  242 [32m++[m
 .../coverage/html/common/index.html                |  242 [32m++[m
 .../html/common/live_seekable_range.dart.gcov.html |  159 [32m++[m
 .../html/common/rfc5646_language.dart.gcov.html    |  801 [32m+++++++[m
 .../common/text_track_edge_type.dart.gcov.html     |  115 [32m+[m
 .../common/text_track_font_style.dart.gcov.html    |  110 [32m+[m
 .../html/common/text_track_style.dart.gcov.html    |  232 [32m++[m
 .../common/text_track_window_type.dart.gcov.html   |  105 [32m+[m
 .../html/common/user_action.dart.gcov.html         |  115 [32m+[m
 .../html/common/user_action_state.dart.gcov.html   |  130 [32m+[m
 .../html/common/vast_ads_request.dart.gcov.html    |  132 [32m++[m
 .../coverage/html/common/volume.dart.gcov.html     |  132 [32m++[m
 .../coverage/html/emerald.png                      |  Bin [31m0[m -> [32m141[m bytes
 .../html/entities/break_status.dart.gcov.html      |  144 [32m++[m
 .../html/entities/cast_device.dart.gcov.html       |  131 [32m+[m
 .../html/entities/cast_media_status.dart.gcov.html |  154 [32m++[m
 .../html/entities/cast_options.dart.gcov.html      |  121 [32m+[m
 .../html/entities/cast_session.dart.gcov.html      |  109 [32m+[m
 .../entities/discovery_criteria.dart.gcov.html     |  139 [32m++[m
 .../html/entities/index-detail-sort-f.html         |  254 [32m++[m
 .../html/entities/index-detail-sort-l.html         |  254 [32m++[m
 .../coverage/html/entities/index-detail.html       |  254 [32m++[m
 .../coverage/html/entities/index-sort-f.html       |  197 [32m++[m
 .../coverage/html/entities/index-sort-l.html       |  197 [32m++[m
 .../coverage/html/entities/index.html              |  197 [32m++[m
 .../html/entities/load_options.dart.gcov.html      |  110 [32m+[m
 .../html/entities/media_information.dart.gcov.html |  233 [32m++[m
 .../cast_media_metadata.dart.gcov.html             |  101 [32m+[m
 .../generic_media_metadata.dart.gcov.html          |  122 [32m+[m
 .../media_metadata/index-detail-sort-f.html        |  152 [32m++[m
 .../media_metadata/index-detail-sort-l.html        |  152 [32m++[m
 .../html/entities/media_metadata/index-detail.html |  152 [32m++[m
 .../html/entities/media_metadata/index-sort-f.html |  143 [32m++[m
 .../html/entities/media_metadata/index-sort-l.html |  143 [32m++[m
 .../html/entities/media_metadata/index.html        |  143 [32m++[m
 .../movie_media_metadata.dart.gcov.html            |  137 [32m++[m
 .../music_track_media_metadata.dart.gcov.html      |  161 [32m++[m
 .../photo_media_metadata.dart.gcov.html            |  158 [32m++[m
 .../tv_show_media_metadata.dart.gcov.html          |  132 [32m++[m
 .../html/entities/media_seek_option.dart.gcov.html |  110 [32m+[m
 .../html/entities/queue_item.dart.gcov.html        |  131 [32m+[m
 .../coverage/html/entities/request.dart.gcov.html  |  111 [32m+[m
 .../coverage/html/entities/track.dart.gcov.html    |  163 [32m++[m
 .../coverage/html/enums/index-detail-sort-f.html   |  116 [32m+[m
 .../coverage/html/enums/index-detail-sort-l.html   |  116 [32m+[m
 .../coverage/html/enums/index-detail.html          |  116 [32m+[m
 .../coverage/html/enums/index-sort-f.html          |  107 [32m+[m
 .../coverage/html/enums/index-sort-l.html          |  107 [32m+[m
 .../coverage/html/enums/index.html                 |  107 [32m+[m
 .../html/enums/media_metadata_type.dart.gcov.html  |  107 [32m+[m
 .../coverage/html/enums/stream_type.dart.gcov.html |  105 [32m+[m
 flutter_google_cast-master/coverage/html/gcov.css  | 1125 [32m+++++++++[m
 flutter_google_cast-master/coverage/html/glass.png |  Bin [31m0[m -> [32m167[m bytes
 .../coverage/html/index-sort-f.html                |  233 [32m++[m
 .../coverage/html/index-sort-l.html                |  233 [32m++[m
 .../coverage/html/index.html                       |  233 [32m++[m
 .../android/android_cast_options.dart.gcov.html    |   95 [32m+[m
 .../android_media_information.dart.gcov.html       |  181 [32m++[m
 .../android/android_media_status.dart.gcov.html    |  131 [32m+[m
 .../android/android_queue_item.dart.gcov.html      |  109 [32m+[m
 .../html/models/android/cast_device.dart.gcov.html |  116 [32m+[m
 .../models/android/cast_session.dart.gcov.html     |  117 [32m+[m
 .../cast_media_player_state.dart.gcov.html         |   88 [32m+[m
 .../android/extensions/date_time.dart.gcov.html    |   89 [32m+[m
 .../android/extensions/idle_reason.dart.gcov.html  |   88 [32m+[m
 .../android/extensions/index-detail-sort-f.html    |  179 [32m++[m
 .../android/extensions/index-detail-sort-l.html    |  179 [32m++[m
 .../models/android/extensions/index-detail.html    |  179 [32m++[m
 .../models/android/extensions/index-sort-f.html    |  152 [32m++[m
 .../models/android/extensions/index-sort-l.html    |  152 [32m++[m
 .../html/models/android/extensions/index.html      |  152 [32m++[m
 .../android/extensions/repeat_mode.dart.gcov.html  |   88 [32m+[m
 .../android/extensions/stream_type.dart.gcov.html  |   88 [32m+[m
 .../extensions/text_track_type.dart.gcov.html      |   88 [32m+[m
 .../android/extensions/track_type.dart.gcov.html   |   88 [32m+[m
 .../html/models/android/index-detail-sort-f.html   |  176 [32m++[m
 .../html/models/android/index-detail-sort-l.html   |  176 [32m++[m
 .../coverage/html/models/android/index-detail.html |  176 [32m++[m
 .../coverage/html/models/android/index-sort-f.html |  143 [32m++[m
 .../coverage/html/models/android/index-sort-l.html |  143 [32m++[m
 .../coverage/html/models/android/index.html        |  143 [32m++[m
 .../models/android/metadata/generic.dart.gcov.html |  105 [32m+[m
 .../android/metadata/index-detail-sort-f.html      |  143 [32m++[m
 .../android/metadata/index-detail-sort-l.html      |  143 [32m++[m
 .../html/models/android/metadata/index-detail.html |  143 [32m++[m
 .../html/models/android/metadata/index-sort-f.html |  134 [32m++[m
 .../html/models/android/metadata/index-sort-l.html |  134 [32m++[m
 .../html/models/android/metadata/index.html        |  134 [32m++[m
 .../models/android/metadata/movie.dart.gcov.html   |  108 [32m+[m
 .../models/android/metadata/music.dart.gcov.html   |  116 [32m+[m
 .../models/android/metadata/photo.dart.gcov.html   |  108 [32m+[m
 .../models/android/metadata/tv_show.dart.gcov.html |  107 [32m+[m
 .../html/models/ios/index-detail-sort-f.html       |  194 [32m++[m
 .../html/models/ios/index-detail-sort-l.html       |  194 [32m++[m
 .../coverage/html/models/ios/index-detail.html     |  194 [32m++[m
 .../coverage/html/models/ios/index-sort-f.html     |  161 [32m++[m
 .../coverage/html/models/ios/index-sort-l.html     |  161 [32m++[m
 .../coverage/html/models/ios/index.html            |  161 [32m++[m
 .../html/models/ios/ios_cast_device.dart.gcov.html |  116 [32m+[m
 .../models/ios/ios_cast_options.dart.gcov.html     |  103 [32m+[m
 .../models/ios/ios_cast_queue_item.dart.gcov.html  |  118 [32m+[m
 .../models/ios/ios_cast_sessions.dart.gcov.html    |  115 [32m+[m
 .../ios/ios_media_information.dart.gcov.html       |  196 [32m++[m
 .../models/ios/ios_media_status.dart.gcov.html     |  136 [32m++[m
 .../html/models/ios/ios_media_track.dart.gcov.html |  115 [32m+[m
 .../html/models/ios/ios_request.dart.gcov.html     |  108 [32m+[m
 .../models/ios/metadata/generic.dart.gcov.html     |  103 [32m+[m
 .../models/ios/metadata/index-detail-sort-f.html   |  143 [32m++[m
 .../models/ios/metadata/index-detail-sort-l.html   |  143 [32m++[m
 .../html/models/ios/metadata/index-detail.html     |  143 [32m++[m
 .../html/models/ios/metadata/index-sort-f.html     |  134 [32m++[m
 .../html/models/ios/metadata/index-sort-l.html     |  134 [32m++[m
 .../coverage/html/models/ios/metadata/index.html   |  134 [32m++[m
 .../html/models/ios/metadata/movie.dart.gcov.html  |  106 [32m+[m
 .../html/models/ios/metadata/music.dart.gcov.html  |  114 [32m+[m
 .../html/models/ios/metadata/photo.dart.gcov.html  |  108 [32m+[m
 .../models/ios/metadata/tv_show.dart.gcov.html     |  105 [32m+[m
 flutter_google_cast-master/coverage/html/ruby.png  |  Bin [31m0[m -> [32m141[m bytes
 flutter_google_cast-master/coverage/html/snow.png  |  Bin [31m0[m -> [32m141[m bytes
 .../coverage/html/updown.png                       |  Bin [31m0[m -> [32m117[m bytes
 .../coverage/html/utils/extensions.dart.gcov.html  |  184 [32m++[m
 .../coverage/html/utils/functions.dart.gcov.html   |   97 [32m+[m
 .../coverage/html/utils/index-detail-sort-f.html   |  116 [32m+[m
 .../coverage/html/utils/index-detail-sort-l.html   |  116 [32m+[m
 .../coverage/html/utils/index-detail.html          |  116 [32m+[m
 .../coverage/html/utils/index-sort-f.html          |  107 [32m+[m
 .../coverage/html/utils/index-sort-l.html          |  107 [32m+[m
 .../coverage/html/utils/index.html                 |  107 [32m+[m
 .../html/widgets/cast_volume.dart.gcov.html        |  191 [32m++[m
 .../html/widgets/expanded_player.dart.gcov.html    | 1090 [32m+++++++++[m
 .../coverage/html/widgets/index-detail-sort-f.html |  125 [32m+[m
 .../coverage/html/widgets/index-detail-sort-l.html |  125 [32m+[m
 .../coverage/html/widgets/index-detail.html        |  125 [32m+[m
 .../coverage/html/widgets/index-sort-f.html        |  116 [32m+[m
 .../coverage/html/widgets/index-sort-l.html        |  116 [32m+[m
 .../coverage/html/widgets/index.html               |  116 [32m+[m
 .../html/widgets/mini_controller.dart.gcov.html    |  535 [32m+++++[m
 .../themes/google_cast_player_texts.dart.gcov.html |  129 [32m+[m
 .../themes/google_cast_player_theme.dart.gcov.html |  168 [32m++[m
 .../html/widgets/themes/index-detail-sort-f.html   |  122 [32m+[m
 .../html/widgets/themes/index-detail-sort-l.html   |  122 [32m+[m
 .../coverage/html/widgets/themes/index-detail.html |  122 [32m+[m
 .../coverage/html/widgets/themes/index-sort-f.html |  107 [32m+[m
 .../coverage/html/widgets/themes/index-sort-l.html |  107 [32m+[m
 .../coverage/html/widgets/themes/index.html        |  107 [32m+[m
 flutter_google_cast-master/coverage/lcov.info      | 2238 [32m+++++++++++++++++[m
 .../coverage/lcov_cleaned.info                     | 2505 [32m++++++++++++++++++++[m
 flutter_google_cast-master/ios/.gitignore          |   38 [32m+[m
 flutter_google_cast-master/ios/Assets/.gitkeep     |    0
 .../Classes/DiscoveryManagerMethodChannel.swift    |  159 [32m++[m
 .../Classes/Extensions/CastDeviceExtensions.swift  |   65 [32m+[m
 .../Classes/Extensions/CastImageExtensions.swift   |   22 [32m+[m
 .../Classes/Extensions/CastOptionsExtensions.swift |   97 [32m+[m
 .../Classes/Extensions/MediaInfoExtensions.swift   |   70 [32m+[m
 .../Extensions/MediaMetatadaExtensions.swift       |  130 [32m+[m
 .../Classes/Extensions/MediaStatusExtensions.swift |   32 [32m+[m
 .../ios/Classes/Extensions/MediaTrack.swift        |   64 [32m+[m
 .../ios/Classes/Extensions/QueuLoadOptions.swift   |   32 [32m+[m
 .../Classes/Extensions/QueueItemsExtensions.swift  |   45 [32m+[m
 .../ios/Classes/Extensions/RequestExtensions.swift |   32 [32m+[m
 .../Classes/Extensions/SeekOptionsExtensions.swift |   20 [32m+[m
 .../ios/Classes/Extensions/SessionExtensions.swift |   51 [32m+[m
 .../ios/Classes/GoogleCastPlugin.h                 |    4 [32m+[m
 .../ios/Classes/GoogleCastPlugin.m                 |   15 [32m+[m
 .../Classes/RemoteMediaClienteMethodChannel.swift  |  403 [32m++++[m
 .../ios/Classes/SessionManagerMethodChannel.swift  |  457 [32m++++[m
 .../ios/Classes/SessionMethodChannel.swift         |   87 [32m+[m
 .../ios/Classes/SwiftGoogleCastPlugin.swift        |  172 [32m++[m
 .../ios/flutter_chrome_cast.podspec                |   27 [32m+[m
 .../lib/_discovery_manager/_discovery_manager.dart |    4 [32m+[m
 .../android_discovery_manager.dart                 |  101 [32m+[m
 .../lib/_discovery_manager/discovery_manager.dart  |   26 [32m+[m
 .../discovery_manager_platform_interface.dart      |   36 [32m+[m
 .../_discovery_manager/ios_discovery_manager.dart  |   85 [32m+[m
 .../_google_cast_context/_google_cast_context.dart |    4 [32m+[m
 ...android_google_cast_context_method_channel.dart |   25 [32m+[m
 .../_google_cast_context/google_cast_context.dart  |   26 [32m+[m
 .../google_cast_context_platform_interface.dart    |   18 [32m+[m
 .../ios_google_cast_context_method_channel.dart    |   26 [32m+[m
 .../_remote_media_client/_remote_media_client.dart |    4 [32m+[m
 ...android_remote_media_client_method_channel.dart |  274 [32m+++[m
 .../ios_remote_media_client_method_channel.dart    |  234 [32m++[m
 .../_remote_media_client/remote_media_client.dart  |   27 [32m+[m
 .../remote_media_client_platform.dart              |  108 [32m+[m
 .../lib/_session_manager/_session_manager.dart     |    4 [32m+[m
 .../android_cast_session_manager.dart              |  106 [32m+[m
 .../lib/_session_manager/cast_session_manager.dart |   26 [32m+[m
 .../cast_session_manager_platform.dart             |  116 [32m+[m
 .../_session_manager/ios_cast_session_manager.dart |  100 [32m+[m
 flutter_google_cast-master/lib/cast_context.dart   |    6 [32m+[m
 flutter_google_cast-master/lib/common.dart         |    6 [32m+[m
 flutter_google_cast-master/lib/common/break.dart   |   76 [32m+[m
 .../lib/common/break_clips.dart                    |  142 [32m++[m
 .../lib/common/cast_status_event.dart              |   45 [32m+[m
 flutter_google_cast-master/lib/common/common.dart  |   18 [32m+[m
 .../lib/common/font_generic_family.dart            |   52 [32m+[m
 .../lib/common/hls_segment_format.dart             |   57 [32m+[m
 .../lib/common/hls_video_segment_format.dart       |   29 [32m+[m
 flutter_google_cast-master/lib/common/image.dart   |   45 [32m+[m
 .../lib/common/live_seekable_range.dart            |   83 [32m+[m
 .../lib/common/queue_data.dart                     |   67 [32m+[m
 .../lib/common/rfc5646_language.dart               |  725 [32m++++++[m
 .../lib/common/text_track_edge_type.dart           |   39 [32m+[m
 .../lib/common/text_track_font_style.dart          |   34 [32m+[m
 .../lib/common/text_track_style.dart               |  157 [32m++[m
 .../lib/common/text_track_window_type.dart         |   29 [32m+[m
 .../lib/common/user_action.dart                    |   39 [32m+[m
 .../lib/common/user_action_state.dart              |   54 [32m+[m
 .../lib/common/vast_ads_request.dart               |   56 [32m+[m
 flutter_google_cast-master/lib/common/volume.dart  |   56 [32m+[m
 flutter_google_cast-master/lib/discovery.dart      |    6 [32m+[m
 flutter_google_cast-master/lib/entities.dart       |    6 [32m+[m
 .../lib/entities/break_status.dart                 |   68 [32m+[m
 .../lib/entities/cast_device.dart                  |   55 [32m+[m
 .../lib/entities/cast_media_status.dart            |   78 [32m+[m
 .../lib/entities/cast_options.dart                 |   45 [32m+[m
 .../lib/entities/cast_session.dart                 |   33 [32m+[m
 .../lib/entities/discovery_criteria.dart           |   63 [32m+[m
 .../lib/entities/entities.dart                     |   13 [32m+[m
 .../lib/entities/load_options.dart                 |   34 [32m+[m
 .../lib/entities/media_information.dart            |  157 [32m++[m
 .../media_metadata/cast_media_metadata.dart        |   25 [32m+[m
 .../media_metadata/generic_media_metadata.dart     |   46 [32m+[m
 .../entities/media_metadata/media_metadata.dart    |    6 [32m+[m
 .../media_metadata/movie_media_metadata.dart       |   61 [32m+[m
 .../media_metadata/music_track_media_metadata.dart |   85 [32m+[m
 .../media_metadata/photo_media_metadata.dart       |   82 [32m+[m
 .../media_metadata/tv_show_media_metadata.dart     |   56 [32m+[m
 .../lib/entities/media_seek_option.dart            |   34 [32m+[m
 .../lib/entities/queue_item.dart                   |   55 [32m+[m
 .../lib/entities/request.dart                      |   35 [32m+[m
 flutter_google_cast-master/lib/entities/track.dart |   87 [32m+[m
 flutter_google_cast-master/lib/enums.dart          |    6 [32m+[m
 .../lib/enums/connection_state.dart                |   17 [32m+[m
 flutter_google_cast-master/lib/enums/enums.dart    |    9 [32m+[m
 .../lib/enums/idle_reason.dart                     |   20 [32m+[m
 .../lib/enums/media_metadata_type.dart             |   31 [32m+[m
 .../lib/enums/media_resume_state.dart              |   11 [32m+[m
 .../lib/enums/player_state.dart                    |   24 [32m+[m
 .../lib/enums/repeat_mode.dart                     |   25 [32m+[m
 .../lib/enums/stream_type.dart                     |   29 [32m+[m
 .../lib/enums/text_track_type.dart                 |   37 [32m+[m
 .../lib/enums/track_type.dart                      |   14 [32m+[m
 .../lib/flutter_chrome_cast.dart                   |   52 [32m+[m
 flutter_google_cast-master/lib/lib.dart            |   19 [32m+[m
 flutter_google_cast-master/lib/media.dart          |    6 [32m+[m
 flutter_google_cast-master/lib/models.dart         |    6 [32m+[m
 .../lib/models/android/android.dart                |    8 [32m+[m
 .../lib/models/android/android_cast_options.dart   |   19 [32m+[m
 .../models/android/android_media_information.dart  |  105 [32m+[m
 .../lib/models/android/android_media_status.dart   |   55 [32m+[m
 .../lib/models/android/android_queue_item.dart     |   33 [32m+[m
 .../lib/models/android/cast_device.dart            |   40 [32m+[m
 .../lib/models/android/cast_session.dart           |   41 [32m+[m
 .../extensions/cast_media_player_state.dart        |   12 [32m+[m
 .../lib/models/android/extensions/date_time.dart   |   13 [32m+[m
 .../lib/models/android/extensions/extensions.dart  |    7 [32m+[m
 .../lib/models/android/extensions/idle_reason.dart |   12 [32m+[m
 .../lib/models/android/extensions/repeat_mode.dart |   12 [32m+[m
 .../lib/models/android/extensions/stream_type.dart |   12 [32m+[m
 .../models/android/extensions/text_track_type.dart |   12 [32m+[m
 .../lib/models/android/extensions/track_type.dart  |   12 [32m+[m
 .../lib/models/android/metadata/generic.dart       |   29 [32m+[m
 .../lib/models/android/metadata/metadata.dart      |    5 [32m+[m
 .../lib/models/android/metadata/movie.dart         |   32 [32m+[m
 .../lib/models/android/metadata/music.dart         |   40 [32m+[m
 .../lib/models/android/metadata/photo.dart         |   32 [32m+[m
 .../lib/models/android/metadata/tv_show.dart       |   31 [32m+[m
 flutter_google_cast-master/lib/models/ios/ios.dart |    7 [32m+[m
 .../lib/models/ios/ios_cast_device.dart            |   40 [32m+[m
 .../lib/models/ios/ios_cast_options.dart           |   27 [32m+[m
 .../lib/models/ios/ios_cast_queue_item.dart        |   42 [32m+[m
 .../lib/models/ios/ios_cast_sessions.dart          |   39 [32m+[m
 .../lib/models/ios/ios_media_information.dart      |  120 [32m+[m
 .../lib/models/ios/ios_media_status.dart           |   60 [32m+[m
 .../lib/models/ios/ios_media_track.dart            |   39 [32m+[m
 .../lib/models/ios/ios_request.dart                |   32 [32m+[m
 .../lib/models/ios/metadata/generic.dart           |   27 [32m+[m
 .../lib/models/ios/metadata/metadata.dart          |    5 [32m+[m
 .../lib/models/ios/metadata/movie.dart             |   30 [32m+[m
 .../lib/models/ios/metadata/music.dart             |   38 [32m+[m
 .../lib/models/ios/metadata/photo.dart             |   32 [32m+[m
 .../lib/models/ios/metadata/tv_show.dart           |   29 [32m+[m
 flutter_google_cast-master/lib/models/models.dart  |    2 [32m+[m
 flutter_google_cast-master/lib/session.dart        |    6 [32m+[m
 flutter_google_cast-master/lib/themes.dart         |    4 [32m+[m
 flutter_google_cast-master/lib/utils.dart          |    7 [32m+[m
 .../lib/utils/extensions.dart                      |  108 [32m+[m
 .../lib/utils/functions.dart                       |   21 [32m+[m
 flutter_google_cast-master/lib/widgets.dart        |    8 [32m+[m
 .../lib/widgets/cast_volume.dart                   |  115 [32m+[m
 .../lib/widgets/expanded_player.dart               | 1014 [32m++++++++[m
 .../lib/widgets/mini_controller.dart               |  459 [32m++++[m
 .../widgets/themes/google_cast_player_texts.dart   |   53 [32m+[m
 .../widgets/themes/google_cast_player_theme.dart   |   92 [32m+[m
 flutter_google_cast-master/pigeon.zsh              |    8 [32m+[m
 flutter_google_cast-master/pubspec.yaml            |   37 [32m+[m
 .../scripts/fix_android_build.sh                   |   90 [32m+[m
 .../scripts/quick_coverage.sh                      |   48 [32m+[m
 flutter_google_cast-master/scripts/run_coverage.sh |  142 [32m++[m
 .../scripts/test_enforcement.sh                    |   92 [32m+[m
 ios/Flutter/AppFrameworkInfo.plist                 |   26 [32m+[m
 ios/Flutter/Debug.xcconfig                         |    2 [32m+[m
 ios/Flutter/Generated.xcconfig                     |   14 [32m+[m
 ios/Flutter/Release.xcconfig                       |    2 [32m+[m
 ios/Flutter/ephemeral/flutter_lldb_helper.py       |   32 [32m+[m
 ios/Flutter/ephemeral/flutter_lldbinit             |    5 [32m+[m
 ios/Flutter/flutter_export_environment.sh          |   13 [32m+[m
 .../Info.plist                                     |   31 [32m+[m
 .../NotificationService.swift                      |   29 [32m+[m
 ios/Podfile                                        |   85 [32m+[m
 ios/Runner.xcodeproj/project.pbxproj               |  870 [32m+++++++[m
 .../project.xcworkspace/contents.xcworkspacedata   |    7 [32m+[m
 .../xcshareddata/IDEWorkspaceChecks.plist          |    8 [32m+[m
 .../xcshareddata/WorkspaceSettings.xcsettings      |    8 [32m+[m
 .../xcshareddata/xcschemes/Runner.xcscheme         |   90 [32m+[m
 .../xcschemes/xcschememanagement.plist             |   19 [32m+[m
 .../xcschemes/xcschememanagement.plist             |   19 [32m+[m
 ios/Runner.xcworkspace/contents.xcworkspacedata    |   10 [32m+[m
 .../xcshareddata/IDEWorkspaceChecks.plist          |    8 [32m+[m
 .../xcshareddata/WorkspaceSettings.xcsettings      |    8 [32m+[m
 .../UserInterfaceState.xcuserstate                 |  Bin [31m0[m -> [32m35199[m bytes
 .../UserInterfaceState.xcuserstate                 |  Bin [31m0[m -> [32m127384[m bytes
 ios/Runner/AppDelegate.swift                       |   16 [32m+[m
 .../AppIcon.appiconset/Contents.json               |  122 [32m+[m
 .../AppIcon.appiconset/Icon-App-20x20@1x.png       |  Bin [31m0[m -> [32m810[m bytes
 .../AppIcon.appiconset/Icon-App-20x20@2x.png       |  Bin [31m0[m -> [32m2040[m bytes
 .../AppIcon.appiconset/Icon-App-20x20@3x.png       |  Bin [31m0[m -> [32m3289[m bytes
 .../AppIcon.appiconset/Icon-App-29x29@1x.png       |  Bin [31m0[m -> [32m1314[m bytes
 .../AppIcon.appiconset/Icon-App-29x29@2x.png       |  Bin [31m0[m -> [32m3142[m bytes
 .../AppIcon.appiconset/Icon-App-29x29@3x.png       |  Bin [31m0[m -> [32m5091[m bytes
 .../AppIcon.appiconset/Icon-App-40x40@1x.png       |  Bin [31m0[m -> [32m2040[m bytes
 .../AppIcon.appiconset/Icon-App-40x40@2x.png       |  Bin [31m0[m -> [32m4605[m bytes
 .../AppIcon.appiconset/Icon-App-40x40@3x.png       |  Bin [31m0[m -> [32m7135[m bytes
 .../AppIcon.appiconset/Icon-App-60x60@2x.png       |  Bin [31m0[m -> [32m7135[m bytes
 .../AppIcon.appiconset/Icon-App-60x60@3x.png       |  Bin [31m0[m -> [32m10882[m bytes
 .../AppIcon.appiconset/Icon-App-76x76@1x.png       |  Bin [31m0[m -> [32m4411[m bytes
 .../AppIcon.appiconset/Icon-App-76x76@2x.png       |  Bin [31m0[m -> [32m9230[m bytes
 .../AppIcon.appiconset/Icon-App-83.5x83.5@2x.png   |  Bin [31m0[m -> [32m10094[m bytes
 .../AppIcon.appiconset/ItunesArtwork@2x.png        |  Bin [31m0[m -> [32m29139[m bytes
 .../LaunchImage.imageset/Contents.json             |   23 [32m+[m
 .../LaunchImage.imageset/LaunchImage.png           |  Bin [31m0[m -> [32m68[m bytes
 .../LaunchImage.imageset/LaunchImage@2x.png        |  Bin [31m0[m -> [32m68[m bytes
 .../LaunchImage.imageset/LaunchImage@3x.png        |  Bin [31m0[m -> [32m68[m bytes
 .../Assets.xcassets/LaunchImage.imageset/README.md |    5 [32m+[m
 ios/Runner/Base.lproj/LaunchScreen.storyboard      |   37 [32m+[m
 ios/Runner/Base.lproj/Main.storyboard              |   26 [32m+[m
 ios/Runner/GeneratedPluginRegistrant.h             |   19 [32m+[m
 ios/Runner/GeneratedPluginRegistrant.m             |  301 [32m+++[m
 ios/Runner/Info.plist                              |  115 [32m+[m
 ios/Runner/Runner-Bridging-Header.h                |    1 [32m+[m
 ios/Runner/Runner.entitlements                     |   24 [32m+[m
 lib/TODO                                           |    0
 lib/app_theme.dart                                 |   82 [32m+[m
 lib/components/CircularButton.dart                 |   50 [32m+[m
 lib/components/DietDisclaimerView.dart             |  118 [32m+[m
 lib/components/FullScreenDialogContent.dart        |  571 [32m+++++[m
 lib/components/HtmlWidget.dart                     |  231 [32m++[m
 lib/components/PdfViewWidget.dart                  |  178 [32m++[m
 lib/components/VimeoEmbedWidget.dart               |   34 [32m+[m
 lib/components/YouTubeEmbededWidget.dart           |   27 [32m+[m
 lib/components/adMob_component.dart                |   90 [32m+[m
 lib/components/blog_component.dart                 |  114 [32m+[m
 lib/components/bmi_component.dart                  |  106 [32m+[m
 lib/components/bmr_component.dart                  |  100 [32m+[m
 lib/components/body_part_component.dart            |   62 [32m+[m
 lib/components/chat_message_Image_widget.dart      |  145 [32m++[m
 lib/components/chat_message_widget.dart            |  123 [32m+[m
 lib/components/count_down_progress_indicator.dart  |  163 [32m++[m
 lib/components/count_down_progress_indicator1.dart |  182 [32m++[m
 lib/components/diet_category_component.dart        |   54 [32m+[m
 lib/components/double_back_to_close_app.dart       |   72 [32m+[m
 lib/components/equipment_component.dart            |  119 [32m+[m
 lib/components/exercise_component.dart             |  105 [32m+[m
 lib/components/exercise_day_component.dart         |  104 [32m+[m
 lib/components/featured_blog_component.dart        |   45 [32m+[m
 lib/components/featured_diet_component.dart        |  221 [32m++[m
 lib/components/filter_workout_bottomsheet.dart     |  256 [32m++[m
 lib/components/horizontal_bar_chart.dart           |   76 [32m+[m
 lib/components/html_youtube_player.dart            |  172 [32m++[m
 lib/components/ideal_weight_component.dart         |  112 [32m+[m
 lib/components/level_component.dart                |   38 [32m+[m
 lib/components/notification_utils.dart             |  129 [32m+[m
 lib/components/permission.dart                     |   67 [32m+[m
 lib/components/product_category_component.dart     |   56 [32m+[m
 lib/components/product_component.dart              |   40 [32m+[m
 lib/components/progress_component.dart             |  238 [32m++[m
 lib/components/scheduled_component.dart            |  162 [32m++[m
 .../search_categorywise_bottomsheet.dart           |  306 [32m+++[m
 lib/components/sign_up_step1_component.dart        |  259 [32m++[m
 lib/components/sign_up_step2_component.dart        |  113 [32m+[m
 lib/components/sign_up_step3_component.dart        |  108 [32m+[m
 lib/components/sign_up_step4_component.dart        |  394 [32m+++[m
 lib/components/step_count_component.dart           |  170 [32m++[m
 lib/components/tab_payment.dart                    |  197 [32m++[m
 lib/components/theme_selection_dialog.dart         |   94 [32m+[m
 lib/components/video_component.dart                |   51 [32m+[m
 lib/components/workout_component.dart              |  149 [32m++[m
 lib/extensions/LiveStream.dart                     |  129 [32m+[m
 .../animatedList/animated_configurations.dart      |  751 [32m++++++[m
 .../animatedList/animated_list_view.dart           |  164 [32m++[m
 .../animatedList/animated_scroll_view.dart         |  143 [32m++[m
 lib/extensions/animatedList/animated_wrap.dart     |  109 [32m+[m
 lib/extensions/app_button.dart                     |  135 [32m++[m
 lib/extensions/app_text_field.dart                 |  359 [32m+++[m
 lib/extensions/colors.dart                         |  235 [32m++[m
 lib/extensions/common.dart                         |  371 [32m+++[m
 lib/extensions/confirmation_dialog.dart            |  440 [32m++++[m
 lib/extensions/constants.dart                      |   82 [32m+[m
 lib/extensions/date_time_extensions.dart           |   89 [32m+[m
 lib/extensions/decorations.dart                    |  217 [32m++[m
 lib/extensions/dotted_border_widget.dart           |  103 [32m+[m
 lib/extensions/double_press_back_widget.dart       |   39 [32m+[m
 lib/extensions/extension_util/bool_extensions.dart |    5 [32m+[m
 .../extension_util/color_extensions.dart           |   30 [32m+[m
 .../extension_util/context_extensions.dart         |  105 [32m+[m
 .../extension_util/date_time_extensions.dart       |   71 [32m+[m
 .../extension_util/device_extensions.dart          |   43 [32m+[m
 .../extension_util/double_extensions.dart          |   19 [32m+[m
 .../extension_util/duration_extensions.dart        |    7 [32m+[m
 lib/extensions/extension_util/int_extensions.dart  |  163 [32m++[m
 lib/extensions/extension_util/list_extensions.dart |   50 [32m+[m
 lib/extensions/extension_util/num_extensions.dart  |    5 [32m+[m
 lib/extensions/extension_util/pattern.dart         |   38 [32m+[m
 .../extension_util/scroll_extensions.dart          |   37 [32m+[m
 .../extension_util/string_extensions.dart          |  292 [32m+++[m
 .../extension_util/widget_extensions.dart          |  360 [32m+++[m
 lib/extensions/horizontal_list.dart                |   53 [32m+[m
 lib/extensions/hover_widget.dart                   |   39 [32m+[m
 lib/extensions/html_widget.dart                    |  266 [32m+++[m
 lib/extensions/loader_widget.dart                  |   69 [32m+[m
 lib/extensions/otp_text_field.dart                 |  171 [32m++[m
 lib/extensions/placeholder_widget.dart             |   55 [32m+[m
 lib/extensions/read_more_text.dart                 |  186 [32m++[m
 lib/extensions/setting_item_widget.dart            |   91 [32m+[m
 lib/extensions/shared_pref.dart                    |   69 [32m+[m
 lib/extensions/size_config.dart                    |   16 [32m+[m
 lib/extensions/system_utils.dart                   |  155 [32m++[m
 lib/extensions/text_styles.dart                    |  139 [32m++[m
 lib/extensions/time_formatter.dart                 |  100 [32m+[m
 lib/extensions/widgets.dart                        |  253 [32m++[m
 lib/languageConfiguration/AppLocalizations.dart    |   24 [32m+[m
 lib/languageConfiguration/BaseLanguage.dart        |  461 [32m++++[m
 .../LanguageDataConstant.dart                      |  153 [32m++[m
 lib/languageConfiguration/LanguageDefaultJson.dart |    7 [32m+[m
 .../LocalLanguageResponse.dart                     |   30 [32m+[m
 .../ServerLanguageResponse.dart                    |  112 [32m+[m
 lib/logic/game_data.dart                           |   51 [32m+[m
 lib/main.dart                                      |  214 [32m++[m
 lib/models/FitBotListResponse.dart                 |   51 [32m+[m
 lib/models/FitBotSaveDataResponse.dart             |   15 [32m+[m
 lib/models/GameResponse.dart                       |   60 [32m+[m
 lib/models/PostDetailsModel.dart                   |   19 [32m+[m
 lib/models/ScheduledResponse.dart                  |  112 [32m+[m
 lib/models/app_configuration_response.dart         |  126 [32m+[m
 lib/models/app_setting_response.dart               |  166 [32m++[m
 lib/models/base_response.dart                      |   33 [32m+[m
 lib/models/blog_detail_response.dart               |   19 [32m+[m
 lib/models/blog_response.dart                      |  130 [32m+[m
 lib/models/body_part_response.dart                 |   77 [32m+[m
 lib/models/bookmark_post_detail_response.dart      |   74 [32m+[m
 lib/models/bottom_bar_item_model.dart              |    7 [32m+[m
 lib/models/category_diet_response.dart             |   73 [32m+[m
 lib/models/comment_List_reponse.dart               |  133 [32m++[m
 lib/models/dashboard_response.dart                 |  225 [32m++[m
 lib/models/day_exercise_response.dart              |  180 [32m++[m
 lib/models/diet_response.dart                      |  120 [32m+[m
 lib/models/equipment_response.dart                 |   73 [32m+[m
 lib/models/exercise_detail_response.dart           |  177 [32m++[m
 lib/models/exercise_response.dart                  |  139 [32m++[m
 lib/models/gender_response.dart                    |    7 [32m+[m
 lib/models/get_setting_response.dart               |   79 [32m+[m
 lib/models/graph_response.dart                     |   72 [32m+[m
 lib/models/language_data_model.dart                |   51 [32m+[m
 lib/models/level_response.dart                     |   74 [32m+[m
 lib/models/login_response.dart                     |  143 [32m++[m
 lib/models/models.dart                             |  231 [32m++[m
 lib/models/notification_response.dart              |   97 [32m+[m
 lib/models/pagination_model.dart                   |   25 [32m+[m
 lib/models/payment_list_model.dart                 |  167 [32m++[m
 lib/models/post_details_response.dart              |  169 [32m++[m
 lib/models/product_category_response.dart          |   64 [32m+[m
 lib/models/product_response.dart                   |   88 [32m+[m
 lib/models/progress_setting_model.dart             |   24 [32m+[m
 lib/models/question_answer_model.dart              |   29 [32m+[m
 lib/models/register_request.dart                   |   54 [32m+[m
 lib/models/reminder_model.dart                     |   37 [32m+[m
 lib/models/social_login_response.dart              |  100 [32m+[m
 lib/models/stripe_pay_model.dart                   |  236 [32m++[m
 lib/models/subscribePlan_response.dart             |  184 [32m++[m
 lib/models/subscribe_package_response.dart         |   18 [32m+[m
 lib/models/subscription_response.dart              |   80 [32m+[m
 lib/models/user_response.dart                      |  187 [32m++[m
 lib/models/walk_through_model.dart                 |    6 [32m+[m
 lib/models/workout_detail_response.dart            |  140 [32m++[m
 lib/models/workout_response.dart                   |   31 [32m+[m
 lib/models/workout_type_response.dart              |   61 [32m+[m
 lib/network/network_utils.dart                     |  156 [32m++[m
 lib/network/rest_api.dart                          |  581 [32m+++++[m
 lib/pages/LeaderboardBottomSheet.dart              |  226 [32m++[m
 lib/pages/game/game.dart                           |  544 [32m+++++[m
 lib/pages/home/game_home_screen.dart               |  178 [32m++[m
 lib/routes.dart                                    |   24 [32m+[m
 lib/screens/Schedule_Screen.dart                   |  183 [32m++[m
 lib/screens/about_app_screen.dart                  |   39 [32m+[m
 lib/screens/about_us_screen.dart                   |  137 [32m++[m
 lib/screens/add_post_screen.dart                   |  718 [32m++++++[m
 lib/screens/assign_screen.dart                     |   78 [32m+[m
 lib/screens/blog_detail_screen.dart                |  273 [32m+++[m
 lib/screens/blog_screen.dart                       |  279 [32m+++[m
 lib/screens/bookmark_screen.dart                   | 1625 [32m+++++++++++++[m
 lib/screens/castTester.dart                        |  321 [32m+++[m
 lib/screens/change_pwd_screen.dart                 |  143 [32m++[m
 lib/screens/chatbot_Image_empty_screen.dart        |   83 [32m+[m
 lib/screens/chatbot_empty_screen.dart              |   85 [32m+[m
 lib/screens/chatting_image_screen.dart             |  429 [32m++++[m
 lib/screens/chatting_screen.dart                   |  248 [32m++[m
 lib/screens/chewie_screen.dart                     |  101 [32m+[m
 lib/screens/community_screen.dart                  | 1350 [32m+++++++++++[m
 lib/screens/dashboard_screen.dart                  |  537 [32m+++++[m
 lib/screens/diet_detail_screen.dart                |  348 [32m+++[m
 lib/screens/diet_screen.dart                       |  300 [32m+++[m
 lib/screens/edit_profile_screen.dart               |  824 [32m+++++++[m
 lib/screens/exercise_detail_screen.dart            |  553 [32m+++++[m
 lib/screens/exercise_duration_screen.dart          | 1040 [32m++++++++[m
 lib/screens/exercise_duration_screencast.dart      | 1021 [32m++++++++[m
 lib/screens/exercise_list_screen.dart              |  188 [32m++[m
 lib/screens/favourite_screen.dart                  |  108 [32m+[m
 lib/screens/filter_workout_screen.dart             |  537 [32m+++++[m
 lib/screens/forgot_pwd_screen.dart                 |   83 [32m+[m
 lib/screens/home_screen.dart                       |  446 [32m++++[m
 lib/screens/language_screen.dart                   |   95 [32m+[m
 lib/screens/main_goal_screen.dart                  |  376 [32m+++[m
 lib/screens/no_data_screen.dart                    |   43 [32m+[m
 lib/screens/no_internet_screen.dart                |   24 [32m+[m
 lib/screens/notification_screen.dart               |  150 [32m++[m
 lib/screens/otp_screen.dart                        |  142 [32m++[m
 lib/screens/payment_scheduled_screen.dart          |  984 [32m++++++++[m
 lib/screens/payment_screen.dart                    | 1107 [32m+++++++++[m
 lib/screens/post_details_screen.dart               | 1212 [32m++++++++++[m
 lib/screens/privacy_policy_screen.dart             |   23 [32m+[m
 lib/screens/product_detail_screen.dart             |  142 [32m++[m
 lib/screens/product_screen.dart                    |  230 [32m++[m
 lib/screens/profile_screen.dart                    |  310 [32m+++[m
 lib/screens/progress_detail_screen.dart            |  338 [32m+++[m
 lib/screens/progress_screen.dart                   |  250 [32m++[m
 lib/screens/progress_setting_screen.dart           |   93 [32m+[m
 lib/screens/reminder_screen.dart                   |  110 [32m+[m
 lib/screens/search_screen.dart                     |  414 [32m++++[m
 lib/screens/set_reminder_screen.dart               |  442 [32m++++[m
 lib/screens/setting_screen.dart                    |   98 [32m+[m
 lib/screens/sign_in_screen.dart                    |  363 [32m+++[m
 lib/screens/sign_up_screen.dart                    |   99 [32m+[m
 lib/screens/splash_screen.dart                     |  132 [32m++[m
 lib/screens/subscribe_screen.dart                  |  348 [32m+++[m
 lib/screens/subscription_detail_screen.dart        |  553 [32m+++++[m
 lib/screens/terms_and_conditions_screen.dart       |   23 [32m+[m
 lib/screens/tips_screen.dart                       |  128 [32m+[m
 lib/screens/verify_otp_screen.dart                 |  181 [32m++[m
 lib/screens/video_detail_screen.dart               |   32 [32m+[m
 lib/screens/video_screen.dart                      |   84 [32m+[m
 lib/screens/view_all_blog_screen.dart              |  108 [32m+[m
 lib/screens/view_all_diet.dart                     |  125 [32m+[m
 lib/screens/view_all_product_screen.dart           |  119 [32m+[m
 lib/screens/view_body_part_screen.dart             |  122 [32m+[m
 lib/screens/view_diet_category_screen.dart         |  100 [32m+[m
 lib/screens/view_equipment_screen.dart             |  112 [32m+[m
 lib/screens/view_level_screen.dart                 |  107 [32m+[m
 lib/screens/view_product_category_screen.dart      |   95 [32m+[m
 lib/screens/view_workouts_screen.dart              |  114 [32m+[m
 lib/screens/walk_through_screen.dart               |  129 [32m+[m
 lib/screens/web_view_screen.dart                   |  207 [32m++[m
 lib/screens/workout_detail_screen.dart             |  410 [32m++++[m
 lib/screens/workout_history_screen.dart            |   81 [32m+[m
 lib/screens/youtube_player_screen.dart             |  264 [32m+++[m
 lib/service/UpdateAvailablePopUp.dart              |  119 [32m+[m
 lib/service/VersionServices.dart                   |  100 [32m+[m
 lib/service/auth_service.dart                      |  316 [32m+++[m
 lib/service/base_service.dart                      |   66 [32m+[m
 lib/service/user_service.dart                      |  148 [32m++[m
 lib/store/NotificationStore/NotificationStore.dart |   47 [32m+[m
 .../NotificationStore/NotificationStore.g.dart     |   83 [32m+[m
 lib/store/UserStore/UserStore.dart                 |  534 [32m+++++[m
 lib/store/UserStore/UserStore.g.dart               | 1401 [32m+++++++++++[m
 lib/store/app_store.dart                           |  125 [32m+[m
 lib/store/app_store.g.dart                         |  269 [32m+++[m
 lib/utils/AppButtonWidget.dart                     |  134 [32m++[m
 lib/utils/CastManager.dart                         |  123 [32m+[m
 lib/utils/SliderCustomTrackShape.dart              |   18 [32m+[m
 lib/utils/WeightCalculator.dart                    |   16 [32m+[m
 lib/utils/_storeFirstTimeOpen.dart                 |   11 [32m+[m
 lib/utils/app_colors.dart                          |   36 [32m+[m
 lib/utils/app_common.dart                          |  425 [32m++++[m
 lib/utils/app_config.dart                          |  135 [32m++[m
 lib/utils/app_constants.dart                       |  215 [32m++[m
 lib/utils/app_images.dart                          |  117 [32m+[m
 lib/utils/shared_import.dart                       |  317 [32m+++[m
 lib/widget/custome_height_picker.dart              |  110 [32m+[m
 lib/widget/height_Slider_Internal.dart             |  121 [32m+[m
 lib/widget/height_picker.dart                      |  212 [32m++[m
 lib/widget/weight_widget.dart                      |  442 [32m++++[m
 pubspec.lock                                       | 2416 [32m+++++++++++++++++++[m
 pubspec.yaml                                       |    4 [32m+[m[31m-[m
 929 files changed, 106340 insertions(+), 6 deletions(-)
