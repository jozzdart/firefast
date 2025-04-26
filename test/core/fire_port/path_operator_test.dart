import 'package:test/test.dart';
import 'package:firefast/firefast_core.dart';

// Simple stub implementation just for testing the base class behavior
class StubFireObjectPathOperator extends FireObjectPathOperator {
  @override
  Future<dynamic> perform() async {
    // Implementation not needed for this test
    return null;
  }

  const StubFireObjectPathOperator(OperatablePathObject mockOperatable)
      : super(fireOperatable: mockOperatable);
}

void main() {
  group('FireObjectPathOperator', () {
    test('should pass through properties from operatable', () {
      // This is a minimal test to verify the passthrough behavior
      // We're not trying to test the entire hierarchy of dependencies
      final mockOperatable = _MockOperatable();
      final operator = StubFireObjectPathOperator(mockOperatable);

      expect(operator.fireValues, same(mockOperatable.fireValues));
      expect(operator.datasource, same(mockOperatable.datasource));
      expect(operator.path, same(mockOperatable.path));
      expect(operator.adapters, same(mockOperatable.adapters));
    });
  });
}

// Simple mock for testing just the property access
class _MockOperatable implements OperatablePathObject {
  final List<FireValue> _fireValues = [];
  final PathBasedDataSource _datasource = _MockDataSource();
  final PathSegment _path = _MockPathSegment();
  final FireAdapterMap _adapters = FireAdapterMap();

  @override
  List<FireValue> get fireValues => _fireValues;

  @override
  PathBasedDataSource get datasource => _datasource;

  @override
  PathSegment get path => _path;

  @override
  FireAdapterMap get adapters => _adapters;

  // We don't need to implement these for our tests
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockPathSegment implements PathSegment {
  @override
  String get path => 'mock/path';

  // We don't need to implement these for our tests
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockDataSource implements PathBasedDataSource {
  // We don't need to implement these for our tests
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
