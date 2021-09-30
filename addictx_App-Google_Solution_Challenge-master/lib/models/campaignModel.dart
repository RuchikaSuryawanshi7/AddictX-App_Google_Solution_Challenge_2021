import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignModel
{
  final String title;
  final String profileImg;
  final String by;
  final Timestamp startTime;
  final Timestamp endTime;
  final int ageGrp;
  final String description;
  final String meetLink;

  CampaignModel({
    this.title,
    this.profileImg,
    this.by,
    this.startTime,
    this.endTime,
    this.ageGrp,
    this.description,
    this.meetLink,
  });

  factory CampaignModel.fromDocument(DocumentSnapshot doc)
  {
    return CampaignModel(
      title: doc.data()['title'],
      profileImg: doc.data()['profileImg'],
      by: doc.data()['by'],
      startTime: doc.data()['startTime'],
      endTime: doc.data()['endTime'],
      ageGrp: doc.data()['ageGrp'],
      description: doc.data()['description'],
      meetLink: doc.data()['meetLink'],
    );
  }
}