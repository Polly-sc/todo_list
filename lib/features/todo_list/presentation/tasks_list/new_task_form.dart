import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../factories/di_container.dart';
import '../../services/time_picker/time_picker.dart';
import '../navigation/main_navigation.dart';
import 'new_task_form_model.dart';

final timePickerFactory = makeTimePickerFactory();

class NewTaskForm extends StatefulWidget {
  final int groupKey;
  final ScreenFactory screenFactory;
  const NewTaskForm({required this.groupKey, context, required this.screenFactory});
  //const ShowNewTaskForm({required this.groupKey, required this.screenFactory, context});

  @override
  State<NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  var detailedDescription;
  var text;
  // late NewTasksFormModel model;
  late CustomTimePicker startTimePicker;
  late CustomTimePicker finishTimePicker;

  @override
  void initState() {
    super.initState();
    detailedDescription = '';
    text = '';
    startTimePicker = timePickerFactory.makeTimePicker();
    finishTimePicker = timePickerFactory.makeTimePicker();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<NewTasksFormModel>();
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
      width: 260,
         child: SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17.7)),
              children: <Widget>[
                TextField(decoration: InputDecoration(
                  hintText: 'Напишите название задачи',
                ),
                    maxLength: 17,
                    onChanged: (value) =>
                    model.currentTask.text = value),
                TextField(decoration: InputDecoration(
                  hintText: 'Опишите задачу подробней',
                  errorText: model.errorText,
                ),
                    maxLength: 17,
                    onChanged: (value) =>
                    model.currentTask.detailedDescription = value),
                SizedBox(
                  height: 75,
                  child: Row(
                    children: [
                      Container(padding: EdgeInsets.only(left: 5.0),
                          width: 65,
                          child: Text('from', style: TextStyle(
                              fontSize: 25,
                              color: Color.fromRGBO(136, 136, 136, 1)))),
                      SizedBox(width: 10),
                      Container(
                        //child: TimePicker(startHour: model.startTimePickerModel.hour, startMinute: model.startTimePickerModel.minute, model: model.startTimePickerModel),
                        child: startTimePicker.returnCustomTimePicker(),
                        width: 170,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  height: 75,
                  child: Row(
                    children: [
                      Container(padding: EdgeInsets.only(left: 5.0),
                          width: 65,
                          child: Text('to', style: TextStyle(fontSize: 25,
                              color: Color.fromRGBO(136, 136, 136, 1)))),
                      SizedBox(width: 10),
                      Container(
                        child: finishTimePicker.returnCustomTimePicker(),
                        // TimePicker(startHour: model.finishTimePickerModel.hour, startMinute: model.startTimePickerModel.minute, model: model.finishTimePickerModel),
                        width: 170,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 150,
                    child: Row(
                      children: <Widget>[
                        TextButton(onPressed: Navigator
                            .of(context)
                            .pop,
                            child: Text('Cancel',
                                style: TextStyle(color: Colors.black))),
                        TextButton(onPressed: () {
                          model.currentTask.startTimeInMin = startTimePicker.getCurrentTimeInMinute();
                          model.currentTask.finishTimeInMin = finishTimePicker.getCurrentTimeInMinute();
                          model.saveTask(context);
                        },
                            child: Text('Ok',
                                style: TextStyle(color: Colors.black)))
                      ],
                    ),
                  ),
                ),
              ],
            ),
      )
      );
    // );
    }
}