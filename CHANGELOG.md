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
