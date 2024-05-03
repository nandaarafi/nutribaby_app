import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';
import '../domain/health_data_model.dart';

class HealthService {
  CollectionReference _healthReference = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _healthRealRef = FirebaseDatabase.instance.ref().child('${FirebaseAuth.instance.currentUser!.uid}');


  Future<bool> hasDataForToday(DateTime currentDate) async {
    DateTime today = currentDate;
    DateTime todayStart = DateTime(today.year, today.month, today.day);
    DateTime todayEnd = todayStart.add(Duration(days: 1));

    QuerySnapshot snapshot = await _healthReference
        .doc(_auth.currentUser!.uid)
        .collection('health') // Replace with your collection name
        .where('dateTime', isGreaterThanOrEqualTo: todayStart)
        .where('dateTime', isLessThan: todayEnd)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> addData({

    required double weight,
    required double height,
    required double headCircumference,
    DateTime? dateTime, // Use DateTime? to allow nullable values
  }) async {
    try {
      await _healthReference.doc(_auth.currentUser!.uid)
          .collection('health')
          .add({
        'weight': weight,
        'height': height,
        'headCircumference': headCircumference,
        'dateTime': dateTime,
        // 'dateTime': dateTime ?? DateTime.now(),
      });
    } catch (e) {
      throw e;
    }
  }



  Future<void> updateHealthData(String labelData, LineData lineData) async{
    try{
      var collection = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('health');
      Timestamp timestamp = Timestamp.fromDate(lineData.date);

      await collection.doc(lineData.documentId).update({
        '$labelData': lineData.sideValue,
        'dateTime': timestamp,
        // Add more fields to update as needed
      });
    } catch (e){
      throw(e);
    }
  }



  Future<Map<String, List<List<dynamic>>>> fetchHealthData(
      {int limit = 8}) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('health')
          .orderBy("dateTime", descending: true)
          .limit(limit)
          .get();


      List<List<dynamic>> weightDataList = [];
      List<List<dynamic>> heightDataList = [];
      List<List<dynamic>> headCircumferenceDataList = [];

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String documentId = docSnapshot.id;
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        DateTime timestamp = (data['dateTime'] as Timestamp).toDate();

        weightDataList.add([documentId, data['weight'] ?? 0.0, timestamp]);
        heightDataList.add([documentId, data['height'] ?? 0.0, timestamp]);
        headCircumferenceDataList.add([documentId, data['headCircumference'] ?? 0.0, timestamp]);
      }

      Map<String, List<List<dynamic>>> healthDataMap = {
        'weight': weightDataList,
        'height': heightDataList,
        'headCircumference': headCircumferenceDataList,
      };

      return healthDataMap;
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, List<List<dynamic>>>> fetchNewHealthData(
      {
        int limit = 8,
        required DateTime startDate,
        required DateTime endDate,
      }) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('health')
          .orderBy("dateTime", descending: false)
          .where('dateTime',
          isGreaterThanOrEqualTo: startDate,
          isLessThanOrEqualTo: endDate)
          .get();


      List<List<dynamic>> weightDataList = [];
      List<List<dynamic>> heightDataList = [];
      List<List<dynamic>> headCircumferenceDataList = [];

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String documentId = docSnapshot.id; // Get the document ID
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        // print(data);
        DateTime timestamp = (data['dateTime'] as Timestamp).toDate();

        // Add weight data
        weightDataList.add([documentId, data['weight'] ?? 0.0, timestamp]);

        // Add height data
        heightDataList.add([documentId, data['height'] ?? 0.0, timestamp]);

