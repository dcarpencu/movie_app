import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/src/mocktail.dart';
import 'package:movie_app/src/data/auth_api.dart';
import 'package:movie_app/src/models/index.dart';

class MockFirebaseAuth with Mock implements FirebaseAuth {}

class MockFirebaseFireStore with Mock implements FirebaseFirestore {}

class MockDocumentRefence with Mock implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot with Mock implements DocumentSnapshot<Map<String, dynamic>> {}

final Map<String, dynamic> userData =
jsonDecode(File('./test/unit/reducer/res/user.json').readAsStringSync()) as Map<String, dynamic>;

Future<void> main() async {

  late FirebaseAuth auth;
  late AuthApi api;
  late FirebaseFirestore firestore;
  late MockDocumentRefence ref;
  late MockDocumentSnapshot snapshot;

  setUp(() {
    auth = MockFirebaseAuth();
    firestore = MockFirebaseFireStore();
    ref = MockDocumentRefence();
    snapshot = MockDocumentSnapshot();
    api = AuthApi(auth, firestore);
  });

    test('logOut', () async {
      when(auth.signOut).thenAnswer((_) async {});

      await api.logOut();

      final VerificationResult result = verify(auth.signOut);
      expect(result.callCount, 1);
  });

  test('getUser', () async {
    when(() => firestore.doc(captureAny())).thenReturn(ref);
    when(() => ref.get()).thenAnswer((_) async => snapshot);
    when(snapshot.data).thenReturn(userData);

    const String uid = 'uid';
    final AppUser expected = await api.getUser(uid);

    expect(expected, AppUser.fromJson(userData));
  });
}