class CRUD {
  int statusCode;
  bool success;
  String message;
  String payload;
  CRUD({this.statusCode, this.success, this.payload, this.message});
  factory CRUD.fromJson(Map json) {
    return CRUD(
        statusCode: json['status'],
        message: json['message'],
        success: json['sucess'],
        payload: json['payload']);
  }
}
