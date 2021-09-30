import 'package:addictx/languageNotifier.dart';
import 'package:addictx/pages/challenge.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChallengeTile extends StatelessWidget {
  final String challengeName;

  ChallengeTile({this.challengeName,});

  String lang='English';

  void navigate(BuildContext context){
    if(challengeName=="Walking League")
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Challenge(
          challengeName: 'Walking League',
          participants: 316,
          imagePath: 'assets/walking.jpg',
          details: 'Another challenge in the queue is waiting for you. Here you have to walk and just walk. We will record your steps and let us tell you a secret, we will award the top 3 people who walked the most out of you all.',
          duration: '28th June to 20th July',
          note: 'We have successfully recorded your attempt, we will notify and reward you if you win.',
          rewardsPath: [
            'assets/rewards/rewards1.png',
            'assets/rewards/rewards2.png',
            'assets/rewards/rewards3.png',
          ],
        )));
      }
    else
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Challenge(
          challengeName: 'Yoga League',
          participants: 259,
          imagePath: 'assets/yoga/yogabg.jpg',
          details: 'If your life just got harder, that means you have just levelled up. You have a set of yoga challenges ahead of you, for which you will have to perform 3 asanas, namely trikonasana, vrikshasana and virbhadra aasan, which requires a little attention from you as our AI model will check you everytime.',
          duration: '28th June to 30th July',
          note: 'We have successfully recorded your attempt, we will notify and reward you if you win.',
          rewardsPath: [
            'assets/rewards/rewards1.png',
            'assets/rewards/rewards2.png',
            'assets/rewards/rewards3.png',
          ],
        )));
      }
  }

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    lang = languageNotifier.getLanguage();
    return GestureDetector(
      onTap: ()=>navigate(context),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.18,
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.symmetric(horizontal:8,vertical: 2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: AssetImage(challengeName=="Walking League"?'assets/walking.jpg':'assets/yoga/yogabg.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  challengeName,
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(FontAwesomeIcons.running,color: Colors.white,size: 16,),
                    SizedBox(width: 8,),
                    Text(
                      challengeName=="Walking League"?'316':'259'+' participants',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
          ),
        ],
      ),
    );
  }
}