import 'package:flutter/material.dart';

class AsanaUpdate extends StatelessWidget {
  const AsanaUpdate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Stress.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(),
                  ),
                  Positioned(
                    child: AppBar(
                      leading: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 28.0,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            size: 30.0,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                          tooltip: 'Share',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Column(
                children: [
                  Text(
                    "Today's session is completed",
                    style: TextStyle(
                      color: Color(0xff9ad0e5),
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "The true miracle lies in our eagerness to allow, appreciate, and honour the uniqueness, and freedom of each sentient being to sing the song of their heart. Be who you are and say what you feel, because those who mind don’t matter and those who matter don’t mind. Be who you are and say what you feel, because those who mind don’t matter and those who matter don’t mind",
                      style: TextStyle(
                        color: Color(0x99000000),
                        fontSize: 11.5,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    //margin: EdgeInsets.all(20),
                    child: FlatButton(
                      height: 60.0,
                      minWidth: 1000.0,
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      color: Color(0xff9ad0e5),
                      textColor: Color(0xff000000),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
