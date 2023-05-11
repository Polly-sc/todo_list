import 'package:fire_auth/features/todo_list/presentation/tasks_list/tasks_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../navigation/main_navigation.dart';

class TasksList extends StatefulWidget {
  final int groupKey;
  final ScreenFactory screenFactory;
  const TasksList({super.key, required this.groupKey, required this.screenFactory});

  @override
  State<TasksList> createState() => _tasksListState();
}

class _tasksListState extends State<TasksList> {
  late final TaskListModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskListModel(groupKey: widget.groupKey, screenFactory: widget.screenFactory);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _model,
        child: TasksListWidget(),
    );
  }
}

class TasksListWidget extends StatelessWidget {

  Widget TopLeftWidget(double screenWidth) {
    return Transform.rotate(
      angle: -35 * math.pi / 180,
      child: Container(
        width: 0.7 * screenWidth,
        height: 0.7 * screenWidth,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
              radius: 2,
              focal: Alignment.centerRight,
              colors: [
                Color.fromRGBO(100, 111, 212, 1),
                Color.fromRGBO(153, 160, 227, 0.7),
                Color.fromRGBO(255, 255, 255, 0.5),
              ],
              stops: [
                0.29,
                0.5,
                0.7,
              ]),
        ),
      ),
    );
  }

  Widget TopRigthWidget(double screenWidth) {
    return Container(
      width: 1 * screenWidth,
      height: 2 * screenWidth,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.only(bottomLeft: Radius.elliptical(225, 300)),
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [
            0.1,
            0.5,
            0.85,
          ],
          colors: [
            Color.fromRGBO(100, 111, 212, 0),
            Color.fromRGBO(100, 111, 212, 0.81),
            Color.fromRGBO(100, 111, 212, 1),
          ],
        ),
      ),
    );
  }

  Widget MenuWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        height: 32,
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_back, color: Colors.white, size: 30)),
            Align(
              alignment: Alignment.center,
              child: Text('Today’s task',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ));
  }

  Widget ItemElement() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      height: 69,
    );
  }

  Widget ItemDivider() {
    return Container(
      height: 16,
    );
  }

  Widget TimeWidget(int? startTime, int? finishTime) {
    final int textStartTime = (startTime != null) ? startTime : 0;
    final int textFinishTime = (finishTime != null) ? finishTime : 0;

    final String hourStartTime = (textStartTime  ~/ 60) > 9 ? (textStartTime ~/ 60).toString() : ('0' + (textStartTime ~/ 60).toString());
    final String minuteStartTime = (textStartTime % 60) > 9 ? (textStartTime % 60).toString() : ('0' + (textStartTime % 60).toString());

    final String hourFinishTime = (textFinishTime  ~/ 60) > 9 ? (textFinishTime ~/ 60).toString() : ('0' + (textFinishTime ~/ 60).toString());
    final String minuteFinishTime = (textFinishTime % 60) > 9 ? (textFinishTime % 60).toString() : ('0' + (textFinishTime % 60).toString());

    return Container(
      child: Column(
      children: [
      Row(
      children: [
          Text(hourStartTime),
          Text(':'),
          Text(minuteStartTime),
          ],
      ),
    Row(
    children: [
          Text(hourFinishTime),
          Text(':'),
          Text(minuteFinishTime),
    ]
    )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final model = context.watch<TaskListModel>();
    var tasksLength = model.tasks.length;
    return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              height: 56,
              width: 56,
              child: FloatingActionButton(
                backgroundColor: Color.fromRGBO(100, 111, 212, 0.81),
                child: Icon(Icons.add, size: 32),
                onPressed: () {
                  model.showNewTaskForm(context);
                },
              ),
            ),
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(100, 111, 212, 1),
              toolbarHeight: 0,
              bottomOpacity: 0.0,
              elevation: 0.0,
            ),
            body: Center(
              child: Stack(fit: StackFit.expand, children: <Widget>[
                Positioned(
                  top: -190,
                  left: 100,
                  child: TopRigthWidget(screenSize.width),
                ),
                Positioned(
                  top: -70,
                  left: -40,
                  child: TopLeftWidget(screenSize.width),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 8),
                    MenuWidget(),
                    SizedBox(height: 20),
                    Container(
                      height: screenSize.height / 1.67,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: ListView.separated(
                        itemCount: model.tasks.length + 1,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) =>
                            ItemDivider(),
                        separatorBuilder: (BuildContext context, int index) {
                          final icon = model.tasks[index].isDone ? Icons.done : Icons.celebration_rounded;
                           return Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(16),
                                 color: Colors.white,
                               ),
                             child: Dismissible(
                               direction: DismissDirection.endToStart,
                               onDismissed: (DismissDirection direction) => model.deleteTask(index),
                               key: UniqueKey(),
                               child: Stack(
                                 children: [
                                 Center(
                                   child: Padding(
                                       padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                       child: Row(
                                          children: <Widget>[
                                            TimeWidget(model.tasks[index].startTimeInMin, model.tasks[index].finishTimeInMin),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              child: ListTile(
                                                title: Icon(icon),
                                                onTap: () => model.onToggle(index),
                                              ),
                                            ),
                                            Container(
                                              // height: 200,
                                              width: 170,
                                              child: Column(
                                                children: [
                                                  Text(model.tasks[index].text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                  Text(model.tasks[index].detailedDescription, style: TextStyle(fontSize: 13)),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                              child: Icon(Icons.more_vert, color: Colors.black38),
                                              onTap: () => {},
                                            ),
                                          ],
                                        ),
                                     ),
                                 ),
                                 ]
                                 ),
                             ),
                           );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Color.fromRGBO(136, 136, 136, 1)))),
                        height: 32,
                        child: Stack(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.centerLeft,
                                height: 23,
                                child: Text('done tasks $tasksLength',
                                    style: TextStyle(fontSize: 16))),
                            Container(
                              alignment: Alignment.centerRight,
                              height: 24,
                              child: Icon(
                                Icons.expand_more_rounded,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ),
      );
  }
}
