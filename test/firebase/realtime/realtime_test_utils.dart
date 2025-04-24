import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firefast/firefast_realtime.dart';

/// A utility class for setting up Firestore tests
class RealtimeTestUtils {
  /// Creates a FastFirestore instance with a fake FirebaseFirestore for testing
  static FirefastReal createTestFirefast() {
    return FirefastReal(
      MockFirebaseDatabase(),
    );
  }

  static void setUpFireTests() {
    final fakeServices = createTestFirefast();
    FirefastReal.overrideInstance(fakeServices);
  }

  static void clearServices() {
    FirefastReal.resetInstance();
  }
}
