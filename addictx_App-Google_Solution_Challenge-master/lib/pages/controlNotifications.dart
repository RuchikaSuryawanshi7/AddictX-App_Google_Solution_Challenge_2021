import 'package:addictx/languageNotifier.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ControlNotification extends StatefulWidget {
  const ControlNotification({Key key}) : super(key: key);

  @override
  _ControlNotificationState createState() => _ControlNotificationState();
}

class _ControlNotificationState extends State<ControlNotification> {
  bool _waterReminder=true;
  Map title={
    'English':'Notification',
    'Hindi':'अधिसूचना',
    'Spanish':'Notificación',
    'German':'Benachrichtigung',
    'French':'Notification',
    'Japanese':'お知らせ',
    'Russian':'Уведомление',
    'Chinese':'通知',
    'Portuguese':'Notificação'
  };
  Map water={
    'English':'Water Reminder',
    'Hindi':'जल अनुस्मारक',
    'Spanish':'Recordatorio de agua',
    'German':'Wassererinnerung',
    'French':"Rappel d'eau",
    'Japanese':'ウォーターリマインダー',
    'Russian':'Напоминание о воде',
    'Chinese':'饮水提醒',
    'Portuguese':'Lembrete de água'
  };
  Map subtitle={
    'English':"Customize in app notification",
    'Hindi':'ऐप अधिसूचना में अनुकूलित करें',
    'Spanish':'Personalizar en la notificación de la aplicación',
    'German':'In App-Benachrichtigungen anpassen',
    'French':"Personnaliser dans la notification de l'application",
    'Japanese':'アプリ通知でカスタマイズ',
    'Russian':'Настроить в уведомлении приложения',
    'Chinese':'自定义应用内通知',
    'Portuguese':'Personalize na notificação do aplicativo',
  };
  Map contest={
    'English':'Contest Reminder',
    'Hindi':'प्रतियोगिता अनुस्मारक',
    'Spanish':'Recordatorio del concurso',
    'German':'Gewinnspiel-Erinnerung',
    'French':"Rappel du concours",
    'Japanese':'コンテストリマインダー',
    'Russian':'Напоминание о конкурсе',
    'Chinese':'比赛提醒',
    'Portuguese':'Lembrete de concurso'
  };
  Map campaign={
    'English':"Campaign Reminder",
    'Hindi':'अभियान अनुस्मारक',
    'Spanish':'Recordatorio de campaña',
    'German':'Kampagnenerinnerung',
    'French':"Rappel de campagne",
    'Japanese':'キャンペーンリマインダー',
    'Russian':'Напоминание о кампании',
    'Chinese':'活动提醒',
    'Portuguese':'Lembrete de campanha'
  };
  Map daily={
    'English':"Daily Notification",
    'Hindi':'दैनिक अधिसूचना',
    'Spanish':'Notificación diaria',
    'German':'Tägliche Benachrichtigung',
    'French':"Notification quotidienne",
    'Japanese':'毎日の通知',
    'Russian':'Ежедневное уведомление',
    'Chinese':'每日通知',
    'Portuguese':'Notificação Diária'
  };

  void toggleSwitch(bool value)
  {
    if(_waterReminder == false)
    {
      setState(() {
        _waterReminder=true;
        //save();
      });
    }
    else
    {
      setState(() {
        _waterReminder=false;
        //save();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Center(
            child: Text(
              title[lang]+' ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
        title: GestureDetector(
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black,),
          onTap: ()=>Navigator.pop(context),
        ),
        backgroundColor: const Color(0xfff0f0f0),
      ),
      body: Column(
        children: [
          ListTile(
            tileColor: Colors.white,
            minVerticalPadding: 20,
            title: Text(
              water[lang],
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text("Customize in app notification"),
            leading: Padding(
              padding: EdgeInsets.only(top: 5),
              child: Icon(FontAwesomeIcons.tint,size: 30.0,color: const Color(0xff9ad0e5),),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Switch(
                activeColor: Colors.white,
                activeTrackColor: const Color(0xff9ad0e5),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xffe2e2e2),
                value: _waterReminder,
                onChanged: (val) {
                  toggleSwitch(val);
                },
              ),
            ),
          ),
          Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
          ListTile(
            tileColor: Colors.white,
            minVerticalPadding: 20,
            title: Text(
              contest[lang],
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text(subtitle[lang]),
            leading: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(FontAwesomeIcons.trophy,size: 30.0,color: const Color(0xff9ad0e5),),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Switch(
                activeColor: Colors.white,
                activeTrackColor: const Color(0xff9ad0e5),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xffe2e2e2),
                value: _waterReminder,
                onChanged: (val) {
                  toggleSwitch(val);
                },
              ),
            ),
          ),
          Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
          ListTile(
            tileColor: Colors.white,
            minVerticalPadding: 20,
            title: Text(
              campaign[lang],
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text(subtitle[lang]),
            leading: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(FontAwesomeIcons.route,size: 30.0,color: const Color(0xff9ad0e5),),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Switch(
                activeColor: Colors.white,
                activeTrackColor: const Color(0xff9ad0e5),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xffe2e2e2),
                value: _waterReminder,
                onChanged: (val) {
                  toggleSwitch(val);
                },
              ),
            ),
          ),
          Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
          ListTile(
            tileColor: Colors.white,
            minVerticalPadding: 20,
            title: Text(
              daily[lang],
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            subtitle: Text(subtitle[lang]),
            leading: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Icon(Icons.notifications_active_outlined,size: 30.0,color: const Color(0xff9ad0e5),),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(top:10.0),
              child: Switch(
                activeColor: Colors.white,
                activeTrackColor: const Color(0xff9ad0e5),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xffe2e2e2),
                value: _waterReminder,
                onChanged: (val) {
                  toggleSwitch(val);
                },
              ),
            ),
          ),
          Divider(height: 0,thickness: 2,color: const Color(0xffebebeb),),
        ],
      ),
    );
  }
}
