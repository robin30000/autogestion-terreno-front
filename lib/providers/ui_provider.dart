import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UiProvider extends ChangeNotifier{
  
  int _selectedMenuOpt = 0;
  String _selectedMenuName = "Autogestión Terreno";
  String _dateButton = DateFormat('yyyy-MM-dd').format(DateTime.now());

  dynamic _connectionStatusProvider;
  bool _isDeviceConnectedProvider = false;
  
  Map<String, dynamic> _data = {};

  int get selectedMenuOpt {
    return _selectedMenuOpt;
  }

  String get selectedMenuName {
    return _selectedMenuName;
  }

  String get dateButton {
    return _dateButton;
  }

  set selectedMenuOpt( int value){
    _selectedMenuOpt = value;
    notifyListeners();
  }

  set selectedMenuName( String value){
    _selectedMenuName = value;
    notifyListeners();
  }

  set dateButton( String value){
    _dateButton = value;
    notifyListeners();
  }

  Map<String, dynamic> get data {
    return _data;
  }

  set data( Map<String, dynamic> value){
    _data = value;
    notifyListeners();
  }

  /* -------- STATUS CONNECTION -------- */

  get connectionStatusProvider {
    return _connectionStatusProvider;
  }

  get isDeviceConnectedProvider {
    return _isDeviceConnectedProvider;
  }

  set connectionStatusProvider(value){
    _connectionStatusProvider = value;
    notifyListeners();
  }

  set isDeviceConnectedProvider(value){
    _isDeviceConnectedProvider = value;
    notifyListeners();
  }
}