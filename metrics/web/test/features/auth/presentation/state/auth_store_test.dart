import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:test/test.dart';

void main() {
  group("AuthStore", () {
    final authStore = AuthStore();

    test("user is not authenticated after subscribe to a user updates", () {
      authStore.subscribeToAuthenticationUpdates();

      expect(authStore.isLoggedIn, isFalse);
    });

    test("user is authenticated after sign in", () {
      const email = 'test@test.com';
      const password = 'someTestPassword';

      authStore.signInWithEmailAndPassword(email, password);

      expect(authStore.isLoggedIn, isTrue);
    });

    test("user is not authenticated after sign out", () {
      authStore.signOut();

      expect(authStore.isLoggedIn, isFalse);
    });

    tearDownAll(() {
      authStore.dispose();
    });
  });
}
