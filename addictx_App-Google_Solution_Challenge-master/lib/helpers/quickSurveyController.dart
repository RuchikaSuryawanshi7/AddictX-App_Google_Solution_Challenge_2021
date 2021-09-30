import 'dart:convert' as convert;
import 'package:addictx/models/quickSurveyModel.dart';
import 'package:http/http.dart' as http;


class QuickSurveyController {
  // Callback function to give response of status of current request.
  final void Function(String) callback;

  // Google App Script Web URL
  static const String URL = "https://script.google.com/macros/s/AKfycbwzvnt0pyQ0fDM_tXrBM-i-vdh7d9yb7FgYGHWL4rRa6hbtDd2APtcXKQX0GdEu4qDZuw/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  QuickSurveyController(this.callback);

  void submitForm(QuickSurveyForm feedbackForm) async{
    try{
      await http.get(Uri.parse(URL + feedbackForm.toParams())).then(
              (response){
            callback(convert.jsonDecode(response.body)['status']);
          });
    } catch(e){
      print(e);
    }
  }
}