import 'dart:io';
class GetSystemLanguage{
  static String getLanguage() {
    final String defaultLocale = Platform.localeName;
    switch (defaultLocale) {
      case "hi_":
        return 'Hindi';
        break;
      case "hi_IN":
        return 'Hindi';
        break;
      case "es_":
        return 'Spanish';
        break;
      case "es_419":
        return 'Spanish';
        break;
      case "es_AR":
        return 'Spanish';
        break;
      case "es_BO":
        return 'Spanish';
        break;
      case "es_CL":
        return 'Spanish';
        break;
      case "es_CO":
        return 'Spanish';
        break;
      case "es_CR":
        return 'Spanish';
        break;
      case "es_CU":
        return 'Spanish';
        break;
      case "es_DO":
        return 'Spanish';
        break;
      case "es_EA":
        return 'Spanish';
        break;
      case "es_EC":
        return 'Spanish';
        break;
      case "es_ES":
        return 'Spanish';
        break;
      case "es_GQ":
        return 'Spanish';
        break;
      case "es_GT":
        return 'Spanish';
        break;
      case "es_HN":
        return 'Spanish';
        break;
      case "es_IC":
        return 'Spanish';
        break;
      case "es_MX":
        return 'Spanish';
        break;
      case "es_NI":
        return 'Spanish';
        break;
      case "es_PA":
        return 'Spanish';
        break;
      case "es_PE":
        return 'Spanish';
        break;
      case "es_PH":
        return 'Spanish';
        break;
      case "es_PR":
        return 'Spanish';
        break;
      case "es_PY":
        return 'Spanish';
        break;
      case "es_SV":
        return 'Spanish';
        break;
      case "es_US":
        return 'Spanish';
        break;
      case "es_US":
        return 'Spanish';
        break;
      case "es_UY":
        return 'Spanish';
        break;
      case "es_VE":
        return 'Spanish';
        break;
      case "gsw_":
        return 'German';
        break;
      case "gsw_CH":
        return 'German';
        break;
      case "gsw_FR":
        return 'German';
        break;
      case "gsw_LI":
        return 'German';
        break;
      case "user-disabled":
        return 'French';
        break;
      case "operation-not-allowed":
        return 'Japanese';
        break;
      case "email-already-in-use":
        return 'Russian';
        break;
      case "email-already-in-use":
        return 'Chinese';
        break;
      case "email-already-in-use":
        return 'Portuguese';
        break;
      default:
        return 'English';
    }
  }
}