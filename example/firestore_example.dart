import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

void main() async {
  // 1. Define your fields using FireValue<T>

  final nameField = FireValue<String>(
    'name',
    toFire: user.name.toFire(), // pulling the value from local 'user' object
  );

  final emailField = FireValue<String>(
    'email',
    toFire: user.email.toFire(),
  );

  final signupDateField = FireValue<DateTime>(
    'signupDate',
    toFire: user.signupDate.toFire(),
  );

  // 2. Create a Firestore document with the fields

  final userDoc = [nameField, emailField, signupDateField]
      .firestoreNewDoc('users', user.id);

  // 3. Perform operations (write, read, delete)

  await userDoc.write(); // Writes the data to Firestore
  await userDoc
      .read(); // Reads the data and handles it according to your 'fromFire' logic
  await userDoc.delete(); // Deletes the document from Firestore
}

// A simple example user class
class User {
  final String id;
  final String name;
  final String email;
  final DateTime signupDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.signupDate,
  });
}

// A pretend local user instance
final user = User(
  id: 'user123',
  name: 'Alice',
  email: 'alice@example.com',
  signupDate: DateTime.now(),
);
