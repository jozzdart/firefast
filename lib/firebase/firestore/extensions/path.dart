import 'package:firefast/firefast_firestore.dart';

extension CollectionPathExtensions on FirestoreCollectionPath {
  FirestoreDocumentPath doc(String documentId) =>
      child(documentId).toFirestoreDocument();
}

extension DocumentExtensions on FirestoreDocumentPath {
  FirestoreCollectionPath col(String collection) =>
      child(collection).toFirestoreCollection();

  FirestoreDocument withFields(List<FirestoreField> fields) {
    return FirestoreDocument.fromFields(document: this, fields: fields);
  }

  FirestoreDocument withField(FirestoreField field) => withFields([field]);

  FirestoreDocument addField(FirestoreField field) => withField(field);

  FirestoreDocument addFields(List<FirestoreField> fields) =>
      withFields(fields);

  FirestoreDocumentPath sub(String collection, String docId) =>
      FirestoreDocumentPath(
          docId, parent!.toFirestoreCollection().doc(segment).col(collection));
}
