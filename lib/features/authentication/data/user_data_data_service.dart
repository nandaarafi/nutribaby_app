
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:nutribaby_app/features/authentication/model/user_data_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UserDataService {

  Future<bool> isAdmin(User user) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      var data = userDoc.data() as Map<String, dynamic>;
      if (data['role'] == 'super_admin') {
        return true;
      }
    }
    return false;
  }

  Future<List<UserDataModel>> getAllEmailData() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<UserDataModel> emailList = [];

    if (user != null) {
      bool admin = await isAdmin(user);

      if (admin) {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').get();

        for (var doc in userSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          String email = data['email'];
          emailList.add(UserDataModel(email: email, docId: doc.id));
        }
      } else {
        print('You are not authorized to access this data.');
      }
    }
    return emailList;
  }

  Future<String> getAllUserDataAsCSV() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<List<String>> csvData = [
      // Header row
      ["Email", "Nama Bayi", "Nama Orang Tua","Tinggi", "Berat", "Lingkar Kepala", "Datetime"]
    ];

    if (user != null) {
      bool admin = await isAdmin(user);

      if (admin) {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').get();

        for (var userDoc in userSnapshot.docs) {
          var data = userDoc.data() as Map<String, dynamic>;
          String userEmail = data['email'];
          String userBabyName = data['babyName'];
          String userParentName = data['parentName'];

          CollectionReference healthDataRef = userDoc.reference.collection('health');
          QuerySnapshot healthDataSnapshot = await healthDataRef.get();

          for (var healthDoc in healthDataSnapshot.docs) {
            var healthData = healthDoc.data() as Map<String, dynamic>;

            // Extract health data fields
            String tinggi = healthData['height'] != null ? healthData['height'].toString() : '';
            String berat = healthData['weight'] != null ? healthData['weight'].toString() : '';
            String lingkarKepala = healthData['headCircumference'] != null ? healthData['headCircumference'].toString() : '';
            // Replace 'lingkar_kepala' with the actual field name
            DateTime dateTime = healthData['dateTime'] != null ? (healthData['dateTime'] as Timestamp).toDate() : DateTime.now();

            // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
            csvData.add([userEmail, userBabyName, userParentName, tinggi, berat, lingkarKepala, dateTime.toString()]);
          }
        }
        String csv = const ListToCsvConverter().convert(csvData);
        return csv;
      } else {
        print('You are not authorized to access this data.');
        return '';
      }
    }
    return '';
  }

  Future<String> getUserDataAsCSV(String userId) async {
    List<List<String>> csvData = [
      // Header row
      ["Email", "Nama Bayi", "Nama Orang Tua","Tinggi", "Berat", "Lingkar Kepala", "Datetime"]
    ];

    // Fetch user document by ID
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      var userData = userDoc.data() as Map<String, dynamic>;
      String userEmail = userData['email'];
      String userBabyName = userData['babyName'];
      String userParentName = userData['parentName'];

      CollectionReference healthDataRef = userDoc.reference.collection('health');
      QuerySnapshot healthDataSnapshot = await healthDataRef.get();

      for (var healthDoc in healthDataSnapshot.docs) {
        var healthData = healthDoc.data() as Map<String, dynamic>;

        // Extract health data fields
        String tinggi = healthData['height'] != null ? healthData['height'].toString() : '';
        String berat = healthData['weight'] != null ? healthData['weight'].toString() : '';
        String lingkarKepala = healthData['headCircumference'] != null ? healthData['headCircumference'].toString() : '';
        int timestamp = healthData['dateTime'] ?? 0;

        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
        // print(formattedDate); // Outputs the formatted date
        csvData.add([userEmail, userBabyName, userParentName,  tinggi, berat, lingkarKepala, formattedDate]);
      }

      String csv = const ListToCsvConverter().convert(csvData);
      return csv;
    } else {
      print('User with ID $userId does not exist.');
      return '';
    }
  }

  Future<void> writeCSVToFile(String csv, String filePath) async {
    // Define the custom directory
    final directory = Directory('$filePath');

    // Check if the directory exists
    if (!await directory.exists()) {
      // If the directory doesn't exist, create it
      await directory.create(recursive: true);
    }

    // Create the full file path
    final path = '${filePath}health_data.csv';

    // Write the CSV file
    final File file = File(path);
    await file.writeAsString(csv);

    print('CSV file saved at $path');
  }
  Future<void> writeCSVAllUserToFile(String csv, String filePath) async {
    // Define the custom directory
    final directory = Directory('$filePath');

    // Check if the directory exists
    if (!await directory.exists()) {
      // If the directory doesn't exist, create it
      await directory.create(recursive: true);
    }

    // Create the full file path
    final path = '${filePath}all_health_data.csv';

    // Write the CSV file
    final File file = File(path);
    await file.writeAsString(csv);

    print('CSV file saved at $path');
  }
}