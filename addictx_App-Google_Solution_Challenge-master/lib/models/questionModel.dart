class QuestionModel
{
  String question;
  List<dynamic> options;
  QuestionModel({
    this.question,
    this.options,
  });

  factory QuestionModel.fromMap(Map data)
  {
    return QuestionModel(
      question:data['question'],
      options: data['options'],
    );
  }
}