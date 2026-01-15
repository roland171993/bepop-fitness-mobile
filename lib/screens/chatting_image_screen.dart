import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

import '../utils/shared_import.dart';

int? selectedImageIndex = -1;
bool? isLoading = false;
List<QuestionImageAnswerModel> questionAnswers = [];
List<Map<String, dynamic>> myMessages = [];

class ChattingImageScreen extends StatefulWidget {
  static String tag = '/chatgpt';

  final bool isDirect;

  ChattingImageScreen({this.isDirect = false});

  @override
  _ChattingImageScreenState createState() => _ChattingImageScreenState();
}

class _ChattingImageScreenState extends State<ChattingImageScreen> {
  // ChatGpt chatGpt = ChatGpt(apiKey: userStore.chatGptApiKey);

  ScrollController scrollController = ScrollController();

  TextEditingController msgController = TextEditingController();

  StreamSubscription<StreamCompletionResponse>? streamSubscription;

  int adCount = 0;
  int selectedIndex = -1;

  String lastError = "";
  String imageSelected = "";
  String lastStatus = "";
  String selectedText = '';
  String firstQuestion = '';
  String question = '';

  bool isBannerLoad = false;
  bool isShowOption = false;
  bool isSelectedIndex = false;
  bool isScroll = false;
  bool showResponse = false;
  List<String> foundWords = [];

  late OpenAI openAI;
//  late FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();

    Future.value().then((_) {
     // voiceMSG();
      openAI = OpenAI.instance.build(
          token: userStore.chatGptApiKey,
          baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20), connectTimeout: const Duration(seconds: 20)),
          enableLog: true);

      print("-----------------82>>>>${isFirstTime}");
      if (isFirstTime == false || isFirstTime == null) {
        firstQuestion =
            "my gender is ${userStore.gender.validate()}, my age is ${userStore.age.validate()}, my weight is${userStore.weight.validate()}${userStore.weightUnit.validate()}, my height is ${userStore.height.validate()}${userStore.heightUnit.validate()}, ${selectMainGoal}, ${selectExperienced},${selectEquipments},${selectWeekWorkout} please schedule my workout?";
        sendAutoFirstMsg(firstQuestion);
      }

      init();
    });
  }


/*  void voiceMSG() {
    flutterTts = FlutterTts();
    flutterTts.awaitSpeakCompletion(true);
  }*/

  Future<void> setFitBotDataApiCall(String? question, String? answer) async {
  //  speakLongText(answer??'');
    appStore.setLoading(true);
    Map req = {"question": question, "answer": answer};
    await saveFitBotData(req).then((value) async {}).catchError((e) {
      appStore.setLoading(false);
      print(e.toString());
    });
  }

