/// Defines a read operation without path parameters.
///
/// The generic type [D] represents the data model to be returned.
abstract class FastReadNoParams<D> {
  /// Reads data from a predefined location.
  ///
  /// Returns the data of type [D] if available, or `null` if not found.
  /// This operation doesn't require a path parameter as it works on a fixed location.
  Future<D?> read();
}

/// Defines a write operation without path parameters.
///
/// This interface is used when writing to a predefined location.
abstract class FastWriteNoParams {
  /// Writes data to a predefined location.
  ///
  /// This operation doesn't require path or data parameters as they are
  /// determined by the implementing class.
  Future<void> write();
}

/// Defines an overwrite operation without path parameters.
///
/// This interface is used when overwriting data at a predefined location.
abstract class FastOverwriteNoParams {
  /// Overwrites existing data at a predefined location.
  ///
  /// Unlike [FastWriteNoParams], this method explicitly indicates
  /// that existing data will be replaced.
  Future<void> overwrite();
}

/// Defines a delete operation without path parameters.
///
/// This interface is used when deleting data from a predefined location.
abstract class FastDeleteNoParams {
  /// Deletes data from a predefined location.
  ///
  /// This operation doesn't require a path parameter as it works on a fixed location.
  Future<void> delete();
}
