import 'package:firefast/firefast_core.dart';
import 'package:firefast/firefast_firestore.dart';

extension FireFieldExtension<T> on FireValue {
  FirestoreDocument firestore(FirestoreDocumentPath document) =>
      [this].firestore(document);

  FirestoreDocument firestoreNewDoc(String collection, String documentId) =>
      firestore(FirefastStore.col(collection).doc(documentId));
}

extension FireFieldListExtension on List<FireValue> {
  FirestoreDocument firestore(FirestoreDocumentPath document) =>
      FirestoreDocument(path: document, fireValues: this);

  FirestoreDocument firestoreNewDoc(String collection, String documentId) =>
      firestore(FirefastStore.col(collection).doc(documentId));
}
