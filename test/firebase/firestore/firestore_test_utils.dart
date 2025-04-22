import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firefast/firefast_firestore.dart';

/// A utility class for setting up Firestore tests
class FirestoreTestUtils {
  /// Creates a FastFirestore instance with a fake FirebaseFirestore for testing
  static FirefastStore createTestFirefast() {
    return FirefastStore(
      FakeFirebaseFirestore(),
    );
  }

  static void setUpFireTests() {
    final fakeServices = createTestFirefast();
    FirefastStore.overrideInstance(fakeServices);
  }

  static void clearServices() {
    FirefastStore.resetInstance();
  }
}
