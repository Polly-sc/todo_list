import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/navigation/main_navigation.dart';
import '../../settings/icon_collection.dart';
import '../time_picker/time_picker_model.dart';
import 'custom_icon_picker_model.dart';

class CustomerIcon {
  String name;
  IconData icon;

  CustomerIcon(this.name, this.icon);

  @override
  String toString() {
    return '{ ${this.name}, ${this.icon} }';
  }
}

abstract class CustomIconPickerFactory {
  CustomIconPicker makeIconPicker();
}

abstract class CustomIconPicker{
  Widget returnIconPicker();
  String getCurrentIcon();
}

class  CustomIconPickerRealization implements CustomIconPicker{
  final  CustomIconPickerModel model;
  ScreenFactory screenFactory;

  @override
  Widget returnIconPicker() {
    return screenFactory.makeCustomIconPickerWidget(model, screenFactory);
  }

  @override
  String getCurrentIcon() {
    return model.selectedIconName;
  }

  CustomIconPickerRealization({required this.model, required this.screenFactory});
}


class CustomIconPickerWidget extends StatefulWidget {
  IconData? defaultIcon;
  CustomIconPickerModel model;

  CustomIconPickerWidget({Key? key, required this.model, required this.defaultIcon}) : super(key: key);

  @override
  _CustomIconPickerWidgetState createState() => _CustomIconPickerWidgetState();
}
// (required BuildContext context, IconData? defaultIcon)

class _CustomIconPickerWidgetState extends State<CustomIconPickerWidget> {
  var listOfIcons = [];
  int selectedIconIndex = 0;

  @override
  void initState() {
    MyIconCollection.forEach((k, v) => listOfIcons.add(CustomerIcon(k, v)));
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CustomIconPickerModel>();
    // return Consumer<ShowIconPickerModel>(
    //   builder: (context, model, child) {
    //     final model = context.watch<ShowIconPickerModel>();
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: 300,
          height: 300,
          alignment: Alignment.center,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 50,
                childAspectRatio: 1 / 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0),
            itemCount: listOfIcons.length,
            itemBuilder: (_, index) => Container(
              key: ValueKey(listOfIcons[index].icon.codePoint),
              padding: const EdgeInsets.all(1),
              child: GestureDetector(
                onTap: () {
                  model.selectedIconName = listOfIcons[index].name;
                  setState(() {
                    selectedIconIndex = index;
                    // Ontap of each card, set the defined int to the grid view index
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
                            color: selectedIconIndex == index
                                ? Colors.black87
                                : Colors.white
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(231, 231, 231, 1)),
                        // give the selected icon a different color
                        child: Icon(
                          listOfIcons[index].icon,
                          size: 19.0,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    //   }
    // );
  }
// return selectedIcon;
}
