import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';


import '../../domain/health_data_model.dart';
class ExportSuccessException implements Exception {}

Future<void> saveToCsv(Map<String, List<LineData>> healthData) async {
  // bool hasPermission = await requestPermissions();
  // if (!hasPermission) {
  //   print('Permission denied');
  //   return;
  // }
  List<List<dynamic>> rows = [];
  rows.add(["Date", "Weight", "Height", "Head Circumference"]);
  int dataLength = healthData['weight']?.length ?? 0;
  for (int i = 0; i < dataLength; i++) {
    List<dynamic> row = [];
    row.add(healthData['weight']?[i].date.toIso8601String() ?? '');
    row.add(healthData['weight']?[i].sideValue ?? '');
    row.add(healthData['height']?[i].sideValue ?? '');
    row.add(healthData['headCircumference']?[i].sideValue ?? '');
    rows.add(row);
  }

  String csv = const ListToCsvConverter().convert(rows);

  final directory = Directory('/storage/emulated/0/Download');
  final path = '${directory.path}/health_data.csv';
  final file = File(path);

  await file.writeAsString(csv);
  print('CSV file saved at $path');
  // throw ExportSuccessException();

}

// Future<bool> requestPermissions() async {
//   PermissionStatus status = await Permission.storage.request();
//   if (status.isGranted) {
//     return true;
//   } else if (status.isPermanentlyDenied) {
//     openAppSettings();
//     return false;
//   }
//   return false;
// }
