import 'package:fire_auth/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/groups_list/group_list.dart';
import '../presentation/groups_list/group_list_model.dart';
import '../presentation/navigation/main_navigation.dart';
import '../presentation/tasks_list/new_task_form.dart';
import '../presentation/tasks_list/new_task_form_model.dart';
import '../presentation/tasks_list/tasks_list.dart';
import '../presentation/tasks_list/tasks_list_model.dart';
import '../presentation/to_do_list_page.dart';
import '../services/custom_color_picker/custom_color_picker.dart';
import '../services/custom_color_picker/custom_color_picker_model.dart';
import '../services/custom_icon_picker/custom_icon_picker.dart';
import '../services/custom_icon_picker/custom_icon_picker_model.dart';
import '../services/time_picker/time_picker.dart';
import '../services/time_picker/time_picker_model.dart';


AppFactory makeAppFactory() => _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  final _diContainer = const _DIContainer();

  _AppFactoryDefault();
  @override
  Widget makeApp() => MyApp(mainNavigation: _diContainer._makeMyAppNavigation());
}

TimePickerFactory makeTimePickerFactory() => _TimePickerDefault();

class _TimePickerDefault implements TimePickerFactory{
  final _diContainer = const _DIContainer();


  @override
  CustomTimePicker makeTimePicker() {
    return _diContainer._makeCustomTimePickerRealization();
  }

}

CustomIconPickerFactory makeIconPickerFactory() => _IconPickerDefault();

class _IconPickerDefault implements CustomIconPickerFactory{
  final _diContainer = const _DIContainer();

  @override
  CustomIconPicker makeIconPicker() {
    return _diContainer._makeCustomIconPickerRealization();
  }
}

CustomColorPickerFactory makeColorPickerFactory() => _CustomColorPickerDefault();

class _CustomColorPickerDefault implements CustomColorPickerFactory{
  final _diContainer = const _DIContainer();

  @override
  CustomColorPickerInterface makeCustomColorPicker() {
    return _diContainer._makeCustomColorPickerRealization();
  }
}

class _DIContainer {

  const _DIContainer();


  CustomIconPickerModel _makeCustomIconPickerModel() => CustomIconPickerModel();
  CustomTimePickerModel _makePickerModel() => CustomTimePickerModel();
  CustomColorPickerModel _makeCustomColorModel() => CustomColorPickerModel();

  ScreenFactory _makeScreenFactory() => ScreenFactoryDefault(this);
  MainNavigation _makeMyAppNavigation() => MainNavigationDefault(_makeScreenFactory());

  CustomIconPicker _makeCustomIconPickerRealization() => CustomIconPickerRealization(model: _makeCustomIconPickerModel(), screenFactory: _makeScreenFactory());
  CustomTimePicker _makeCustomTimePickerRealization() => CustomTimePickerRealization(model: _makePickerModel(), screenFactory: _makeScreenFactory());
  CustomColorPickerInterface _makeCustomColorPickerRealization() => CustomColorPickerRealization(screenFactory: _makeScreenFactory(), model: _makeCustomColorModel());
  GroupListModel _makeGroupListModel() => GroupListModel(

  );

  TaskListModel _makeTasksListModel(int groupKey, ScreenFactory screenFactory) => TaskListModel(
      groupKey: groupKey, screenFactory: screenFactory,
  );

  NewTasksFormModel _makeTaskFormModel(int groupKey) => NewTasksFormModel(
    groupKey: groupKey,
  );

  // CustomColorPickerModel _makeCustomColorModel() => CustomColorPickerModel(
  // );
}

class ScreenFactoryDefault implements ScreenFactory {

  // late _DIContainer _diContainer;
  //
  // static final ScreenFactoryDefault _instance = ScreenFactoryDefault._internal();
  //
  // ScreenFactoryDefault._internal();
  //
  // factory ScreenFactoryDefault(this._diContainer);

  final _DIContainer _diContainer;
  const ScreenFactoryDefault(this._diContainer);

  @override
  Widget makeMainScreen() {
    return ToDoListPage(screenFactory: this);
  }

  @override
  Widget makeGroupList() {
    return ChangeNotifierProvider(
      create: (_) => _diContainer._makeGroupListModel(),
      child: GroupList(screenFactory: this),
    );
  }

  @override
  Widget makeTasksList(groupKey) {
    return ChangeNotifierProvider(
      create: (_) => _diContainer._makeTasksListModel(groupKey, this),
      child: TasksList(groupKey: groupKey, screenFactory: this),
    );
  }

  @override
  Widget makeTasksListForm(groupKey) {
    return ChangeNotifierProvider(
      create: (_) => _diContainer._makeTaskFormModel(groupKey),
      child: NewTaskForm(groupKey: groupKey, screenFactory: this),
    );
  }

  @override
  Widget makeCustomColorPicker() {
    return ChangeNotifierProvider(
      create: (_) => _diContainer._makeCustomColorModel(),
      child: CustomColorPicker(),
    );
  }

  @override
  Widget makeCustomIconPickerWidget(CustomIconPickerModel model, defaultIcon) {
    return ChangeNotifierProvider(
      create: (_) => _diContainer._makeCustomIconPickerModel(),
      child: CustomIconPickerWidget(model: model, defaultIcon: defaultIcon),
    );
  }

  @override
  Widget makeCustomTimePickerWidget(CustomTimePickerModel model) {
    return ChangeNotifierProvider(
      create: (_) => model,
      child: TimePickerWidget(model: model),
    );
  }
}
