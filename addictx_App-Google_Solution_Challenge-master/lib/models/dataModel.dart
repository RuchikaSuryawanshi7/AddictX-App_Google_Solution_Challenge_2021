class DataModel
{
  final String heading;
  final List<dynamic> content;
  final String url;
  DataModel({
    this.heading,
    this.content,
    this.url,
  });

  factory DataModel.fromMap(Map data)
  {
    return DataModel(
      heading:data['heading'],
      content: List.from(data['content']),
      url: data['url'],
    );
  }
}