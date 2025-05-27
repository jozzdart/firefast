## 0.1.6

- **Fixed Firestore binary data writing bug due to incorrect generic inference:**

  - Reworked all generic default parameters in `FirePortOperation`, `FromFire`, and `ToFire` to explicitly use `EmptyValueGuard<T>` instead of inferring `EmptyValueGuard<Null>`.
  - This bug caused runtime type errors (`Uint8List is not a subtype of Null`) when writing binary (`Uint8List`) fields to Firestore.

- **Added tests** to validate Firestore binary field writes and ensure proper generic handling.

## 0.1.5

- Fixed iOS Firestore binary field bug:
  - Improved `BlobFireAdapter` to handle both `Blob` and `List<dynamic>` types when reading data
  - Prevented type casting error on iOS when decoding binary Firestore fields

## 0.1.4

- Updated README

## 0.1.3

- Changed operation function return types for better error handling:
  - All operations (write, overwrite, delete) now return `String?`:
    - Returns error message as String if operation fails
    - Returns null if operation succeeds
  - Read operations now return `OperationOutputReader?`:
    - Returns null if read fails or data doesn't exist
    - Returns `OperationOutputReader` with data if successful
  - Previously all operations were void, making error handling more difficult

## 0.1.2

- Updated `prf` dependency to version 2.2.4 from 2.1.3

## 0.1.1

- Added new operation guard implementations:
  - `OperationLimiterBase` - Base interface for limit-based guards with `isLimited()` and `update()` methods
  - `RateLimiterGuard` - Implementation using `PrfRateLimiter` for rate-limited operations
  - `CooldownGuard` - Implementation using `PrfCooldown` for cooldown-based operation limiting

## 0.1.0

### Major update: **Unified `FireValue` model across all datasources**:

- Replaced `FirestoreField<T>` and `RealtimeField<T>` with a single, universal `FireValue<T>`:
  - Cleaner, scalable design
  - Works seamlessly with Firestore, Realtime Database, and future datasources (Remote Config, Storage, etc.)
  - Strong type safety with native Dart types (`int`, `bool`, `double`, `String`, `DateTime`, `Uint8List`, `Map<String, dynamic>`)
  - Built-in flexible `toFire` and `fromFire` operations:
    - Optional definition
    - Supports simple `.toFire()` for basic values
    - Supports full custom logic for complex data transformations
- Automatic adapter resolution based on database and data type:
  - Example: `Uint8List` is automatically stored as Firestore `Blob` or encoded for Realtime Database
  - `DateTime` automatically mapped to Firestore `Timestamp`
  - Maps automatically handled for Firestore/Realtime JSON structures
- Enhanced field behavior:
  - Native `.write()`, `.read()`, `.overwrite()`, `.delete()` operations without needing manual path or data management
  - No runtime string keys or casting needed — everything defined once and type-safe
- Introduced **Operation Guards**:
- Optional conditions to block or allow read, write, delete operations dynamically
- Example use-cases: rate limiting, permission checks, feature flags
- Introduced **Value Guards**:
- Field-level dynamic blocking logic based on current app state or external conditions
- Allow fine-grained control for reading or writing specific fields
- Clean and predictable API philosophy:
- All operations (`read`, `write`, `delete`) are **void** by design:
  - Data handling logic is defined once at field creation
  - No runtime fetching or ad-hoc serialization logic
  - Strict separation of concerns between field definition and operations
- Seamless upgrade path:
- Minimal migration from older `FirestoreField` / `RealtimeField` required
- Just redefine using `FireValue` and retain same structure and behavior

## 0.0.21

- Added testing framework for `firefast_realtime`:
  - `RealtimeTestUtils` for core utilities:
    - `FirefastReal` factory with `MockFirebaseDatabase`
    - Isolated service management
    - Consistent setup/teardown
  - Extensive `FirefastReal` tests:
    - CRUD, nested structures, edge cases
    - Type handling for primitives, arrays, maps
    - Root-level, sequential, and concurrent operations
    - Type conversion, null, and deletion handling

## 0.0.20

