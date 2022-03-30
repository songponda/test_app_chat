class NewsModel {
  String? update_time;
  String? create_time;
  String? date_news;
  String? title;
  String? Detail;
  String? linkImage;
  String? type;
  String? statusDisable;

  NewsModel(
      {this.update_time,
      this.create_time,
      this.date_news,
      this.title,
      this.Detail,
      this.linkImage,
      this.type,
      this.statusDisable});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
        update_time: json["update_time"],
        create_time: json["create_time"],
        date_news: json["date_news"] ?? '',
        title: json["title"] ?? '',
        Detail: json["Detail"] ?? '',
        linkImage: json["linkImage"] ?? '',
        type: json["type"] ?? '',
        statusDisable: json["statusDisable"] ?? '');
  }

  Map<String, dynamic> toMap() => {
        'update_time': update_time,
        'create_time': create_time,
        'date_news': date_news,
        'title': title,
        'Detail': Detail,
        'linkImage': linkImage,
        'type': type,
        'statusDisable': statusDisable
      };
}
