
class Response {
  final String status;
  final String msg;
  final String url;

  Response(this.status, this.msg, this.url);

  Response.fromJson(Map<String,dynamic> map) :
        status = map["status"],
        msg = map["msg"],
        url = map["url"];

  bool isOk() {
    return status == "OK";
  }
}