import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/group_model.dart';
import '../../data/models/task_model.dart';
import '../../services/hive_manager.dart';
import '../../settings/icon_collection.dart';
import '../../settings/theme.dart';
import '../my_flutter_app_icons.dart';
import '../navigation/main_navigation_route_names.dart';



class GroupListModel extends ChangeNotifier {
  static final GroupListModel _singleton = GroupListModel._internal();

  factory GroupListModel() {
    return _singleton;
  }

  GroupListModel._internal(){
    _setup();
  }

  var _tapPosition;
  late final Future<Box<GroupModel>> _box;
  ValueListenable<Object>? _lisableBox;
  late IconData? currentReturnIcon = MyFlutterApp.format_list_bulleted;
  late Color? currentReturnColor = AppColors.navyBlue;
  late String groupName = '';
  late String currentIconName = '';
  late String currentColorName = '';
  var _groups = <GroupModel>[];
  String? errorText;

  List<GroupModel> get groups => _groups.toList();

  TextEditingController searchController = TextEditingController();

  var filteredGroupList = <GroupModel>[];

  void _searchGroups() {
    final query = searchController.text;
    if (query.isNotEmpty) {
      filteredGroupList = _groups.where((GroupModel group) {
        return group.name!.contains(query);
      }).toList();
    } else {
      filteredGroupList = _groups;
    }
    notifyListeners();
  }

  Future<void> saveGroup(BuildContext context) async{
    if (groupName.trim().isEmpty) {
      errorText = 'Введите название группы';
      notifyListeners();
      return;
    }
    final group = GroupModel(name: groupName, icon: currentIconName, color: currentColorName);
    groupName = '';
    currentIconName = '';
    currentColorName = '';
    errorText = null;
    final box = await BoxManager.instance.openGroupBox();
    await box.add(group);
    notifyListeners();
    Navigator.of(context).pop();
  }

  void showTasks(BuildContext context, int groupIndex) async {
    final groupKey = (await _box).keyAt(groupIndex) as int;
    unawaited(
        Navigator.of(context).pushNamed(
            MainNavigationRouteNames.tasks,
            arguments: groupKey,
        )
    );
  }

  void getTapPosition(TapDownDetails tapPosition, BuildContext context){
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    _tapPosition = referenceBox.globalToLocal(tapPosition.globalPosition);   // store the tap positon in offset variable
    }

  void showContextMenu(BuildContext context, int index) async {
    final RenderObject? overlay =
    Overlay.of(context)?.context.findRenderObject();

    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          const PopupMenuItem(
            child: Text('Delete'),
            value: "delete",
          ),
          const PopupMenuItem(
            child: Text('Close'),
            value: "close",
          )
        ]);
    // perform action on selected menu item
    switch (result) {
      case 'delete':
        deleteGroup(index);
        break;
      case 'close':
        Navigator.pop(context);
        break;
    }
  }

  void deleteGroup(int index) async {
    final box = await _box;
    final groupKey = box.keyAt(index);
    await Hive.deleteBoxFromDisk(BoxManager.instance.makeTaskBoxName(groupKey));
    await box.delete(groupKey);
  }

  //Прочитать box из Hive
  void readGroupsFromHive() async {
    final _box = await BoxManager.instance.openGroupBox();
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async{
    //То есть если меняется _searchController, тооо вызывается _searchGroup
    searchController.addListener(_searchGroups);
    _box = BoxManager.instance.openGroupBox();
    readGroupsFromHive();
    //If you want your widgets to refresh based on the data stored in Hive,
    // you can use the ValueListenableBuilder.
    // The box.listenable() method provides a ValueListenable
    // which can also be used with the provider package.
    _lisableBox = (await _box).listenable();
    //Register a closure to be called when the object notifies its listeners.
    _lisableBox?.addListener(readGroupsFromHive);
  }
}