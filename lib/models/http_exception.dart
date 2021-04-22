class HttpException implements Exception {
  final message;

  HttpException(this.message);

  @override
  String toString() {
    print('HttpException Class.');
    return message;
  }
}