/*  Future<void> speakLongText(String text) async {
    const int chunkSize = 200;
    List<String> chunks = _splitTextIntoChunks(text, chunkSize);

    for (String chunk in chunks) {
      await flutterTts.speak(chunk);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  List<String> _splitTextIntoChunks(String text, int chunkSize) {
    final List<String> chunks = [];
    for (int i = 0; i < text.length; i += chunkSize) {
      chunks.add(text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
    return chunks;
  }*/

  Future<void> deleteFitBotDataApiCall() async {
    appStore.setLoading(true);
    await deleteFitBotData().then((value) async {
      questionAnswers.clear();
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      print(e.toString());
    });
  }

  void init() async {
    hideKeyboard(context);
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void sendAutoFirstMsg(String? questions) async {
    isLoading=true;

    hideKeyboard(context);
    showResponse = true;
    questionAnswers.insert(0, QuestionImageAnswerModel(question: '', imageUri: imageSelected, answer: StringBuffer(), isLoading: true, smartCompose: selectedText));
    setState(() {});
    myMessages.add({"role": "user", "content": "${question}"});

/*    final request = await ChatCompleteText(
      messages: [
        {'role': 'system', 'content': 'Answer only workout-related questions.'},
        {'role': 'system', 'content': 'Answer only diet-related questions.'},
        {'role': 'system', 'content': 'Answer only exercise-related questions.'},
        {'role': 'system', 'content': 'Answer only weight-related questions.'},
        {'role': 'system', 'content': 'Answer only height-related questions.'},
        {'role': 'system', 'content': 'Answer only yoga-related questions.'},
        {'role': 'system', 'content': 'Answer only fitness-related questions.'},
        {'role': 'system', 'content': 'Answer only health-related questions.'},
        {'role': 'system', 'content': 'Answer only periods-related questions.'},
        {'role': 'system', 'content': 'Answer only body-related questions.'},
        {'role': 'system', 'content': 'Answer only skin-related questions.'},
        {"role": "user", "content": questions}
      ],
      maxToken: 350,
      model: Gpt4ChatModel(),
    );*/
    final request = ChatCompleteText(
      messages: myMessages,
      maxToken: 350,
      model: Gpt4ChatModel(),
    );

    await _streamResponse(request);
    await setFirstTimeOpen(isFirstTime = true);
    print("------------------>>>>${isFirstTime}");
    isFirstTime = await getFirstTimeOpen();
    print("------------------>>>>----${isFirstTime}");

    isLoading=false;
    questionAnswers[0].isLoading = false;
    showResponse = false;
    setState(() {});
  }

  void sendMessage() async {
    showResponse = true;
    isLoading=true;
    hideKeyboard(context);
    if (selectedText.isNotEmpty) {
      question = selectedText + msgController.text;
      setState(() {});
    } else {
      question = msgController.text;
      setState(() {});
    }
    msgController.clear();
    /* for (var word in foundString) {
      if (question.contains(word)) {
        foundWords.add(word);
      }
    }*/
    questionAnswers.insert(0, QuestionImageAnswerModel(question: question, imageUri: imageSelected, answer: StringBuffer(), isLoading: true, smartCompose: selectedText));

    /*if (foundWords.isNotEmpty) {
      questionAnswers.insert(0, QuestionImageAnswerModel(question: question, imageUri: imageSelected, answer: StringBuffer(), isLoading: true, smartCompose: selectedText));
    } else {
      showResponse = false;
      isLoading=false;
      Fluttertoast.showToast(
          msg: 'Please only Work outs,Diet,Exercise,Health related Ask for an answer',
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.black,
          backgroundColor: GreyLightColor,
          gravity: ToastGravity.CENTER);
      return;
    }*/

    setState(() {});
    myMessages.add({"role": "user", "content": "${question}"});
    final request = ChatCompleteText(
      messages: myMessages,
      maxToken: 250,
      model: Gpt4ChatModel(),
    );

    await _streamResponse(request);

    isLoading=false;

    questionAnswers[0].isLoading = false;
    showResponse = false;

    setState(() {});
  }


  Future<dynamic> _streamResponse(ChatCompleteText request) async {
    streamSubscription?.cancel();

    try {
      final stream = await openAI.onChatCompletion(request: request);
      myMessages.add({"role": "assistant", "content": "${stream?.choices.first.message?.content}"});
      stream?.choices.forEach((data) {
        questionAnswers.first.answer!.write(data.message?.content);
        setFitBotDataApiCall(question, data.message?.content);
      });
      imageSelected = '';
      selectedImageIndex = -1;
      isLoading=false;
    } catch (error) {
      isLoading=false;
      questionAnswers.first.answer!.write("Too many requests please try again");
      imageSelected = '';
      selectedImageIndex = -1;
      log("Error occurred: $error");
      setState(() {});
    }
  }

  void showDialog() {
    showConfirmDialogCustom(
      context,
      title: languages.lblChatConfirmMsg,
      positiveText: languages.lblYes,
      positiveTextColor: Colors.white,
      image: ic_logo,
      negativeText: languages.lblNo,
      dialogType: DialogType.CONFIRMATION,
      onAccept: (p0) {
        deleteFitBotDataApiCall();
      },
    );
  }

  void share(BuildContext context, {required List<QuestionImageAnswerModel> questionAnswers, RenderBox? box}) {
    String getFinalString = questionAnswers.map((e) => "Q: ${e.question}\nChatGPT: ${e.answer.toString().trim()}\n\n").join(' ');
    Share.share(getFinalString, sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void dispose() {
    msgController.dispose();
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblFitBot, context: context, actions: [
        IconButton(
          onPressed: () {
            showDialog();
          },
          icon: Icon(Icons.restart_alt, color: appStore.isDarkMode ? Colors.white : Colors.black),
          tooltip: languages.lblClearConversion,
        ).visible(questionAnswers.isNotEmpty),
      ]),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: context.height(),
            width: context.width(),
            margin: EdgeInsets.only(bottom: 66 + (isShowOption ? 50 : 0)),
            padding: EdgeInsets.only(left: 16, right: 16),
            child: ListView.separated(
              separatorBuilder: (_, i) => Divider(color: Colors.transparent),
              reverse: true,
              padding: EdgeInsets.only(bottom: 8, top: 16),
              controller: scrollController,
              itemCount: questionAnswers.length,
              itemBuilder: (_, index) {
                QuestionImageAnswerModel data = questionAnswers[index];
                print("----------287>>>>${data.question}");
                return ChatMessageImageWidget(answer: data.answer.toString().trim(), data: data, isLoading: data.isLoading.validate(), firstQuestion: firstQuestion);
              },
            ),
          ),
          isLoading==true?Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:  CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/loading.json', width: 70, height: 70,
                    delegates: LottieDelegates(
                      values: [
                          ValueDelegate.color(
                            const ['Shape Layer 1', 'Rectangle 1', 'Fill 1'],
                            value: primaryColor,
                            // value: Colors.blueAccent,
                          ),
                          ValueDelegate.color(
                            const ['Shape Layer 2', 'Rectangle 1', 'Fill 1'],
                            value: primaryColor,
                            // value: Colors.blueAccent,
                          ),
                          ValueDelegate.color(
                            const ['Ellipse 28', 'Ellipse 28', 'Fill 1'],
                            value: primaryColor,
                            // value: Colors.blueAccent,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please wait...',
                    style: primaryTextStyle(size: 14),
                  )
                ],
              )):SizedBox.shrink(),

       if (questionAnswers.validate().isEmpty)
            ChatBotEmptyScreen(
                isScroll: isScroll,
                onTap: (value) {
                  msgController.text = value;
                  setState(() {});
                }).center(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                16.height,
                showResponse == false
                    ? Row(
                        children: [
                          AppTextField(
                            textFieldType: TextFieldType.OTHER,
                            controller: msgController,
                            minLines: 1,
                            maxLines: 1,
                            cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
                            keyboardType: TextInputType.multiline,
                            decoration: defaultInputDecoration(context, label: languages.lblChatHintText),
                            onFieldSubmitted: (s) {
                              sendMessage();
                            },
                            onTap: () {
                              isScroll = true;
                              setState(() {});
                            },
                          ).expand(),
                          10.width,
                          Container(
                            decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor, borderRadius: radius(14)),
                            child: IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              icon: Icon(Icons.send, size: 16, color: Colors.white),
                              onPressed: () {
                                if (msgController.text.isNotEmpty) {
                                  sendMessage();
                                }
                              },
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16)
                    : SizedBox.shrink(),
                16.height,
              ],
            ),
          ),
          /* if (!imageSelected.isEmpty) ...[
            Positioned(
              left: 20,
              bottom: 70,
              child: cachedImage(imageSelected, height: 40, fit: BoxFit.fill, width: 40).cornerRadiusWithClipRRect(5),
            ),
            Positioned(
              left: 20,
              bottom: 70,
              child: RawMaterialButton(
                onPressed: () {
                  imageSelected = '';
                  selectedImageIndex = -1;
                  setState(() {});
                },
                elevation: 2.0,
                child: Icon(
                  Icons.close,
                  size: 20,
                ),
                padding: EdgeInsets.only(bottom: 28.0, right: 11),
                shape: CircleBorder(),
              ),
            ),
          ]*/
        ],
      ),
    );
  }
}
