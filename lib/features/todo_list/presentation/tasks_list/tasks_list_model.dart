import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../../data/models/task_model.dart';
import '../../domain/entities/task_entity.dart';
import '../../services/hive_manager.dart';
import '../../services/time_picker/time_picker.dart';
import '../navigation/main_navigation.dart';

class TaskListModel extends ChangeNotifier{
  ScreenFactory screenFactory;
  late int groupKey;
  late Future<Box<TaskModel>> _box;
  ValueListenable<Object>? _lisableBox;
  var _tasks = <TaskModel>[];
  var currentTask = TaskEntity(text: '', isDone: false, detailedDescription: '', startTimeInMin: 0, finishTimeInMin: 0);
  String? errorText;

  List<TaskModel> get tasks => _tasks.toList();

  TaskListModel({required this.groupKey, required this.screenFactory}){
    _setup();
  }

  Future<void> _readTasksFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(groupKey);
    await _readTasksFromHive();
    _lisableBox = (await _box).listenable();
    _lisableBox?.addListener(_readTasksFromHive);
  }

  Future<void> deleteTask(int index) async {
    return (await _box).deleteAt(index);
  }

  Future<void> onToggle(int index) async {
    final box = await _box;
    final task = box.getAt(index);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  showNewTaskForm(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return screenFactory.makeTasksListForm(groupKey);
        });
  }
}
