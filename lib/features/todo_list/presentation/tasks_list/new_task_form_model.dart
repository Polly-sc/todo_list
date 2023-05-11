import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../domain/entities/task_entity.dart';
import '../../services/hive_manager.dart';
import '../../services/time_picker/time_picker.dart';

class NewTasksFormModel extends ChangeNotifier{
  late int hour = 0;
  late int minute = 0;
  late int startTimeInMin = 0;
  late int finishTimeInMin = 0;
  String? errorText;
  late int groupKey;
  var currentTask = TaskEntity(text: '', isDone: false, detailedDescription: '', startTimeInMin: 0, finishTimeInMin: 0);

  // NewTasksFormModel({required this.groupKey, required this.startTimePickerModel, required this.finishTimePickerModel});
  NewTasksFormModel({required this.groupKey});

  // void dispose(){
  //   super.dispose();
  // }

  saveTask(BuildContext context) async{
    if (currentTask.text.trim().isEmpty) {
      errorText = 'Введите текст задачи';
      notifyListeners();
      return;
    }
    final task = TaskModel(text: currentTask.text, isDone: currentTask.isDone, detailedDescription:  currentTask.detailedDescription, startTimeInMin: currentTask.startTimeInMin, finishTimeInMin: currentTask.finishTimeInMin);
    final box = await BoxManager.instance.openTaskBox(groupKey);
    await box.add(task);
    currentTask = TaskEntity(text: '', isDone: false, detailedDescription: '', startTimeInMin: 0, finishTimeInMin: 0);
    // await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}