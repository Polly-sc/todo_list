import 'package:fire_auth/features/todo_list/data/models/task_model.dart';
import 'package:hive/hive.dart';

part 'group_model.g.dart';

@HiveType(typeId: 1)
class GroupModel extends HiveObject{
  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? icon;

  @HiveField(3)
  final String? color;

  @HiveField(4)
  HiveList<TaskModel>? tasks;

  GroupModel({
    required this.name,
    required this.icon,
    required this.color,
  });

  void addTask(Box<TaskModel> box, TaskModel task) {
    //Если tasks пустой, то сэтапим туда listBox
    tasks ??= HiveList(box);
    tasks?.add(task);
    save();
  }
}
