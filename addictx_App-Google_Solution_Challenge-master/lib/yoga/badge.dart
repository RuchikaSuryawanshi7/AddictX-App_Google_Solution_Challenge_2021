import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Stress.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Congratulation!",
                  style: TextStyle(
                    color: Color(0xff9ad0e5),
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "You have earned a badge !!",
                style: TextStyle(
                  color: Color(0x99000000),
                  fontSize: 11.5,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(
                  "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor  dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempo  dolor si sed diam nonumy et dolore magna aliquyam erat, sed diam voluptua. ",
                  style: TextStyle(
                    color: Color(0xff707070),
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
                    'Share Now',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  color: Color(0xff9ad0e5),
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
