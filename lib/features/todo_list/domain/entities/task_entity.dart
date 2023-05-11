class TaskEntity {
  late String text;
  late bool isDone;
  late String detailedDescription;
  late int startTimeInMin;
  late int finishTimeInMin;

  TaskEntity({
    required this.text,
    required this.isDone,
    required this.detailedDescription,
    required this.startTimeInMin,
    required this.finishTimeInMin,
  });
}