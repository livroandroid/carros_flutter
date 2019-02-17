
class Response {
  final bool ok;
  final String msg;
  String url;

  Response(this.ok, this.msg);

  Response.fromJson(Map<String,dynamic> map) :
        ok = map["status"] == "OK",
        msg = map["msg"],
        url = map["url"];

  bool isOk() {
    return ok;
  }
}