- Completed implementation of the Firebase Realtime Database library:
  - Core models for Realtime Database:
    - `RealtimeNodePath` - Type-safe representation of database node paths
    - `RealtimeNode` - Main node class with integrated field management
    - `RealtimeField<T>` - Field implementation with automatic adapter resolution
    - `FireRealtimeAdapters` - Dedicated adapter system for Realtime Database types
  - Comprehensive datasource implementation with `FirefastReal`:
    - Singleton service pattern with override capability for testing
    - Complete CRUD operations implementation for database nodes
    - Integrated with path-based operations from core library
    - Automatic type conversion for complex data structures
  - Powerful extension methods for fluid API:
    - `RealtimeNodePathExtensions` - Node field operations
    - `PathSegmentRealtimeExtensions` - Conversion utilities for path types
    - `FireFieldListRealtimeExtensions` and `FireFieldRealtimeExtensions` - Node creation helpers
  - Streamlined builder pattern for node construction:
    - Type-safe field management
    - Fluent API for building node hierarchies
    - Simplified path navigation
  - Comprehensive library exports with `firefast_realtime.dart`

## 0.0.19

- Added type adapters for Firebase Realtime Database:
  - Created `RealtimeAdapters` central registry extending `FireAdapterMap`:
    - Singleton pattern for global type resolution
    - Automatic adapter registration system
  - Implemented list handling with `RealtimeListAdapters<T>`:
    - Generic implementation for all types of lists
    - Type-safe list conversion for Realtime Database
    - Built-in support for common types: bool, int, double, String, Uint8List, DateTime

## 0.0.18

- Introduced the base testing framework for `firefast_firestore`:
  - `FirestoreTestUtils` for core testing utilities:
    - `FirefastStore` factory with fake Firestore
  - Extensive `FirefastStore` tests:
    - CRUD operations, nested structures, collections, edge cases
    - Sequential and stress tests
  - Path operation tests:
    - Path construction, hierarchy, and integrity
    - Document navigation and path equivalence
    - Integration with document operations

## 0.0.17

- Completed implementation of the firefast_firestore library:
  - Firestore-specific document and collection models:
    - `FirestoreDocumentPath` and `FirestoreCollectionPath` - Type-safe path representations for Firestore structure
    - `FirestoreDocument` - Main document class with integrated field management
    - `FirestoreField<T>` - Specialized field implementation with automatic Firestore adapter resolution
    - `FirestoreDocumentOutput` - Type-safe output container for Firestore document data
  - Comprehensive datasource implementation with `FirefastStore`:
    - Singleton service pattern with override capability for testing
    - Complete CRUD operations implementation for Firestore documents
    - Integrated with path-based operations from core library
    - Merge-aware write vs. overwrite operations
  - Powerful extension methods for fluid API:
    - `CollectionPathExtensions` - Easy document access from collections
    - `DocumentExtensions` - Rich navigation between documents and subcollections
    - `PathSegmentFirestoreExtensions` - Conversion utilities for Firestore path types
    - `FireFieldExtension` and `FireFieldListExtension` - Document creation helpers for individual fields and field lists
  - Streamlined builder pattern for document construction:
    - Simplified creation of documents with one or multiple fields
    - Fluent API for building document hierarchies
    - Type-safe field navigation and manipulation

## 0.0.16

- Started implementing the firefast_firestore library with new core tools:
  - Comprehensive Firestore type adapter system:
    - `FirestoreAdapters` - Central registry extending `FireAdapterMap` for Firestore-specific types
    - Automatic registration system for all Firestore data types
    - Specialized Firestore type converters:
      - `TimestampFireAdapter` - Converts between Firestore Timestamp and Dart DateTime
      - `GeoPointFireAdapter` - Handles Firestore GeoPoint objects
      - `BlobFireAdapter` - Manages binary data with Uint8List and Firestore Blob
      - `DocumentReferenceFireAdapter` - Supports Firestore document references
    - Enhanced list handling with `FirestoreListAdapters<T>`:
      - Generic implementation for any type of list
      - Automatic type resolution for list elements
      - Built-in support for common types: bool, int, double, String, Uint8List, DateTime
    - Streamlined part-based architecture for better code organization
    - Complete type-safety with proper generics throughout

## 0.0.15

