import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  List<Map<String, dynamic>> cities = [];
  late  SharedPreferences _prefs;

  Database() {
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _initPreferences();
    await getData();
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/data.txt';
  }

  Future<void> _initPreferences() async {
    bool isDataPresent = _prefs.getBool('isDataPresent') ?? false;
    if (!isDataPresent) {
      await _createFile();
      _prefs.setBool('isDataPresent', true);
    }
  }

  Future<void> _createFile() async {
    final file = File(await _getFilePath());
    await file.writeAsString('');
  }

  Future<void> saveData() async {
    final file = File(await _getFilePath());
    final jsonData = jsonEncode(cities);
    await file.writeAsString(jsonData);
  }

  Future<void> getData() async {
    final file = File(await _getFilePath());
    if (await file.exists()) {
      final jsonData = await file.readAsString();
      cities = List<Map<String, dynamic>>.from(jsonDecode(jsonData));
    }
  }

  Future<void> deleteAll() async {
    final file = File(await _getFilePath());
    if (await file.exists()) {
      await file.delete();
    }
    cities.clear();
    _prefs.setBool('isDataPresent', false);
  }

  void addCity(String city, String icon, int temp) async {
    await getData(); // Ensure data is loaded before adding
    cities.add({'city': city, 'icon': icon, 'temp': temp});
    await saveData();
  }

  void updateCity(String city, String icon, int temp) async {
    await getData(); // Ensure data is loaded before updating
    final existingCity = cities.firstWhere((element) => element['city'] == city);
    existingCity['icon'] = icon;
    existingCity['temp'] = temp;
    await saveData();
  }

  Future<void> deleteCity(int index) async {
    cities.removeAt(index);
    await saveData();
  }

  bool isCity(String city) {
    return cities.any((element) => element['city'] == city);
  }

  String getIcon(int index) {
    return cities[index]['icon'];
  }

  int getTemperature(int index) {
    return cities[index]['temp'];
  }

  String getCity(int index) {
    return cities[index]['city'];
  }

  int getLength() {
    return cities.length;
  }

  bool isEmpty() {
    return cities.isEmpty;
  }
}
