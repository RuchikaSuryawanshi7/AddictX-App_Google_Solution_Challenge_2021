class QuickSurveyForm {

  String _question;
  String _option;

  QuickSurveyForm(this._question, this._option,);

  // Method to make GET parameters.
  String toParams() =>
      "?question=$_question&option=$_option";


}