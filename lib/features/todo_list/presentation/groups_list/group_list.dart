import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../factories/di_container.dart';
import '../../settings/colors_collection.dart';
import '../../settings/icon_collection.dart';
import '../../settings/theme.dart';
import '../navigation/main_navigation.dart';
import 'group_list_model.dart';

final iconPickerFactory = makeIconPickerFactory();
final colorPickerFactory = makeColorPickerFactory();

class GroupList extends StatefulWidget {
  final ScreenFactory screenFactory;

  GroupList({required this.screenFactory});

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {

  final iconPicker = iconPickerFactory.makeIconPicker();
  final colorPicker = colorPickerFactory.makeCustomColorPicker();

  Widget MenuWidget() {
    return Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        height: 32,
        child: Stack(
          children: <Widget> [
            Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.menu, color: Colors.black, size: 30)),
            Align(
              alignment: Alignment.center,
              child:  Text('Mtodo Logo', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    final model = context.watch<GroupListModel>();
    return Column(
        children: <Widget>[
          MenuWidget(),
          SizedBox(height: 31),
          Container(
            height: 35,
            child: Center(child: Text('you have 5 tasks today!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
          Container(
            height: 17,
            child: Text('Saturday,september 10,2022', style: TextStyle(fontSize: 12))
          ),
          SizedBox(height: 17),
          Container(
            width: 280,
            height: 48,
            decoration: BoxDecoration(
                color: Color(0xFFe9eaec),
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              cursorColor: Color(0xFF000000),
              controller: model.searchController,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF000000).withOpacity(0.5),
                  ),
                  hintText: "Search",
                  border: InputBorder.none),
            ),
          ),
          SizedBox(height: 200),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
            padding:  EdgeInsets.fromLTRB(16, 0, 16, 0),
            color: Colors.transparent,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 1,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 16
              ),
              itemCount: model.filteredGroupList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if(index != model.filteredGroupList.length) {
                  model.currentReturnColor = ColorsCollection[model.filteredGroupList[index].color];
                  model.currentReturnIcon = MyIconCollection[model
                      .filteredGroupList[index].icon];
                  }
                return index == model.filteredGroupList.length ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 2),
                  ),
                  child:  IconButton(
                        onPressed: (){
                          _showDialog(context);
                        },
                        icon: Icon(Icons.add),
                  ),
                ) : GestureDetector(
                  child: Container(
                    width: 250,
                    height: 250,
                    child: Stack(
                    children: [
                         Container(
                          decoration: BoxDecoration(
                            color: model.currentReturnColor == null ? AppColors.green : model.currentReturnColor,
                          borderRadius: BorderRadius.circular(16),),
                          ),
                           Center(
                             child: Container(
                                      height: 60,
                                        child: Column(
                                              children: [
                                                Icon(model.currentReturnIcon, color: Colors.white, size: 32,),
                                                SizedBox(height: 8),
                                                Text(model.filteredGroupList[index].name!, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                              ]
                                            ),
                                      ),
                           ),
                    ],
                    ),
                  ),
                  onTapDown: (position)=> { model.getTapPosition(position, buildContext) },
                  onTap: () { model.showTasks(context, index); },
                  onLongPress: () { model.showContextMenu(buildContext, index); },
                );
              },
            ),
        ),
          ),
      ]
      );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<GroupListModel>(
              builder: (context, model, child) {
                return BackdropFilter(
                 filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      height: 530,
                      width: 300,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Название группы',
                                  errorText: model.errorText,
                                ),
                                maxLength: 17,
                                onChanged: (value) => model.groupName = value,
                                onEditingComplete: () => model.saveGroup(context),
                              ),
                              colorPicker.getCustomColorPickerWidget(),
                              iconPicker.returnIconPicker(),
                              // ShowIconPicker(
                              //     defaultIcon: MyFlutterApp.format_list_bulleted),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 150,
                                child: Row(
                                  children: <Widget>[
                                    TextButton(onPressed: Navigator.of(context).pop, child: Text('Cancel', style: TextStyle(color: Colors.black))),
                                    TextButton(onPressed: () {
                                        model.currentColorName = colorPicker.getSelectedColor();
                                        model.currentIconName = iconPicker.getCurrentIcon();
                                        model.saveGroup(context);
                                        }, child: Text('Ok', style: TextStyle(color: Colors.black)))
                                  ],
                                ),
                              ),
                            ),
                          ]
                        ),
                        ),
                      ),
                    ),
                );
              }
          );
        }
    );
  }
}
