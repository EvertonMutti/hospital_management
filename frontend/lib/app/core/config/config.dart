
class Enviroment {
    Enviroment._();
    static final Enviroment instance = Enviroment._();
    
    static const String env = String.fromEnvironment('ENV');
    static const String version = String.fromEnvironment('VERSION');
    static const String apiBaseUri = String.fromEnvironment('API_URL');
    static const String apiKey = String.fromEnvironment('MARKETPLACEAPIKEY');
}
