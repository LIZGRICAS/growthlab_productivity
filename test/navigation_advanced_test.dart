import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:growthlab_productivity/presentation/pages/diagnostics_page.dart';

// This file contains three navigation tests:
// 1) Deep link via initialRoute
// 2) Named routes push
// 3) Minimal Navigator 2.0 Router that parses '/diagnostics'

void main() {
  testWidgets('Deep link via initialRoute shows DiagnosticsPage', (tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/diagnostics',
      routes: {
        '/diagnostics': (_) => const DiagnosticsPage(),
      },
    ));

    await tester.pumpAndSettle();

    expect(find.byType(DiagnosticsPage), findsOneWidget);
    expect(find.text('Diagnostics'), findsOneWidget);
  });

  testWidgets('Named route push navigates to DiagnosticsPage', (tester) async {
    // Minimal home with a button that pushes a named route
    await tester.pumpWidget(MaterialApp(
      routes: {
        '/': (_) => Builder(builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/diagnostics'),
                  child: const Text('Go'),
                ),
              ),
            )),
        '/diagnostics': (_) => const DiagnosticsPage(),
      },
    ));

    expect(find.text('Go'), findsOneWidget);
    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    expect(find.byType(DiagnosticsPage), findsOneWidget);
  });

  testWidgets('Navigator 2.0 minimal Router navigates to DiagnosticsPage', (tester) async {
    final delegate = _SimpleRouterDelegate();
    final parser = _SimpleRouteParser();

    await tester.pumpWidget(MaterialApp.router(
      routerDelegate: delegate,
      routeInformationParser: parser,
      routeInformationProvider: PlatformRouteInformationProvider(
        initialRouteInformation: const RouteInformation(location: '/diagnostics'),
      ),
    ));

    await tester.pumpAndSettle();

    expect(find.byType(DiagnosticsPage), findsOneWidget);
  });
}

class _SimpleRoutePath {
  final String location;
  _SimpleRoutePath(this.location);
}

class _SimpleRouteParser extends RouteInformationParser<_SimpleRoutePath> {
  @override
  Future<_SimpleRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final loc = routeInformation.location ?? '/';
    return _SimpleRoutePath(loc);
  }

  @override
  RouteInformation restoreRouteInformation(_SimpleRoutePath configuration) {
    return RouteInformation(location: configuration.location);
  }
}

class _SimpleRouterDelegate extends RouterDelegate<_SimpleRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<_SimpleRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String _location = '/';

  @override
  _SimpleRoutePath get currentConfiguration => _SimpleRoutePath(_location);

  @override
  Future<void> setNewRoutePath(_SimpleRoutePath configuration) async {
    _location = configuration.location;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(child: Scaffold(body: Center(child: Text('Home')))),
        if (_location == '/diagnostics') const MaterialPage(child: DiagnosticsPage()),
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }
}
