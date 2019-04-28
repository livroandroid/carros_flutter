
class Response {
  final bool ok;
  final String msg;
  String url;
  int id;

  Response(this.ok, this.msg);

  Response.fromJson(Map<String,dynamic> map) :
        ok = map["status"] == "OK",
        msg = map["msg"],
        id = map["id"] as int,
        url = map["url"];

  bool isOk() {
    return ok;
  }
}