class Loading {
  bool status;
  String message;

  Loading({this.status = false, this.message = ""});

  showLoading(String message) {
    status = true;
    message = message;
  }
}
