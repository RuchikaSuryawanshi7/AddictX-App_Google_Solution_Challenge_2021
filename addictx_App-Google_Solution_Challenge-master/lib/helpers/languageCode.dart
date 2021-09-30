
class LanguageCode{
  static String getCode(String lang) {
    switch (lang) {
      case "Hindi":
        return 'hi';
        break;
      case "English":
        return 'en-GB';
        break;
      case "Spanish":
        return 'es';
        break;
      case "German":
        return 'de';
        break;
      case "French":
        return 'fr';
        break;
      case "Japanese":
        return 'ja';
        break;
      case "Russian":
        return 'ru';
        break;
      case "Chinese":
        return 'zh-TW';
        break;
      case "Portuguese":
        return 'pt-PT';
        break;
      default:
        return 'en-GB';
    }
  }
}