import 'package:flutter/material.dart';
import '../pages/growth_page.dart';
import '../pages/diagnostics_page.dart';

class SimpleRoutePath {
  final String location;
  SimpleRoutePath(this.location);
}

class SimpleRouteParser extends RouteInformationParser<SimpleRoutePath> {
  @override
  Future<SimpleRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final loc = routeInformation.location ?? '/';
    return SimpleRoutePath(loc);
  }

  @override
  RouteInformation restoreRouteInformation(SimpleRoutePath configuration) {
    return RouteInformation(location: configuration.location);
  }
}

class SimpleRouterDelegate extends RouterDelegate<SimpleRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<SimpleRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String _location = '/';

  @override
  SimpleRoutePath get currentConfiguration => SimpleRoutePath(_location);

  @override
  Future<void> setNewRoutePath(SimpleRoutePath configuration) async {
    _location = configuration.location;
  }

  void push(String location) {
    _location = location;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(child: GrowthPage()),
        if (_location == '/diagnostics') const MaterialPage(child: DiagnosticsPage()),
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }
}
