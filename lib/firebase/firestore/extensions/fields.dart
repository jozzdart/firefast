import 'package:firefast/firefast_firestore.dart';

extension FireFieldExtension<T> on FirestoreField {
  FirestoreDocument firestore(FirestoreDocumentPath document) =>
      [this].firestore(document);

  FirestoreDocument firestoreNewDoc(String collection, String documentId) =>
      firestore(FirefastStore.col(collection).doc(documentId));
}

extension FireFieldListExtension on List<FirestoreField> {
  FirestoreDocument firestore(FirestoreDocumentPath document) =>
      FirestoreDocument.fromFields(document: document, fields: this);

  FirestoreDocument firestoreNewDoc(String collection, String documentId) =>
      firestore(FirefastStore.col(collection).doc(documentId));
}
