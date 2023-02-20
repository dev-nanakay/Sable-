class ResponseMap{
String body;
  int responseCode;
  String error;
  ResponseMap(this.responseCode, this.body, this.error);

  @override
  String toString() {
    return 'ResponseMap{body: $body, responseCode: $responseCode, error: $error}';
  }
}