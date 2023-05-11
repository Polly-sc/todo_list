import 'package:flutter/material.dart';

class  CustomIconPickerModel extends ChangeNotifier {
  static final   CustomIconPickerModel _singleton =   CustomIconPickerModel._internal();

  factory   CustomIconPickerModel() {
    return _singleton;
  }

  @override
  void dispose() {
    super.dispose();
  }

  CustomIconPickerModel._internal(){
  }

  late String selectedIconName = 'format_list_bulleted';

  void setSelectedIconName(String selectedIconName) {
    this.selectedIconName = selectedIconName;
    notifyListeners();
  }
}