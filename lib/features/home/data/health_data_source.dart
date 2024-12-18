import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';
import '../domain/health_data_model.dart';

class HealthService {
  CollectionReference _healthReference = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _healthRealRef = FirebaseDatabase.instance.ref(); //.child('${FirebaseAuth.instance.currentUser!.uid}');


  Future<String?> hasDataForToday(DateTime currentDate) async {
    DateTime todayStart = DateTime(currentDate.year, currentDate.month, currentDate.day);
    DateTime todayEnd = todayStart.add(Duration(days: 1));

    QuerySnapshot snapshot = await _healthReference
        .doc(_auth.currentUser!.uid)
        .collection('health')
        .where('dateTime', isGreaterThanOrEqualTo: todayStart)
        .where('dateTime', isLessThan: todayEnd)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Return the document ID of the first (and presumably only) matching document
      return snapshot.docs.first.id;
    } else {
      // No document found for today
      return null;
    }
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



  Future<void> editHealthData(String labelData, LineData lineData) async{
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

  Future<void> updateAllHealthData(
      {
        required String documentId,
        required double weight,
        required double height,
        required double headCircumference,
        DateTime? dateTime, // Use DateTime? to allow nullable values
      }
      ) async{
    try{
      var collection = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('health');
      Timestamp timestamp = Timestamp.fromDate(dateTime!);

      await collection.doc(documentId).update({
        'weight': weight,
        'height': height,
        'headCircumference': headCircumference,
        'dateTime': timestamp,
        // Add more fields to update as needed
      });
    } catch (e){
      throw(e);
    }
  }

  Future<void> deleteHealthData(LineData lineData) async{
    try{
      var collection = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('health');
      await collection.doc(lineData.documentId).delete();
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
      final height = await _healthRealRef.child('nilai-tinggi').get();
      final headCircumference = await _healthRealRef.child('nilai-kepala').get();

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

  Future<List<HealthConclusionModel>> fetchRealtimeConclusion() async {
    try {
      final statusGizi = await _healthRealRef.child('status-gizi').get();
      final statusKepala = await _healthRealRef.child('status-kepala').get();
      if (statusGizi.exists && statusKepala.exists) {
        final List<HealthConclusionModel> healthDataList = [
          HealthConclusionModel(
              statusGizi: '${statusGizi.value}' ,// Add 'kg' as a unit
              statusKepala: '${statusKepala.value}',
          )];
        return healthDataList;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching realtime conclusion: $e');
      throw Exception('Failed to fetch realtime conclusion');
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

  Future<void> generateRawData(
    // required DateTime startDate,
    // required DateTime endDate,
  ) async {
    try {
      DateTime startDate = DateTime.now();
      DateTime endDate =  DateTime(startDate.year, startDate.month, startDate.day - 7);

      // Add your logic to get the current user ID
      String userId = _auth.currentUser!.uid;

      // Initialize initial values
      // double initialWeight = 50.0;
      // double initialHeight = 160.0;
      // double initialHeadCircumference = 55.0;

      // Calculate the number of days between start and end dates
      int numberOfDays = endDate.difference(startDate).inDays;

      // Generate data for the specified time range
      for (double i = 0.0; i <= 1.4 ; i+=0.2) {
        double weight =  i;
        double height = i;
        double headCircumference = i;
        DateTime dateTime = startDate.add(Duration(days: (i * 10).toInt()));

        // Add a delay of 100 milliseconds
        await Future.delayed(Duration(milliseconds: 100));

        // Add data to Firestore
        await _healthReference.doc(userId).collection('health').add({
          'weight': double.parse(weight.toStringAsFixed(2)),
          'height': double.parse(height.toStringAsFixed(2)),
          'headCircumference': double.parse(headCircumference.toStringAsFixed(2)),
          'dateTime': dateTime,
        });
      }
    } catch (e) {
      throw e;
    }
  }
  //:ERROR can't fixed this
  Future<void> deleteDocumentsByDateRange() async {
    // var auth = FirebaseAuth.instance;
    var collection = FirebaseFirestore.instance
        .collection('users')
        .doc("XHvqpqujp2OBiZ6hllcl9FswJqp1")
        .collection('health');

    DateTime startDate = DateTime(2024, 6, 15); // Replace with your start date
    DateTime endDate = DateTime(2024, 6, 29);
    // Convert the DateTime to Timestamps (Firestore format)
    Timestamp startTimestamp = Timestamp.fromDate(startDate);
    Timestamp endTimestamp = Timestamp.fromDate(endDate);

    // Query the collection to find documents within the specified date range
    QuerySnapshot querySnapshot = await collection
        .where('datetimeField', isGreaterThanOrEqualTo: startTimestamp)
        .where('datetimeField', isLessThanOrEqualTo: endTimestamp)
        .get();

    // Loop through the results and delete the document(s)
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
