import 'package:addictx/SplashScreen.dart';
import 'package:addictx/pages/badgesPopUp.dart';
import 'package:addictx/pages/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

checkForAddiction(List badges, BuildContext context)async{
  if(!badges.contains('Addiction'))
    {
      DocumentSnapshot doc=await plansReference.doc(currentUser.id).get();
      if(doc.exists)
      {
        List<Map> plans=List.from(doc.data()['plans']);
        for(var plan in plans){
          DateTime date = DateTime.fromMillisecondsSinceEpoch(plan['startTime'].seconds * 1000);
          DocumentSnapshot document=await planDetailsReference.doc(getFileName(plan['planName'])).get();
          int countOfPlans=List.from(document.data()['data']).length;
          if(DateTime.now().difference(date).inDays>=countOfPlans)
          {
            usersReference.doc(currentUser.id).update({
              'score':FieldValue.increment(1500),
            });
            currentUser.score+=1500;
            badgesReference.doc(currentUser.id).set({
              'badges':FieldValue.arrayUnion(['Addiction']),
            },SetOptions(merge: true));
            Navigator.push(context, MaterialPageRoute(builder: (context)=>BadgesPopUp(title: 'for completing your addiction plan',fileName: 'Addiction',)));
            break;
          }
        }
      }
    }
}

checkForHabitBuilding(List badges, BuildContext context,SharedPreferences sharedPreferences)async{
  if(!badges.contains('Habit Building'))
    {
      List<String> dates=sharedPreferences.getStringList('habitBuildingTaskCompleteDates')??[];
      if(dates.length>=30)
        {
          usersReference.doc(currentUser.id).update({
            'score':FieldValue.increment(1000),
          });
          currentUser.score+=1000;
          badgesReference.doc(currentUser.id).set({
            'badges':FieldValue.arrayUnion(['Habit Building']),
          },SetOptions(merge: true));
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BadgesPopUp(title: 'for completing 30 days of your habit building',fileName: 'Habit Building',)));
        }
    }
}

checkForRelaxationActivities(List badges, BuildContext context,SharedPreferences sharedPreferences)async{
  List<String> activities=[
    'Walking','Breathing',
    'Jogging','Yoga',
    'Dancing','Stair Climbing',
    'Cycling','Swimming',
  ];
  for(int i=0;i<activities.length;i++){
    if(!badges.contains(activities[i]))
    {
      double den=sharedPreferences.getDouble(activities[i]+'den')??0.0;
      if(den>=30){
        usersReference.doc(currentUser.id).update({
          'score':FieldValue.increment(1000),
        });
        currentUser.score+=1000;
        badgesReference.doc(currentUser.id).set({
          'badges':FieldValue.arrayUnion([activities[i]]),
        },SetOptions(merge: true));
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BadgesPopUp(title: 'for doing ${activities[i]} for more than 30 times',fileName: activities[i],)));
      }
    }
  }
}