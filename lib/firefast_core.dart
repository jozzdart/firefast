/// A foundational Dart library for building type-safe, path-based data access layers.
///
/// The Firefast Core library provides the essential building blocks for creating
/// strongly-typed data access patterns. While designed with Firebase in mind,
/// these core components can be used to build type-safe access layers for any
/// data source that follows a path-based structure.
///
/// ## Key Features
///
/// * **Path Management**: Abstract representation of data paths with type safety
/// * **Field Definitions**: Type-safe field definitions with conversion utilities
/// * **Data Operations**: Generic CRUD operations for path-based data sources
/// * **Extension Methods**: Utilities to enhance working with fields and paths
/// * **Composable Architecture**: Building blocks that can be combined for complex use cases
///
/// ## Main Components
///
/// ### Path Management
/// * [PathSegment]: Represents a segment in a data path
/// * [FireDataPathObject]: Base class for path-based data objects
/// * [FireDataPathObjectSource]: Links path objects to their data source
///
/// ### Field Handling
/// * [FireField]: Represents a strongly-typed field with conversion methods
/// * [FireFieldSet]: A collection of fields that belong together
/// * [FirePathField]: A field associated with a specific data path
///
/// ### Data Operations
/// * [FastPathRead]: Abstract read operations for path-based data
/// * [FastPathWrite]: Abstract write operations for path-based data
/// * [FastPathOverwrite]: Abstract overwrite operations for path-based data
/// * [FastPathDelete]: Abstract delete operations for path-based data
/// * [FastPathSourceBase]: Base implementation for a path-based data source
///
/// ### Output Processing
/// * [FireFieldOutput]: Handles output of a single field
/// * [FireFieldsOutput]: Handles output of multiple fields
///
/// ## Example Usage
///
/// While typically used through higher-level libraries like `firefast_firestore`,
/// the core components can be used directly:
///
/// ```dart
/// // Define a typed field
/// final nameField = FireField<String>(
///   name: 'name',
///   toFire: (value) => value,
///   fromFire: (value) => value as String,
/// );
///
/// // Create a field set
/// final personFields = [nameField, ageField].toFireSet();
///
/// // Implement a custom path source
/// class MyDataSource extends FastPathSourceBase<Map<String, dynamic>, MyDatabase> {
///   // Implementation details...
/// }
/// ```

library;

export 'core/adapters/fire_adapters.dart';
export 'core/adapters/list_fire_adapters.dart';
export 'core/adapters/typedefs.dart';

export 'core/models/fire_field.dart';
export 'core/models/fire_port.dart';
export 'core/models/fire_set_output.dart';
export 'core/models/fire_set.dart';
export 'core/models/fire_set_base.dart';
export 'core/models/typedefs.dart';
export 'core/models/operations_no_params.dart';
