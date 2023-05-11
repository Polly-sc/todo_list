import 'package:fire_auth/features/todo_list/domain/entities/task_entity.dart';

class GroupEntity {
  late String name;
  late String icon;
  late String color;
  late List<TaskEntity> tasks;

  GroupEntity({
    required this.name,
    required this.icon,
    required this.color,
    required this.tasks,
  });
}