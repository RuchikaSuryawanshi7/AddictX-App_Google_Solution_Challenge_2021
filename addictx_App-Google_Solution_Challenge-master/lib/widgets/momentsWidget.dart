import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:addictx/SplashScreen.dart';
import 'package:addictx/models/userModel.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';


class MomentsWidget extends StatefulWidget {
  final UserModel user;
  var documents;
  List<bool> seen=[];
  MomentsWidget({this.user,this.documents,this.seen});
  @override
  _MomentsWidgetState createState() => _MomentsWidgetState();
}

class _MomentsWidgetState extends State<MomentsWidget> {
  final StoryController storyController=StoryController();
  int index=0;
  updateMomentsSeen(document)async
  {
    String id;
    QuerySnapshot querySnapshot=await  momentsReference.doc(widget.user.id).collection("userMoments").where("url",isEqualTo: document.data()["url"]).get();
    querySnapshot.docs.forEach((doc) {
      id=doc.reference.id;
    });
    await momentsReference.doc(widget.user.id).collection("userMoments").doc(id).update({
      "seenBy":FieldValue.arrayUnion(["${currentUser.id}"]),
    });
  }
  show1(var document,){
    return document.data()["type"]=="image"?StoryItem.pageImage(
      url: document.data()["url"],
      controller: storyController,
      caption: "${document.data()["description"]}",
    ):StoryItem.pageVideo(
      document.data()["url"],
      controller: storyController,
      caption: "${document.data()["description"]}",
      duration: Duration(seconds: 30),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10.0),
        child: Material(
          child: Stack(
            children: <Widget>[
              StoryView(
                controller: storyController,
                storyItems: [
                  for(var i in widget.documents)show1(i)
                ],
                repeat: false,
                inline: true,
                onStoryShow: (s){
                  if(currentUser!=null)
                    {
                      if(!s.shown&&widget.seen!=null)
                      {
                        if(widget.seen[index]&&widget.seen.length!=1&&widget.seen.toSet().toList().length!=1)
                        {
                          storyController.next();
                        }
                        if(!widget.seen[index])
                        {
                          currentUser!=null?updateMomentsSeen(widget.documents[index]):null;
                        }
                        if(index<widget.seen.length-1)
                          index++;
                      }
                    }
                },
                onComplete: (){
                  Navigator.pop(context);
                },
              ),
              Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: ListTile(
                    leading: widget.user.url==""?CircleAvatar(child: Icon(Icons.person,size: 40.0,color: Colors.white,),backgroundColor: Colors.black,):CircleAvatar(backgroundColor: Colors.black,backgroundImage: CachedNetworkImageProvider(widget.user.url),),
                    title: Text(widget.user.username,style: TextStyle(color: Colors.grey,fontSize: 20.0),),
                  )
              ),
            ],
          ),
        )
    );
  }
}