import 'package:cloud_firestore/cloud_firestore.dart';

class ClinicModel
{
  final String doctorId;
  final String clinicName;
  final double rating;
  final String timings;
  final String address;
  final String contactNumber;
  final int reviewPercent;
  final String reviewStatement;
  final String locationUrl;
  final String mapImg;
  final List<String> imageUrls;

  ClinicModel({
    this.doctorId,
    this.clinicName,
    this.rating,
    this.timings,
    this.address,
    this.contactNumber,
    this.reviewPercent,
    this.reviewStatement,
    this.locationUrl,
    this.mapImg,
    this.imageUrls,
  });

  factory ClinicModel.fromDocument(DocumentSnapshot doc){
    return ClinicModel(
      doctorId: doc.id,
      clinicName: doc.data()['clinicName'],
      rating: doc.data()['rating'],
      timings: doc.data()['timings'],
      address: doc.data()['address'],
      contactNumber: doc.data()['contactNumber'],
      reviewPercent: doc.data()['reviewPercent'],
      reviewStatement: doc.data()['reviewStatement'],
      locationUrl: doc.data()['locationUrl'],
      mapImg: doc.data()['mapImg'],
      imageUrls: List.from(doc.data()['imageUrls']),
    );
  }
}