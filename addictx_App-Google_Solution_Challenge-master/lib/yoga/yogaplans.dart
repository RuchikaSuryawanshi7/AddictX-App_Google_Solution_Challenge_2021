import 'package:addictx/yoga/ai.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class YogaPlans extends StatefulWidget {
  final String addictionName;
  final List poses;
  const YogaPlans({Key key,this.addictionName,this.poses}) : super(key: key);

  @override
  _YogaPlansState createState() => _YogaPlansState();
}

class _YogaPlansState extends State<YogaPlans> {

  String returnPoseName(String poseName){
    switch (poseName) {
      case 'Cat Stretch':
        return 'Cat Stretch';
        break;
      case 'Chair Pose':
        return 'Chair Pose';
        break;
      case 'Chakrasana':
        return 'Chakrasana';
        break;
      case 'Child Pose':
        return 'Child Pose';
        break;
      case 'Cobra Pose':
        return 'Cobra pose';
        break;
      case 'Dolphin Pose':
        return 'Dolphin pose';
      case 'Downward Facing Dog':
        return 'Downward-Facing Dog';
        break;
      case 'Fish Pose':
        return 'fish pose';
        break;
      case 'Gomukhasana':
        return 'Gomukhasana';
        break;
      case 'Knee to Chest':
        return 'knee to chest';
        break;
      case 'Lotus pose':
        return 'lotus pose';
        break;
      case 'Low Lungs':
        return 'low lungs';
        break;
      case 'Mandukhasana':
        return 'Mandukasana';
        break;
      case 'Pigeon Pose':
        return 'Pigeon Pose';
        break;
      case 'Plank':
        return 'plank';
        break;
      case 'Revolved head of knee':
        return 'Revolved Head-of-the-Knee Pose';
        break;
      case 'Salamba Shrishasana':
        return 'Salamba Shirshasana';
        break;
      case 'Seated Forward Fold':
        return 'seated forward fold';
        break;
      case 'Seated Spinal Twist':
        return 'Seated Spinal Twist';
        break;
      case 'Tadasana':
        return 'tadasan';
        break;
      case 'Plow Pose':
        return 'The Plow Pose';
        break;
      case 'Tree Pose':
        return 'tree pose';
        break;
      case 'Triangle Pose':
        return 'Triangle Pose';
        break;
      case 'Uttasana':
        return 'Uttanasana';
        break;
      case 'Vajrasana':
        return 'Vajrasana';
        break;
      case 'Viparita Karani':
        return 'Viparita Karani';
        break;
      case 'Viparita Shabasana':
        return 'viparita shalabhasana';
        break;
      case 'Warrior-1':
        return 'warrior 1';
        break;
      case 'Bound Angle Pose':
        return 'Bound Angle Pose';
        break;
      case 'Bow Pose':
        return 'Bow pose';
        break;
      case 'Bridge':
        return 'Bridge Pose';
        break;
      case 'Camel Pose':
        return 'Camel pose';
        break;
      default:
        return 'no pose exists';
    }
  }

  Widget poses(String className, String poseName,String PoseDescription,) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewExample(poseName: className,)));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6.0),
        child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
          color: Color(0xfff0f0f0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntrinsicHeight(
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          poseName,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          PoseDescription,
                          style: TextStyle(
                            color: Color(0x7a000000),
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/yogaPoses/$poseName.jpg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.24,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider('https://images.unsplash.com/photo-1575052814086-f385e2e2ad1b?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8eW9nYXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                      ),
                    ),
                    child: Text(
                      "#Stay Fit with AddictX",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: ()=>Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,),
                      ),
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.more_horiz,color: Colors.white,),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15,),
              SizedBox(height: 8.0,),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.poses.length,
                itemBuilder: (context,index){
                  return poses(returnPoseName(widget.poses[index]), widget.poses[index], 'Hello',);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
