import 'package:intl/intl.dart';

class TimeAgo{
  static String timeAgoSinceDate(DateTime dateString,String lang) {
    final date2 = DateTime.now();
    final difference = date2.difference(dateString);
    Map lastWeek={
      'English':"Last week",
      'Hindi':'पिछले सप्ताह',
      'Spanish':'La semana pasada',
      'German':'Letzte Woche',
      'French':'La semaine dernière',
      'Japanese':'先週',
      'Russian':'Прошлая неделя',
      'Chinese':'上个星期',
      'Portuguese':'Semana Anterior',
    };
    Map daysAgo={
      'English':"days ago",
      'Hindi':'दिन पहले',
      'Spanish':'hace días',
      'German':'Vor Tagen',
      'French':'il y a quelques jours',
      'Japanese':'数日前',
      'Russian':'дней назад',
      'Chinese':'几天前',
      'Portuguese':'dias atrás',
    };
    Map yesterday={
      'English':"Yesterday",
      'Hindi':'कल',
      'Spanish':'Ayer',
      'German':'Gestern',
      'French':'Hier',
      'Japanese':'昨日',
      'Russian':'Вчера',
      'Chinese':'昨天',
      'Portuguese':'Ontem',
    };
    Map hoursAgo={
      'English':"Hours Ago",
      'Hindi':'घंटो पहले',
      'Spanish':'horas atras',
      'German':'Vor Stunden',
      'French':'il y a des heures',
      'Japanese':'時間前',
      'Russian':'несколько часов назад',
      'Chinese':'几小时前',
      'Portuguese':'horas atrás',
    };
    Map anHourAgo={
      'English':"an hour ago",
      'Hindi':'एक घंटे पहले',
      'Spanish':'hace una hora',
      'German':'vor einer Stunde',
      'French':'il y a une heure',
      'Japanese':'1時間前',
        'Russian':'час назад',
      'Chinese':'一小时前',
      'Portuguese':'uma hora atrás',
    };
    Map minutesAgo={
      'English':"minutes ago",
      'Hindi':'मिनट पहले',
      'Spanish':'hace minutos',
      'German':'Vor ein paar Minuten',
      'French':'il y a quelques minutes',
      'Japanese':'数分前',
      'Russian':'несколько минут назад',
      'Chinese':'几分钟前',
      'Portuguese':'minutos atrás',
    };

    Map aMinuteAgo={
      'English':"a minute ago",
      'Hindi':'एक मिनट पहले',
      'Spanish':'hace un minuto',
      'German':'vor einer Minute',
      'French':"Il y'a une minute",
      'Japanese':'1分前',
      'Russian':'минуту назад',
      'Chinese':'一分钟前',
      'Portuguese':'um minuto atrás',
    };
    Map secondsAgo={
      'English':"seconds ago",
      'Hindi':'सेकंड पहले',
      'Spanish':'Hace segundos',
      'German':'Vor Sekunden',
      'French':"il y a secondes",
      'Japanese':'秒前',
      'Russian':'секунд назад',
      'Chinese':'秒前',
      'Portuguese':'segundos atrás',
    };
    Map justNow={
      'English':"Just now",
      'Hindi':'अभी',
      'Spanish':'En este momento',
      'German':'Gerade jetzt',
      'French':"Juste maintenant",
      'Japanese':'ちょうど今',
      'Russian':'Прямо сейчас',
      'Chinese':'现在',
      'Portuguese':'Agora mesmo',
    };

    if (difference.inDays > 8 && difference.inDays < 365) {
      return DateFormat.MMMd().format(dateString).toString();
    } else if ((difference.inDays / 7).floor() >= 1) {
      return lastWeek[lang];
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} '+daysAgo[lang];
    } else if (difference.inDays >= 1) {
      return yesterday[lang];
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} '+hoursAgo[lang];
    } else if (difference.inHours >= 1) {
      return anHourAgo[lang];
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} '+minutesAgo[lang];
    } else if (difference.inMinutes >= 1) {
      return aMinuteAgo[lang];
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} '+secondsAgo[lang];
    } else if (difference.inDays >365) {
      return DateFormat.yMMMd().format(dateString).toString();
    } else {
      return justNow[lang];
    }
  }

}