
class Response {
  final String status;
  final String msg;

  Response(this.status, this.msg);

  Response.fromJson(Map<String,dynamic> map) :
        status = map["status"],
        msg = map["msg"];

  bool isOk() {
    return status == "OK";
  }
}