class Endpoints {
  static final Endpoints instance = Endpoints._();
  Endpoints._();

  static String login = "/client/login";
  static String listBeds = "/bed";
  static String countBeds = "/bed/status/count";
  static String listHospitals = "/hospitals";

  static String admission = "/admission";
  static String discharge = "/discharge";

  static String availablePatients(String hospitalTaxNumber) {
    return "/patients/$hospitalTaxNumber/unadmitted";
  }
}
