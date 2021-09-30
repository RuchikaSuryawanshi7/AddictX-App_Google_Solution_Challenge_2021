import 'package:flutter/material.dart';

class LanguageNotifier with ChangeNotifier {
  String _languageData;

  LanguageNotifier(this._languageData);

  getLanguage() => _languageData;

  setLanguage(String languageData) async {
    _languageData = languageData;
    notifyListeners();
  }
}