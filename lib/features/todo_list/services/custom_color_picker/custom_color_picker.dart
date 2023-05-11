import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/navigation/main_navigation.dart';
import '../../settings/colors_collection.dart';
import 'custom_color_picker_model.dart';

class CustomerColorPicker {
  late String name;
  late Color color;

  CustomerColorPicker(this.name, this.color);

  @override
  String toString() {
    return '{ ${this.name} ${this.color} }';
  }
}
abstract class CustomColorPickerFactory {
  CustomColorPickerInterface makeCustomColorPicker();
}

abstract class CustomColorPickerInterface{
  Widget getCustomColorPickerWidget();
  String getSelectedColor();
}

class CustomColorPickerRealization implements CustomColorPickerInterface{
  final ScreenFactory screenFactory;
  final CustomColorPickerModel model;
  CustomColorPickerRealization({required this.screenFactory, required this.model});

  @override
  String getSelectedColor() {
    return model.selectedColorName;
  }

  @override
  Widget getCustomColorPickerWidget() {
    return screenFactory.makeCustomColorPicker();
  }
}

class CustomColorPicker extends StatefulWidget {

  CustomColorPicker({Key? key}) : super(key: key);

  @override
  _CustomColorPickerState createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  var listOfColors = [];
  int selectedColorIndex = 5;

  void initState() {
    ColorsCollection.forEach((k, v) => listOfColors.add(CustomerColorPicker(k, v)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomColorPickerModel>(
      builder: (context, value, child) {
      final model = context.watch<CustomColorPickerModel>();
      return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))),
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: 300,
        height: 100,
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
            ),
            itemCount: listOfColors.length,
            itemBuilder: (_, index) => Container(
                  key: ValueKey(listOfColors[index].name),
                  padding: const EdgeInsets.all(1),
                  child: GestureDetector(
                    onTap: () {
                      model.selectedColorName = listOfColors[index].name;
                      setState(() {
                        selectedColorIndex = index;
                      });
                    },
                    child: Stack(
                     children: [
                       Center(
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 2,
                                color: selectedColorIndex == index
                                    ? Colors.black87
                                    : Colors.white),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: listOfColors[index].color),
                          width: 35,
                          height: 35,
                        ),
                      )
                    ]),
                  ),
                )
            ),
      );
    });
  }
}