        // Add head circumference data
        headCircumferenceDataList.add([documentId, data['headCircumference'] ?? 0.0, timestamp]);
      }
      // print(weightDataList);

      // Create a map to store the lists
      Map<String, List<List<dynamic>>> healthDataMap = {
        'weight': weightDataList,
        'height': heightDataList,
        'headCircumference': headCircumferenceDataList,
      };

      return healthDataMap;
    } catch (e) {
      throw e;
    }
  }



  List<LineData> convertDataToList(Map<String, List<List<dynamic>>> healthData,
      String dataType) {
    List<LineData> lineDataList = healthData[dataType]?.map((entry) {
      return LineData(

        documentId: entry[0] as String,
        sideValue: entry[1] as double,
        date: entry[2] as DateTime,
      );
    }).toList() ?? [];

    return lineDataList;
  }

  Future<List<HealthRealModel>> fetchRealtime() async {
    try {
      final weight = await _healthRealRef.child('nilai-berat').get();
      final height = await _healthRealRef.child('nilai-kepala').get();
      final headCircumference = await _healthRealRef.child('nilai-tinggi').get();

      final DateLocalNow = DateFormat('dd-MM-yyyy').format(DateTime.now());
      print(weight);
      print(height);
      print(headCircumference);
      if (weight.exists && height.exists && headCircumference.exists) {
        final List<HealthRealModel> healthDataList = [
          HealthRealModel(
              weight: '${weight.value}' ,// Add 'kg' as a unit
              height: '${height.value}',
              headCircumference: '${headCircumference.value}',
              dateNow: DateLocalNow),



        ];
        print(weight);
        return healthDataList;
      } else {
        return []; // Return an empty list if any data is missing
      }
    } catch (error) {
      print('Error fetching data: $error');
      return []; // Return an empty list in case of an error
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> fetchRealtimeConclusion() async {
    try {
      final data = await _healthRealRef.child('status-kesimpulan').get();

      if (data.exists) {
        if (data.value is String) {
          String value = data.value as String;
          return value;
        } else {
          print("Error: Unexpected data type for 'weight'");
          return null;
        }
      } else {
        print("Error: Data does not exist at 'weight'");
        return null;
      }
    } catch (e) {
      print("Error getting data: $e");
      return null;
    }
  }


  // Future<List<DocumentSnapshot>> fetchDataForDay(DateTime selectedDay) async {
  //   final CollectionReference collection = FirebaseFirestore.instance
  //       .collection('your_collection');
  //
  //   // Calculate start and end timestamps for the selected day
  //   DateTime startOfDay = DateTime(
  //       selectedDay.year, selectedDay.month, selectedDay.day);
  //   DateTime endOfDay = DateTime(
  //       selectedDay.year,
  //       selectedDay.month,
  //       selectedDay.day,
  //       23,
  //       59,
  //       59,
  //       999,
  //       999);
  //   QuerySnapshot querySnapshot = await collection
  //       .where('dateTime', isGreaterThanOrEqualTo: startOfDay,
  //       isLessThanOrEqualTo: endOfDay)
  //       .get();
  //
  //   return querySnapshot.docs;
  // }



  Future<List<DocumentSnapshot>> fetchDataForDay(DateTime selectedDay) async {
    final CollectionReference collection = FirebaseFirestore.instance
        .collection('your_collection');

    // Calculate start and end timestamps for the selected day
    DateTime startOfDay = DateTime(
        selectedDay.year, selectedDay.month, selectedDay.day);
    DateTime endOfDay = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
        23,
        59,
        59,
        999,
        999);
    QuerySnapshot querySnapshot = await collection
        .where('dateTime', isGreaterThanOrEqualTo: startOfDay,
        isLessThanOrEqualTo: endOfDay)
        .get();

    return querySnapshot.docs;
  }

  Future<bool> checkDataExists() async {
    try {
      // Reference to the 'health' collection
      // CollectionReference healthCollection = FirebaseFirestore.instance.collection('health');

      // Query the collection to check if any documents exist

      QuerySnapshot querySnapshot = await _healthReference
          .doc(_auth.currentUser!.uid)
          .collection('health')
          .get();

      // Return true if there are documents in the collection, false otherwise
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors that might occur during the query
      print('Error checking data: $e');
      return false;
    }
  }


//TODO: Genereated Data

  Future<void> generateRawData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Add your logic to get the current user ID
      String userId = _auth.currentUser!.uid;

      // Initialize initial values
      double initialWeight = 50.0;
      double initialHeight = 160.0;
      double initialHeadCircumference = 55.0;

      // Calculate the number of days between start and end dates
      int numberOfDays = endDate.difference(startDate).inDays;

      // Generate data for the specified time range
      for (int i = 0; i <= numberOfDays; i++) {
        double weight = initialWeight + (i * 0.2);
        double height = initialHeight + (i * 0.2);
        double headCircumference = initialHeadCircumference + (i * 0.2);
        DateTime dateTime = startDate.add(Duration(days: i));

        // Add a delay of 100 milliseconds
        await Future.delayed(Duration(milliseconds: 100));

        // Add data to Firestore
        await _healthReference.doc(userId).collection('health').add({
          'weight': weight,
          'height': height,
          'headCircumference': headCircumference,
          'dateTime': dateTime,
        });
      }
    } catch (e) {
      throw e;
    }
  }
}
