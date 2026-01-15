class QuestionAnswerModel {
  String? question;
  StringBuffer? answer;
  bool? isLoading;
  String? smartCompose;

  QuestionAnswerModel({
    this.question,
    this.answer,
    this.isLoading,
    this.smartCompose,
  });
}

class QuestionImageAnswerModel {
  String? question;
  String? imageUri;
  StringBuffer? answer;
  bool? isLoading;
  String? smartCompose;

  QuestionImageAnswerModel({
    this.question,
    this.imageUri,
    this.answer,
    this.isLoading,
    this.smartCompose,
  });
}
