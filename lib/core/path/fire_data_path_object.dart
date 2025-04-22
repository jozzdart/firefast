import 'package:firefast/firefast_core.dart';

/// A generic interface for Firebase database path objects.
///
/// This interface defines a contract for data objects bound to a specific path
/// in a Firebase database. It combines read, write, overwrite, and delete operations
/// for data objects of type [O] without requiring additional parameters.
///
/// Implementations of this interface provide the foundation for path-based
/// data access patterns in Firebase applications.
abstract class FireDataPathObject<O>
    implements
        FastReadNoParams<O>,
        FastWriteNoParams,
        FastOverwriteNoParams,
        FastDeleteNoParams {}
