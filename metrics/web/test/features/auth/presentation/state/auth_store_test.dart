import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:test/test.dart';

void main() {
  final AuthStore authStore = AuthStore();

  test("User is not authenticated after subscribe to a user updates", () {
    authStore.subscribeToAuthenticationUpdates();

    expect(authStore.isLoggedIn, isFalse);
  });

  test("User is authenticated after sign in", () {
    const email = 'test@test.com';
    const password = 'someTestPassword';

    authStore.signInWithEmailAndPassword(email, password);

    expect(authStore.isLoggedIn, isTrue);
  });

  test("User is not authenticated after sign out", () {
    authStore.signOut();

    expect(authStore.isLoggedIn, isFalse);
  });

  tearDownAll(() {
    authStore.dispose();
  });
}
