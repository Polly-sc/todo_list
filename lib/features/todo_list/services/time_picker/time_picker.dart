import 'package:fire_auth/features/todo_list/services/time_picker/time_picker_model.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../../presentation/navigation/main_navigation.dart';
import '../../presentation/tasks_list/new_task_form_model.dart';

abstract class TimePickerFactory {
  CustomTimePicker makeTimePicker();
}

abstract class CustomTimePicker{
  Widget returnCustomTimePicker();
  int getCurrentTimeInMinute();
}

class CustomTimePickerRealization implements CustomTimePicker{
  final CustomTimePickerModel model;
  ScreenFactory screenFactory;

  @override
  Widget returnCustomTimePicker() {
    return screenFactory.makeCustomTimePickerWidget(model);
  }

  @override
  int getCurrentTimeInMinute() {
    return (model.minute + (model.hour * 60));
  }

  CustomTimePickerRealization({required this.model, required this.screenFactory});
}

class TimePickerWidget extends StatefulWidget {
  final CustomTimePickerModel model;

  TimePickerWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<TimePickerWidget> createState() => _TimePickerState();
}


class _TimePickerState extends State<TimePickerWidget> {
  late CustomTimePickerModel _model;

  // @override
  // void initState() {
  //   _model = widget.model;
  // }


  @override
  Widget build(BuildContext context) {
    _model = context.watch<CustomTimePickerModel>();
          return Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                boxShadow: [ BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 2),
                ),
                ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NumberPicker(
                  minValue: 0,
                  maxValue: 23,
                  value: _model.hour,
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: 27,
                  itemHeight: 25,
                  onChanged: (value) {
                    setState(() {
                      _model.hour = value;
                    });
                  },
                  textStyle: TextStyle(fontSize: 10),
                  selectedTextStyle:
                  const TextStyle(color: Color.fromRGBO(136, 136, 136, 1), fontSize: 20),
                ),
                Container(
                    child: Text(':', style: TextStyle(fontSize: 20, color: Colors.black38, fontWeight: FontWeight.bold)),
                    height: 20),
                NumberPicker(
                  minValue: 0,
                  maxValue: 59,
                  value: _model.minute,
                  zeroPad: true,
                  infiniteLoop: true,
                  itemWidth: 27,
                  itemHeight: 25,
                  onChanged: (value) {
                    setState(() {
                      _model.minute = value;
                    });
                  },
                  textStyle: TextStyle(fontSize: 10),
                  selectedTextStyle: TextStyle(color:  Color.fromRGBO(136, 136, 136, 1), fontSize: 20),
                ),
              ],
            ),
          );
  }
}