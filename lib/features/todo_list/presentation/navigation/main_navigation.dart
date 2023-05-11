import 'package:flutter/material.dart';

import '../../services/custom_icon_picker/custom_icon_picker_model.dart';
import '../../services/time_picker/time_picker.dart';
import '../../services/time_picker/time_picker_model.dart';
import '../my_app.dart';
import '../to_do_list_page.dart';
import 'main_navigation_route_names.dart';

abstract class ScreenFactory {
  Widget makeMainScreen();
  Widget makeGroupList();
  Widget makeTasksList(groupKey);
  Widget makeTasksListForm(groupKey);
  Widget makeCustomColorPicker();
  Widget makeCustomIconPickerWidget(CustomIconPickerModel model, defaultIcon);
  Widget makeCustomTimePickerWidget(CustomTimePickerModel model);
}

class MainNavigationDefault implements MainNavigation{
  final ScreenFactory screenFactory;

  MainNavigationDefault(this.screenFactory);
  // final initialRoute = MainNavigationRouteNames.groups;
  // final routes = <String, Widget Function(BuildContext)>{
  //   MainNavigationRouteNames.groups: (context) => ToDoListPage(),
  // };

  @override
  Map<String, Widget Function(BuildContext)> makeRoutes() {
    return <String, Widget Function(BuildContext)>{
      MainNavigationRouteNames.groups: (_) => screenFactory.makeMainScreen(),
    };
  }

  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.tasks:
        final groupKey = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) {
              return screenFactory.makeTasksList(groupKey);
            }
        );
        default:
          const widget = Text('Navigation error!!!');
          return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
