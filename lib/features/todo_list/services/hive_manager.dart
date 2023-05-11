import 'package:hive/hive.dart';

import '../data/models/group_model.dart';
import '../data/models/task_model.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  final Map<String, int> _boxCounter = <String, int>{};
  BoxManager._();

  Future<Box<GroupModel>> openGroupBox() async {
    return _openBox('group_box', 1, GroupModelAdapter());
  }

  Future<Box<TaskModel>> openTaskBox(int groupKey) async {
    return _openBox(makeTaskBoxName(groupKey), 2, TaskModelAdapter());
  }

  String makeTaskBoxName(int groupKey) => 'tasks_box_$groupKey';

  Future<Box<T>> _openBox<T>(
      String name,
      int typeId,
      TypeAdapter<T> typeAdapter,
      ) async {
      if (Hive.isBoxOpen(name)) {
        return Hive.box(name);
      }
      if(!Hive.isAdapterRegistered(typeId)) {
        Hive.registerAdapter(typeAdapter);
      }
      return Hive.openBox<T>(name);
  }

   Future<void> closeBox<T>(Box<T> box) async{
     await box.compact();
     await box.close();
   }
}

//Открыть бокс, добавить адаптеры