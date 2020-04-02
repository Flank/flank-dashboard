import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/user_metrics_store.dart';

void main() {
  UserMetricsStore userMetricsStore;

  setUpAll(() {
    userMetricsStore = UserMetricsStore();
  });

  test('User is not authenticated after subscribe to a user updates', () {
    userMetricsStore.subscribeToUserUpdates();

    expect(userMetricsStore.isLoggedIn, false);
  });

  test('User is authenticated after sign in', () async {
    const email = 'test@test.com';
    const password = 'someTestPassword';

    await userMetricsStore.signInWithEmailAndPassword(email, password);

    expect(userMetricsStore.isLoggedIn, true);
  });

  test('User is not authenticated after sign out', () async {
    await userMetricsStore.signOut();

    expect(userMetricsStore.isLoggedIn, false);
  });

  tearDownAll(() {
    userMetricsStore.dispose();
  });
}
