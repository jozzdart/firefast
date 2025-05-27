<a id="back-to-top"></a>
![img](https://i.imgur.com/uo7fSJm.png)

<h3 align="center"><i>Firebase without the fuss.</i></h3>
<p align="center">
        <img src="https://img.shields.io/codefactor/grade/github/jozzdart/firefast/main?style=flat-square">
        <img src="https://img.shields.io/github/license/jozzdart/firefast?style=flat-square">
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
- [x] Realtime Database
- [ ] Documentation
- [ ] Smart Caching
- [ ] Rate Limits
- [ ] Firebase Auth
- [ ] Storage
- [ ] Remote Config
- [ ] App Check
- [ ] Functions

---

# Philosophy

**Firefast** was built out of real-world frustration:

- Constantly using **string keys** everywhere (prone to typos and errors).
- Repeating **serialization and parsing** code again and again.
- Handling **different data types** manually across Firestore, Realtime Database, and others.
- Struggling to maintain **clean separation of concerns**.

Firefast solves this by letting you define **fields** once — type-safe, clean, and automatic — and then just call `.write()`, `.read()`, `.delete()` without worrying about anything else.  
No more messy strings, no boilerplate serialization, no manual conversions.

You define your data model once — the fields know how to serialize, deserialize, validate, adapt, and fetch themselves.

And that's it.

---

# Why no `await read()` returning data?

In Firefast, when you call:

```dart
await document.read();
```

it **does not** return anything.

Because everything was already defined beforehand — **what to read**, **how to adapt it**, **where to save it**, **how to validate it**.  
You don't need to "handle the result" manually.  
It's clean. It's safe. It's scalable.

---

# Fields First: Define Once, Use Everywhere

You define **fields** using `FireValue<T>` objects — strongly typed and automatically adapted to any database.

✅ **Native Dart types**:  
`int`, `bool`, `double`, `String`, `DateTime`, `Uint8List`, `Map<String, dynamic>`, etc.

✅ **Database Adaptation**:  
Bytes? Automatically become Firestore `Blob`s or encoded for Realtime DB.  
DateTime? Automatically mapped as timestamps.  
Maps? Automatically stored as JSON or object fields.

✅ **Events**:  
Define what happens when a new value is fetched — once.

✅ **Guards** (Optional):  
Add permission checks, rate limits, or other conditions without touching your database logic.

---

# Small Example: First Field

```dart
final nameField = FireValue<String>(
  'name',
  toFire: user.name.toFire(),
  // fromFire:  optional
);
```

Now this field knows:

- Its **name** ("name")
- Its **type** (`String`)
- **How to pull the data locally** when writing to the database
- **(Optionally)** how to handle new data when reading from the database

You can define fields with **only `toFire`**, **only `fromFire`**, or **both**.

You can also easily use `.toFire()` on simple values without custom logic:

```dart
final ageField = FireValue<int>(
  'age',
  toFire: 30.toFire(), // send to fire
);
```

Or use full control if needed:

```dart
final backupField = FireValue<Uint8List>(
  'dataBackup',
  toFire: ToFire(generateBackup),    // send to fire
  fromFire: FromFire(restoreBackup), // get from fire
);
```

---

# Node / Document: Build Once

Now you link your fields to a document or a realtime node:

```dart
final userDoc = nameField.firestoreNewDoc("users", userId);
```

Or with multiple fields:

```dart
[nameField, ageField].firestoreNewDoc("users", userId);
```

---

# Then, Just Use It

Write:

```dart
await userDoc.write();
```

Read:

```dart
await userDoc.read();
```

Delete:

```dart
await userDoc.delete();
```

And you're done. No parameters. No strings. No casting. No parsing. All defined once.

---

# Firefast is About

- **Type safety** ✅
- **One-time field definition** ✅
- **Automatic adaptation to any database** ✅
- **Built-in event handling** ✅
- **Optional validation & permission guards** ✅
- **No runtime string keys, no runtime parsing** ✅
- **Clear separation between business logic and database operations** ✅

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

[⤴️ Back](#back-to-top) -> Table of Contents
