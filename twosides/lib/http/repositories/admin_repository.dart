import 'package:twosides/models/auth.dart';

abstract class AdminRepository {
  Future<Auth> login(String email, String password);
  Future<Auth> logout();
  Future<Auth> adminCheck();
}