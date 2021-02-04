// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:metrics/auth/data/adapter/firebase_user_adapter.dart';
import 'package:metrics/auth/domain/entities/user.dart';
import 'package:test/test.dart';

void main() {
  group("FirebaseUserAdapter", () {
    test("throws an ArgumentError if the given firebase user is null", () {
      expect(() => FirebaseUserAdapter(null), throwsArgumentError);
    });

    test("adapts FirebaseUser to a User", () {
      const id = 'id';
      const email = 'email';

      final firebaseUser = FirebaseUserStub(
        uid: id,
        email: email,
      );
      final expectedUser = User(
        id: id,
        email: email,
      );

      final adaptedUser = FirebaseUserAdapter(firebaseUser);

      expect(adaptedUser, isA<User>());
      expect(adaptedUser.id, expectedUser.id);
      expect(adaptedUser.email, expectedUser.email);
    });
  });
}

class FirebaseUserStub implements FirebaseUser {
  @override
  final String uid;

  @override
  final String email;

  FirebaseUserStub({this.uid, this.email});

  @override
  Future<void> delete() async {}

  @override
  String get displayName => null;

  @override
  Future<IdTokenResult> getIdToken({bool refresh = false}) async {
    return null;
  }

  @override
  bool get isAnonymous => false;

  @override
  bool get isEmailVerified => true;

  @override
  Future<AuthResult> linkWithCredential(AuthCredential credential) async {
    return null;
  }

  @override
  FirebaseUserMetadata get metadata => null;

  @override
  String get phoneNumber => null;

  @override
  String get photoUrl => null;

  @override
  List<UserInfo> get providerData => null;

  @override
  String get providerId => null;

  @override
  Future<AuthResult> reauthenticateWithCredential(
      AuthCredential credential) async {
    return null;
  }

  @override
  Future<void> reload() async {}

  @override
  Future<void> sendEmailVerification() async {}

  @override
  Future<void> unlinkFromProvider(String provider) async {}

  @override
  Future<void> updateEmail(String email) async {}

  @override
  Future<void> updatePassword(String password) async {}

  @override
  Future<void> updatePhoneNumberCredential(AuthCredential credential) async {}

  @override
  Future<void> updateProfile(UserUpdateInfo userUpdateInfo) async {}
}
