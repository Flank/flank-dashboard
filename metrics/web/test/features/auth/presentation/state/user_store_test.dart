import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:test/test.dart';

void main() {
  final UserStore userStore = UserStore();

  test("User is not authenticated after subscribe to a user updates", () {
    userStore.subscribeToUserUpdates();

    expect(userStore.isLoggedIn, isFalse);
  });

  test("User is authenticated after sign in", () {
    const email = 'test@test.com';
    const password = 'someTestPassword';

    userStore.signInWithEmailAndPassword(email, password);

    expect(userStore.isLoggedIn, isTrue);
  });

  test("User is not authenticated after sign out", () {
    userStore.signOut();

    expect(userStore.isLoggedIn, isFalse);
  });

  tearDownAll(() {
    userStore.dispose();
  });
}
