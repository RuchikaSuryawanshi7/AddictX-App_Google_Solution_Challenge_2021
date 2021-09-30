import 'package:addictx/languageNotifier.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:pimp_my_button/pimp_my_button.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';


class BadgesPopUp extends StatefulWidget {
  BadgesPopUp({Key key, this.title,this.fileName}) : super(key: key);
  final String fileName;
  final String title;

  @override
  _BadgesPopUpState createState() => new _BadgesPopUpState();
}

class _BadgesPopUpState extends State<BadgesPopUp> with TickerProviderStateMixin {
  GlobalKey<AnimatorWidgetState> _key = GlobalKey<AnimatorWidgetState>();
  Map congratulations={
    'English':"Congratulations!",
    'Hindi':'बधाई हो!',
    'Spanish':'¡Felicidades!',
    'German':'Herzliche Glückwünsche!',
    'French':'Toutes nos félicitations!',
    'Japanese':'おめでとう！',
    'Russian':'Поздравляю!',
    'Chinese':'恭喜！',
    'Portuguese':'Parabéns!',
  };
  Map firstHalf={
    'English':"You made it! You Just earned a new badge for ",
    'Hindi':'तुमने कर दिखाया! ',
    'Spanish':'¡Lo hiciste! Acabas de ganar una nueva insignia de ',
    'German':'Sie haben es geschafft! Du hast gerade ein neues Abzeichen für ',
    'French':"Tu l'as fait! Vous venez de recevoir un nouveau badge pour le ",
    'Japanese':'やった！ ',
    'Russian':'Ты сделал это! Вы только что получили новый значок по ',
    'Chinese':'你做到了！你刚刚赢得了一个新的',
    'Portuguese':'Você conseguiu! Você acabou de ganhar um novo emblema para ',
  };
  Map secondHalf={
    'English':". There are loads more badges to unlock on AddictX app. You are going to do big. Well done and keep up the good work.",
    'Hindi':' के लिए आपका नया बैज अनलॉक हो गया है। एडिक्टएक्स ऐप पर अनलॉक करने के लिए बहुत सारे बैज हैं। आप बड़ा काम करने जा रहे हैं। शाबाश और अच्छा काम करते रहो।',
    'Spanish':'. Hay muchas más insignias para desbloquear en la aplicación AddictX. Vas a hacerlo a lo grande. Bien hecho y sigan con el buen trabajo.',
    'German':'. In der AddictX-App gibt es noch viele weitere Abzeichen zum Freischalten. Du wirst Großes leisten. Gut gemacht und mach weiter so.',
    'French':". Il y a beaucoup plus de badges à débloquer sur l'application AddictX. Vous allez faire grand. Bravo et bonne continuation.",
    'Japanese':'の新しいバッジを獲得しました。AddictXアプリでロックを解除するバッジがさらにたくさんあります。あなたは大きなことをするつもりです。よくやったし、良い仕事を続けてください。',
    'Russian':'. В приложении AddictX есть еще множество значков, которые можно разблокировать. Вы собираетесь добиться большого успеха. Молодцы, продолжайте в том же духе.',
    'Chinese':'徽章。在 AddictX 应用程序上有更多的徽章可以解锁。你要做大事。干得好，继续做好工作。',
    'Portuguese':'. Existem muitos mais emblemas para desbloquear no aplicativo AddictX. Você vai fazer grande. Muito bem e continue com o bom trabalho.',
  };
  Map<String, String> ok={
    'English':'OK',
    'Hindi':'ठीक है',
    'Spanish':'OK',
    'German':'OK',
    'French':"D'accord",
    'Japanese':'OK',
    'Russian':'ОК',
    'Chinese':'好的',
    'Portuguese':'OK',
  };

  @override
  Widget build(BuildContext context) {
    final languageNotifier = Provider.of<LanguageNotifier>(context);
    String lang = languageNotifier.getLanguage();
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 450.0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: BounceInDown(
                        key: _key,
                        preferences: AnimationPreferences(
                          animationStatusListener: (AnimationStatus status){
                            if(status==AnimationStatus.completed){
                            }
                          },
                        ),
                        child: AvatarGlow(
                          endRadius: 200.0,
                          repeat: false,
                          glowColor: Colors.blue,
                          child: Material(
                              shape: CircleBorder(),
                              elevation: 5,
                              child: CircleAvatar(
                                radius: 90,
                                backgroundColor: Colors.amber,
                                backgroundImage: AssetImage('assets/badges/${widget.fileName}.png',),
                              ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(child: Text(congratulations[lang],style: TextStyle(
              fontSize: 40.0,
              letterSpacing: 3.0,
              color: Colors.blue,
            ),),),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text(firstHalf[lang]+widget.title+secondHalf[lang],style: TextStyle(
                fontSize: 17.0,
              ),textAlign: TextAlign.center,)),
            ),
            SizedBox(height: 40.0,),
            FlatButton(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              color: Color(0xff9ad0e5),
              onPressed: ()=>Navigator.pop(context),
              child: Text(ok[lang],style: TextStyle(fontSize: 20.0,color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}

class DemoParticle extends Particle {
  @override
  void paint(Canvas canvas, Size size, progress, seed) {
    CompositeParticle(children: [
      Fireworks(count: 20,),
    ]).paint(canvas, size, progress, seed);
  }
}

class Fireworks extends Particle {
  final int count;

  Fireworks({this.count});
  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    List<Particle> list=[];
    for(int i=0;i<count;i++){
      double val= Random().nextDouble()%1;
      list.add(
        IntervalParticle(
          interval: Interval(0.0,1.0-val, curve: Curves.easeIn),
          child: PoppingCircle(
            color: RandomColor().randomColor(),
          ),
        ),
      );
    }
    FourRandomSlotParticle(children: list).paint(canvas, size, progress, seed);
  }

}

class FourRandomSlotParticle extends Particle {

  final List<Particle> children;

  final double relativeDistanceToMiddle;

  FourRandomSlotParticle({this.children, this.relativeDistanceToMiddle = 2.0});


  @override
  void paint(Canvas canvas, Size size, double progress, int seed) {
    Random random = Random(seed);
    int side = 0;
    for(Particle particle in children) {
      PositionedParticle(
        position: sideToOffset(side, size, random) * relativeDistanceToMiddle,
        child: particle,
      ).paint(canvas, size, progress, seed);
      side ++;
    }
  }

  Offset sideToOffset(int side, Size size, Random random) {
    double divH=1.2,divV=2.5;
    if(side%4 == 0) {
      return Offset(-random.nextDouble() * (size.width / divH), -random.nextDouble() * (size.height / divV));
    } else if(side%4 == 1) {
      return Offset(random.nextDouble() * (size.width / divH), -random.nextDouble() * (size.height / divV));
    } else if(side%4 == 2) {
      return Offset(random.nextDouble() * (size.width / divH), random.nextDouble() * (size.height / divV));
    } else if(side%4 == 3) {
      return Offset(-random.nextDouble() * (size.width / divH), random.nextDouble() * (size.height / divV));
    } else {
      throw Exception();
    }
  }

  double randomOffset(Random random, int range) {
    return range / 2 - random.nextInt(range);
  }

}