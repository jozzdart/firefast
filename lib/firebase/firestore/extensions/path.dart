import 'package:firefast/firefast_core.dart';

import '../firestore.dart';

extension CollectionPathExtensions on FirestoreCollectionPath {
  FirestoreDocumentPath doc(String documentId) =>
      child(documentId).toFirestoreDocument();
}

extension DocumentExtensions on FirestoreDocumentPath {
  FirestoreCollectionPath col(String collection) =>
      child(collection).toFirestoreCollection();

  FirestoreDocument withFields(List<FireValue> values) {
    return FirestoreDocument(path: this, fireValues: values);
  }

  FirestoreDocument withField(FireValue value) => withFields([value]);

  FirestoreDocument addField(FireValue value) => withField(value);

  FirestoreDocument addFields(List<FireValue> values) => withFields(values);

  FirestoreDocumentPath sub(String collection, String docId) =>
      FirestoreDocumentPath(
          docId, parent!.toFirestoreCollection().doc(segment).col(collection));
}
