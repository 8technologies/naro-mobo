class QuestionModel {
  int id = 0;
  int crop = 0;
  String name = "";
  String crop_name = "";
  String location = "";
  String inquiry = "";
  String title = "";
  String query_content = "";
  String image = "";
  String audio = "";
  String video = "";
  String posted_by = "";
  String created = "";
  String posted_by_image = "";
  String comment_count = "";

  static QuestionModel fromJsonToObject(Map<String, dynamic> tempMap) {
    QuestionModel temp = new QuestionModel();
    if (tempMap['id'] != null) {
      try {
        temp.id = int.parse(tempMap['id'].toString());
      } catch (_) {
        temp.id = 0;
      }

      try {
        temp.crop = int.parse(tempMap['crop'].toString());
      } catch (_) {
        temp.crop = 0;
      }
      temp.name = tempMap['name'].toString();
      temp.crop_name = tempMap['crop_name'].toString();
      temp.location = tempMap['location'].toString();
      temp.inquiry = tempMap['inquiry'].toString();
      temp.title = tempMap['title'].toString();
      temp.query_content = tempMap['query_content'].toString();
      temp.audio = tempMap['audio'].toString();
      temp.video = tempMap['video'].toString();
      temp.posted_by = tempMap['posted_by'].toString();
      temp.created = tempMap['created'].toString();
      temp.posted_by_image = tempMap['posted_by_image'].toString();
      temp.comment_count = tempMap['comment_count'].toString();

      if (tempMap['image'] == null ||
          tempMap['image'].toString().length < 10) {
        temp.image = "";
      } else {
        temp.image = tempMap['image'].toString();
      }
    }

    return temp;
  }

  static List<QuestionModel> fromJsonToList(List<dynamic> data) {
    if (data.isEmpty) {
      return [];
    }
    List<QuestionModel> items = [];

    data.forEach((element) {
      QuestionModel item = fromJsonToObject(element);
      items.add(item);
    });

    return items;
  }
}
