import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 2)
class TaskModel extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  String detailedDescription;

  @HiveField(3)
  int? startTimeInMin;

  @HiveField(4)
  int? finishTimeInMin;

  // @HiveField(5)
  // int? startTimeInHour;
  //
  // @HiveField(6)
  // int? finishTimeInHour;

  TaskModel({
    required this.text,
    required this.isDone,
    required this.detailedDescription,
    required this.startTimeInMin,
    required this.finishTimeInMin,
  });
}