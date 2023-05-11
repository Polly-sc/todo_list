import 'package:flutter/material.dart';

import 'navigation/main_navigation_route_names.dart';


abstract class MainNavigation {
  Map<String, Widget Function(BuildContext)> makeRoutes();
  Route<Object> onGenerateRoute(RouteSettings settings);
}

class MyApp extends StatelessWidget {
  final MainNavigation mainNavigation;
  MyApp({Key? key, required this.mainNavigation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          routes: mainNavigation.makeRoutes(),
          onGenerateRoute: mainNavigation.onGenerateRoute,
          initialRoute: MainNavigationRouteNames.groups,
      );
  }
}