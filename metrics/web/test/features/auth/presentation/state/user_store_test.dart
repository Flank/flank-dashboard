import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';

void main() {
  UserStore userStore;

  setUpAll(() {
    userStore = UserStore();
  });

  test('User is not authenticated after subscribe to a user updates', () {
    userStore.subscribeToUserUpdates();

    expect(userStore.isLoggedIn, false);
  });

  test('User is authenticated after sign in', () {
    const email = 'test@test.com';
    const password = 'someTestPassword';

    userStore.signInWithEmailAndPassword(email, password);

    expect(userStore.isLoggedIn, true);
  });

  test('User is not authenticated after sign out', () {
    userStore.signOut();

    expect(userStore.isLoggedIn, false);
  });

  tearDownAll(() {
    userStore.dispose();
  });
}
