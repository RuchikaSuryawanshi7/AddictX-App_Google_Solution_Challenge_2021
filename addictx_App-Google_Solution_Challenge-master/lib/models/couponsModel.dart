import 'package:cloud_firestore/cloud_firestore.dart';

class CouponsModel
{
  final String heading;
  final String url;
  final String coupon;
  final String discount;
  final String link;
  final String value;
  final bool oneTimeUse;
  final String id;
  final List<String> boughtBy;

  CouponsModel({
    this.heading,
    this.url,
    this.coupon,
    this.discount,
    this.link,
    this.value,
    this.oneTimeUse,
    this.id,
    this.boughtBy,
  });

  factory CouponsModel.fromDocument(DocumentSnapshot doc)
  {
    return CouponsModel(
      heading: doc.data()['heading'],
      url: doc.data()['url'],
      coupon: doc.data()['coupon'],
      discount: doc.data()['discount'],
      link: doc.data()['link'],
      value: doc.data()['value'],
      oneTimeUse: doc.data()['oneTimeUse'],
      id: doc.data()['id'],
      boughtBy: List.from(doc.data()['boughtBy']),
    );
  }
}