- Added comprehensive path-based data handling system in core/path:
  - `PathSegment` - Hierarchical path representation with parent-child relationships
    - Fluent API for building nested paths with `child()` method
    - Automatic path string generation with proper delimiters
  - Standardized path-based operations interfaces:
    - `ReadOnPath<D>` - Type-safe read operations at a specific path
    - `WriteOnPath<D>` - Type-safe write operations at a specific path
    - `OverwriteOnPath<D>` - Complete data replacement at a specific path
    - `DeleteOnPath` - Data removal at a specific path
  - Enhanced data objects with path context:
    - `DataOnPathObject<O>` - Interface combining CRUD operations for objects at paths
    - `DataOnPathWithSource<S, O>` - Extension with integrated data source
    - `PathBasedDataSource<D, S>` - Abstract foundation for path-based data sources
  - Advanced field set operations:
    - `FireSetOnPath<S, P, Self>` - Self-referential generic for type-safe path operations
    - Field-level operations including selective field deletion
    - Type-safe field retrieval with automatic deserialization
    - Path-aware field set manipulations with immutable pattern

## 0.0.14

### Core Models Rewrite

- Continued rewrite of core library with focus on core/models:
  - Renamed `FireField` to `FireFieldBase` - now by default is unusable unless using specific library (not core)
  - Renamed `FireFieldSet` to `FireSet` - now a generic strongly typed map builder based on values
  - Introduced `FirePort<T>` abstract class as the foundation for data transfer operations:
    - Provides a consistent interface for bidirectional data flow with Firebase
    - Includes validation and cancellation capabilities through functional callbacks
  - Advanced field validation and processing:
    - `isValid<T>` function allows conditional validation of field values before database operations
    - `shouldCancelAll<T>` function enables cancellation of entire operations based on single field conditions
    - Both validation functions are composable and can be chained together for complex validation logic
  - Enhanced data flow mechanics:
    - `ToFireDelegate<T>` handles outgoing data preparation before adapter conversion
    - `FromFireDelegate<T>` processes incoming data after adapter conversion
    - Complete control over data transformation at each step of the Firebase interaction
  - Improved `FireSetBase<O>` abstract class with cleaner API for data conversion:
    - Type-generic approach allows customization of output formats
    - Simplified method signatures for toMap/fromMap operations
  - Enhanced `FireSetOutput` with type-safe field access and better error handling:
    - Type-safe getters prevent runtime type errors
    - Detailed error messages when type conversion fails
  - Added `FieldTypeMismatchException` for clearer error detection when type conversion fails
  - Streamlined operation interfaces with `ReadNoParams`, `WriteNoParams`, `OverwriteNoParams`, and `DeleteNoParams`:
    - Simplified API for common database operations
    - Consistent interface patterns across different operation types

### Core Models Testing

- Added comprehensive test suite for core/models components:
  - `FireFieldBase` tests for initialization, inheritance, adapter conversion and type compatibility
  - `FireSet` tests for data conversion, validation, and error handling
  - `FirePort` tests for delegate execution and validation functions
  - `FireSetBase` tests for type-generic behavior and complex data structures
  - 50+ test cases with full coverage of edge cases and data type variations

## 0.0.13

- Comprehensive testing of adapter system:
  - Added 80 unit tests covering all adapter implementations
  - Complete test coverage for type conversion edge cases
  - Validation tests for all primitive type adapters (bool, int, double, String)
  - Verification tests for complex type adapters (DateTime, Uint8List, Map, List)
  - Integration tests for adapter registry and automatic type resolution

## 0.0.12

- Started rewrite of core library
- Enhanced adapter system implementation:
  - Integrated comprehensive type adapters for automatic Firebase data conversion
  - Included all possible adapter types for fast access without manual definition
  - `BaseFireAdapter` - Foundation adapter with toFire/fromFire conversion methods
  - `FireAdapter` - Type-safe adapter implementation with nullable support
  - `FireAdapterMap` - Registry system for type adapters with automatic registration
  - `ListFireAdapter` - Specialized adapter for handling lists of any type
  - Added adapters for primitive types (bool, int, double, String) and complex types (DateTime, Uint8List, Map, List)

## 0.0.11

- Enhanced cache services implementation:
  - `FireCacheBox` - Abstract wrapper for Firebase data objects with integrated caching and rate limiting
  - Improved cache rate limiting:
    - Enhanced integration between cache components and Firebase data objects
    - Optimized cache validation workflows
  - Cache service improvements:
    - Better integration with Firebase data sources

## 0.0.10

