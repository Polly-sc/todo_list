
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/authorization/bloc/auth_bloc.dart';
import 'features/authorization/data/repositories/auth_repository.dart';
import 'features/authorization/presentation/pages/sign_in.dart';

abstract class MainNavigation {
  Map<String, Widget Function(BuildContext)> makeRoutes();
  Route<Object> onGenerateRoute(RouteSettings settings);
}

class MyApp extends StatelessWidget {
  final MainNavigation mainNavigation;

  MyApp({Key? key, required this.mainNavigation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainNavigation mainNavigation;
    return RepositoryProvider(
        create: (context) => AuthRepository(),
        child: BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
            child: MaterialApp(
              routes: mainNavigation.makeRoutes(),
              onGenerateRoute: mainNavigation.onGenerateRoute,
              // initialRoute: MainNavigationRouteNames.groups,
              home: SignIn(),
            )
        )
    );
  }

}