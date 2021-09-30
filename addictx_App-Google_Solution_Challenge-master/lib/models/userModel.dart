import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel
{
  final String id;
  final String username;
  final String email;
  final String url;
  final bool isExpert;
  int score;
  final String androidNotificationToken;
  final int likes;
  final int yearsOfExperience;
  final String description;
  final String backgroundImg;
  final String clinicFee;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.url,
    this.isExpert,
    this.score,
    this.androidNotificationToken,
    this.likes,
    this.yearsOfExperience,
    this.description,
    this.backgroundImg,
    this.clinicFee,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc)
  {
    return UserModel(
      id: doc.data()['id'],
      username: doc.data()['username'],
      email: doc.data()['email'],
      url: doc.data()['url'],
      isExpert: doc.data()['isExpert'],
      score: doc.data()['score'],
      androidNotificationToken: doc.data()['androidNotificationToken'],
      likes: doc.data()['likes'],
      yearsOfExperience: doc.data()['yearsOfExperience'],
      description: doc.data()['description'],
      backgroundImg: doc.data()['backgroundImg'],
      clinicFee: doc.data()['clinicFee'],
    );
  }
}