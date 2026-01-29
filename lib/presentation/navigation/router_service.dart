import 'simple_router.dart';

/// Abstraction for navigation so implementations can be injected/mocked in tests.
abstract class RouterServiceInterface {
  void registerDelegate(SimpleRouterDelegate delegate);
  bool get isRegistered;
  void push(String location);
  void pop();
}

/// Concrete implementation that delegates to a `SimpleRouterDelegate`.
class RouterServiceImpl implements RouterServiceInterface {
  SimpleRouterDelegate? _delegate;

  @override
  void registerDelegate(SimpleRouterDelegate delegate) {
    _delegate = delegate;
  }

  @override
  bool get isRegistered => _delegate != null;

  @override
  void push(String location) => _delegate?.push(location);

  @override
  void pop() => _delegate?.navigatorKey.currentState?.pop();
}
