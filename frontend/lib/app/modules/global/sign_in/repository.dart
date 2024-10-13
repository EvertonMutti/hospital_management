import '../core/model/login_model.dart';

abstract class SignInRepository {
  Future<LoginModel> getUser(body);
}
