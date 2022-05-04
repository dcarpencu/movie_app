import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/src/data/auth_base_api.dart';
import 'package:movie_app/src/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kFavoriteMoviesKey = 'user_favorite_movies';

class AuthApi implements AuthApiBase{
  AuthApi(this._auth, this._preferences);

  final FirebaseAuth _auth;
  final SharedPreferences _preferences;

  @override
  Future<AppUser?> getCurrentUser() async {
    if (_auth.currentUser != null) {
      final List<int> favorites = _getCurrentFavorite();

      return AppUser(
        uid: _auth.currentUser!.uid,
        email: _auth.currentUser!.email!,
        username: _auth.currentUser!.displayName!,
        favoriteMovies: favorites,
      );
    }
    return null;
  }

  @override
  Future<AppUser> login({required String email, required String password}) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);

    final List<int> favorite = _getCurrentFavorite();

    return AppUser(
      uid: credential.user!.uid,
      email: email,
      username: credential.user!.displayName!,
      favoriteMovies: favorite,
    );
  }

  @override
  Future<AppUser> create({required String email, required String password, required String username}) async {
    final UserCredential credentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _auth.currentUser!.updateDisplayName(username);

    return AppUser(
      uid: credentials.user!.uid,
      email: email,
      username: username,
    );
  }

  @override
  Future<void> logOut () async {
    await _auth.signOut();
  }

  @override
  Future<void> updateFavorites(int id, {required bool add}) async {
    final List<int> ids = _getCurrentFavorite();
    
    if(add) {
      ids.add(id);
    } else {
      ids.remove(id);
    }
   

    await _preferences.setString(_kFavoriteMoviesKey, jsonEncode(ids));
  }

  List<int> _getCurrentFavorite() {
    final String? data = _preferences.getString(_kFavoriteMoviesKey);

    List<int> ids;
    if(data != null) {
      ids = List<int>.from(jsonDecode(data) as List<dynamic>);
    } else {
      ids = <int>[];
    }
    return ids;
  }
}


