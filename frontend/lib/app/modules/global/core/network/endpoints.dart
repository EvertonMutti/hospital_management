class Endpoints {
  static final Endpoints instance = Endpoints._();
  Endpoints._();

  static String login = "/client/login";
  static String listBeds = "/bed";
  static String countBeds = "/bed/status/count";
  static String listHospitals = "/hospitals";
}
