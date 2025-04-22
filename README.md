![img](https://i.imgur.com/uo7fSJm.png)

<h3 align="center"><i>Firebase without the fuss.</i></h3>
<p align="center">
        <img src="https://img.shields.io/codefactor/grade/github/jozzzzep/firefast/main?style=flat-square">
        <img src="https://img.shields.io/github/license/jozzzzep/firefast?style=flat-square">
        <img src="https://img.shields.io/pub/points/firefast?style=flat-square">
        <img src="https://img.shields.io/pub/v/firefast?style=flat-square">
</p>

Define fields once, then just `.write()`, `.read()`, `.delete()`.  
Type-safe. Clean. Fast. Easy. No string keys. No casting. No boilerplate.

**Supports:** `Firestore`, `Realtime Database` (in progress)  
**Coming soon:** Auth, Storage, Remote Config, App Check, Functions, and more.

---

## 🛠 Roadmap

- [x] Core Functionality
- [x] Firestore
- [ ] Documentation
- [ ] Smart Caching
- [ ] Rate Limits
- [ ] Realtime Database
- [ ] Firebase Auth
- [ ] Storage
- [ ] Remote Config
- [ ] App Check
- [ ] Functions

---

## 🚀 Example

And this is just the tip of the iceberg!

```dart
final nameField = Firefast.field<String>(
  name: 'name',
  toFire: () async => getUser().name,
  fromFire: (raw) => raw.toString(),
);

final name = FirefastStore.col('users').doc('alice').toField(name);    // Same
final name = namefield.firestoreNewDoc('users', 'alice');              // Same
final doc = FirefastStore.col('users').doc('alice').withField(name);   // Document

await name.write();    // write 'name' field
await name.read();     // returns 'Alice'
await name.delete();   // deletes the field

await doc.write();    // writes all fields in the document
await doc.read();     // reads all defined fields
await doc.delete();   // deletes the entire document
```

---

## 🎯 Why Firefast?

✅ **Minimal Boilerplate** – define once, reuse anywhere  
✅ **Separation of Concerns** – field logic lives in the field  
✅ **Type Safety** – avoid runtime errors and `dynamic`  
✅ **Composable** – easily construct documents, subcollections, fields  
✅ **Scalable** – works across all Firebase services (Firestore, RTDB, and more coming)  
✅ **Clean API** – no manual `set()`, `get()`, or `Map<String, dynamic>` juggling

---

## 🔧 Under the Hood

- Built on a modular path system (`col().doc().withFields()`)
- Abstracted data sources (`FastDataPathSource`) allow plug-and-play with Firestore, Realtime DB, Remote Config, etc.
- Extensible caching system (`FireCacheBox`) with cooldowns and offline strategies (coming soon)

---

## 📦 Installation

```yaml
dependencies:
  firefast: ^latest
```

---

## Contribute

Pull requests, feedback, and ideas are welcome!  
Help shape a better Firebase developer experience.
