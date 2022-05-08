import 'package:movie_app/src/models/index.dart';

abstract class AuthApiBase {
  Future<AppUser> create({required String email, required String password, required String username});

  Future<AppUser?> getCurrentUser();

  Future<AppUser> login({required String email, required String password});

  Future<void> logOut();

  Future<void> updateFavorites(String uid, int id, {required bool add});

  Future<AppUser> getUser(String uid);
}