- Cache functionality with rate limiting implementation:
  - `FireCacheBox` - Abstract wrapper for data objects with cache and rate limiting functionality
  - `CacheLimiterBase` - Base interface for cache rate limiting implementations
  - `CooldownLimiter` - Cooldown-based implementation of rate limiting
  - Type definitions for cache operations:
    - `GetCacheFunction` - For retrieving cached data
    - `UpdateCacheFunction` - For updating cached data
    - `IsDataValidCache` - For validating data before caching

## 0.0.9

- Realtime Database extensions implementation:
  - `FireFieldRealtimeExtensions` - Extensions for converting core fields to Realtime Database fields
  - `FireFieldListExtensions` - Extensions for working with collections of fields in Realtime Database
  - `RealtimeNodePathExtensions` - Extensions for creating fields and nodes from paths
  - `PathSegmentRealtimeExtensions` - Conversion utilities for Realtime Database path types
  - `RealtimeNodeExtensions` - Helper methods for Realtime node operations

## 0.0.8

- Realtime Database models implementation:
  - `RealtimeNodePath` - Type-safe representation of Realtime Database node paths
  - `RealtimeNode` - Node class with type-safe field operations
  - `RealtimeField` - Type-safe field accessor for Realtime Database nodes
- Realtime Database services implementation:
  - `FirefastReal` - Singleton service for Realtime Database operations with CRUD methods

## 0.0.7

- Complete documentation added for all firefast_firestore components
- Added comprehensive test suite for all Firestore functionality
- Exported all Firestore components to a single `firefast_firestore.dart` barrel file

## 0.0.6

- Firestore extensions implementation:
  - `CollectionPathExtensions` - Extensions for working with Firestore collection paths
  - `DocumentExtensions` - Rich set of extensions for document path navigation and manipulation
  - `FireFieldExtension` - Helpers for creating Firestore fields from core fields
  - `FireFieldListExtension` - Utilities for working with collections of fields
  - `FirestoreDocumentExtensions` - Methods for adding and modifying document fields
  - `PathSegmentFirestoreExtensions` - Conversion utilities for Firestore path types
- Firestore services implementation:
  - `FirefastStore` - Singleton service for Firestore operations with simplified CRUD methods

## 0.0.5

- Firestore models implementation:
  - `FirestoreDocumentPath` - Type-safe representation of Firestore document paths
  - `FirestoreCollectionPath` - Type-safe representation of Firestore collection paths
  - `FirestoreDocument` - Document class with type-safe field operations
  - `FirestoreDocumentOutput` - Output wrapper for Firestore document data
  - `FirestoreField` - Type-safe field accessor for Firestore documents

## 0.0.4

- Basic core functionality complete
- Added documentation for all components in core directory
- Exported all core components to a single `firefast_core.dart` barrel file
- Added 90+ unit tests for all core components

## 0.0.3

- Core path implementation:
  - `PathSegment` - Base class for Firebase path representation with parent-child relationships
  - `FireDataPathObject` - Interface for path-based CRUD operations
  - `FireDataPathObjectSource` - Base implementation for data path objects with datasource
  - `FirePathField` - Implementation for single field operations at a specific path
  - `FirePathFields` - Collection of fields with path-based data operations
- Core extensions:
  - `FireFieldCoreExtensions` - Extensions for converting lists of FireField to FireFieldSet
- Core global:
  - `Firefast` - Main entry point with utility methods for path and field creation

## 0.0.2

- Core output implementation:
  - `FireFieldOutput` - Contains a field and its value from a database read
  - `FireFieldsOutput` - Collection of field outputs with type-safe accessor methods
- Core services implementation:
  - Abstract operations interfaces:
    - `FastPathRead` - Read operations by path
    - `FastPathWrite` - Write operations by path
    - `FastPathOverwrite` - Overwrite operations by path
    - `FastPathDelete` - Delete operations by path
  - No-parameter operation interfaces:
    - `FastReadNoParams` - Read operations without parameters
    - `FastWriteNoParams` - Write operations without parameters
    - `FastOverwriteNoParams` - Overwrite operations without parameters
    - `FastDeleteNoParams` - Delete operations without parameters
  - `FastDataPathSource` - Base implementation for data sources

## 0.0.1

- Initial release of the Firefast package
- Core models implementation:
  - `FireField` - Base field implementation for Firebase data mapping
  - `FireFieldBase` - Abstract base class for Firebase fields
  - `FireFieldSet` - Collection of fields with conversion utilities
  - `FireFieldSetBase` - Abstract base class for field collections
  - Type definitions for Firebase data conversion
