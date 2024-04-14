class CommentModel {
  int id = 0;
  int user = 0;
  int query = 0;
  String commenter_name = "";
  String comment = "";
  String avator = "";
  String comment_reply = "";
  String created = "";

  static CommentModel fromJsonToObject(Map<String, dynamic> tempMap) {
    CommentModel temp = new CommentModel();
    if (tempMap['id'] != null) {
      try {
        temp.id = int.parse(tempMap['id'].toString());
      } catch (_) {
        temp.id = 0;
      }

      try {
        temp.user = int.parse(tempMap['user'].toString());
      } catch (_) {
        temp.user = 0;
      }

      try {
        temp.query = int.parse(tempMap['query'].toString());
      } catch (_) {
        temp.query = 0;
      }
      temp.commenter_name = tempMap['commenter_name'].toString();
      temp.comment = tempMap['comment'].toString();
      temp.avator = tempMap['avator'].toString();
      temp.comment_reply = tempMap['comment_reply'].toString();
      temp.created = tempMap['created'].toString();
    }

    return temp;
  }

  static List<CommentModel> fromJsonToList(List<dynamic> data) {
    if (data.isEmpty) {
      return [];
    }
    List<CommentModel> items = [];

    data.forEach((element) {
      CommentModel item = fromJsonToObject(element);
      items.add(item);
    });

    return items;
  }
}
