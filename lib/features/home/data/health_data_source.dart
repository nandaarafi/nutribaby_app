import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intl/intl.dart';
import '../../../core/errors/exceptions.dart';

import '../domain/health_data_model.dart';

class HealthService {
  final DatabaseReference _healthRealRef = FirebaseDatabase.instance.ref()
      .child('health');
  CollectionReference _healthReference = FirebaseFirestore.instance.collection(
      'users');
  final FirebaseAuth _auth = FirebaseAuth.instance;


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

  // Future<Map<String, List<List<dynamic>>>> fetchHealthData(
  //     {int limit = 20, QueryDocumentSnapshot? lastDocument}) async {
  //   try {
  //     var query = _healthReference
  //         .doc(_auth.currentUser!.uid)
  //         .collection('health')
  //         .orderBy("dateTime", descending: false)
  //         .limit(20);
  //
  //     if (lastDocument != null) {
  //       query = query.startAfterDocument(lastDocument);
  //     }
  //
  //     QuerySnapshot querySnapshot = await query.get();
  //
  //     List<List<dynamic>> weightDataList = [];
  //     List<List<dynamic>> heightDataList = [];
  //     List<List<dynamic>> headCircumferenceDataList = [];
  //
  //     for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
  //       Map<String, dynamic> data =
  //       docSnapshot.data() as Map<String, dynamic>;
  //
  //       DateTime timestamp =
  //       (data['dateTime'] as Timestamp).toDate();
  //
  //       // Add weight data
  //       weightDataList.add([data['weight'] ?? 0.0, timestamp]);
  //
  //       // Add height data
  //       heightDataList.add([data['height'] ?? 0.0, timestamp]);
  //
  //       // Add head circumference data
  //       headCircumferenceDataList
  //           .add([data['headCircumference'] ?? 0.0, timestamp]);
  //     }
  //
  //     // Create a map to store the lists
  //     Map<String, List<List<dynamic>>> healthDataMap = {
  //       'weight': weightDataList,
  //       'height': heightDataList,
  //       'headCircumference': headCircumferenceDataList,
  //     };
  //
  //     return healthDataMap;
  //   } catch (e) {
  //     throw e;
  //   }

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
          // .where('dateTime',
          // isGreaterThan: DateTime.now().subtract(Duration(days: 7)),
          // isLessThan: DateTime.now())

    List<List<dynamic>> weightDataList = [];
      List<List<dynamic>> heightDataList = [];
      List<List<dynamic>> headCircumferenceDataList = [];

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String documentId = docSnapshot.id; // Get the document ID
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        DateTime timestamp = (data['dateTime'] as Timestamp).toDate();
        weightDataList.add([documentId, data['weight'] ?? 0.0, timestamp]);
        heightDataList.add([documentId, data['height'] ?? 0.0, timestamp]);
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
          // .limit(limit)
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

  // Future<void> getLineData() async{
  //   try{
  //     QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //     await _healthReference
  //         .doc(_auth.currentUser!.uid)
  //         .collection('health')
  //         .orderBy('dateTime', descending: false)
  //         // .where('weight',isNotEqualTo: null)
  //         // .where('dateTime', isNotEqualTo: null)
  //         .get();
  //
  //     List<LineData> lineDataList = querySnapshot.docs.map((doc) {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //
  //       // Make sure to replace 'sideValue' and 'date' with the actual field names in your Firestore documents
  //       return LineData(
  //         sideValue: data['height'] ?? 0.0,
  //         date: (data['dateTime'] as Timestamp).toDate(),
  //       );
  //     }).toList();
  //
  //     print(lineDataList);
  //   }catch(e){
  //     throw(e);
  //   }
  // }



  // Future<Map<String, List<List<dynamic>>>> fetchHealthData() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _healthReference
  //         .doc(_auth.currentUser!.uid)
  //         .collection('health')
  //     .orderBy("dateTime", descending: false)
  //     .get();
  //         // .get();
  //
  //     List<List<dynamic>> weightDataList = [];
  //     List<List<dynamic>> heightDataList = [];
  //     List<List<dynamic>> headCircumferenceDataList = [];
  //
  //     for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
  //       Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
  //
  //       DateTime timestamp = (data['dateTime'] as Timestamp).toDate();
  //
  //       // Add weight data
  //       weightDataList.add([data['weight'] ?? 0.0, timestamp]);
  //
  //       // Add height data
  //       heightDataList.add([data['height'] ?? 0.0, timestamp]);
  //
  //       // Add head circumference data
  //       headCircumferenceDataList.add([data['headCircumference'] ?? 0.0, timestamp]);
  //     }
  //
  //     // Create a map to store the lists
  //     Map<String, List<List<dynamic>>> healthDataMap = {
  //       'weight': weightDataList,
  //       'height': heightDataList,
  //       'headCircumference': headCircumferenceDataList,
  //     };
  //
  //     return healthDataMap;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

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

  // Future<bool> hasDataForToday() async {
  //   DateTime today = DateTime.now();
  //
  //   // Query Firestore or any other data source to check if data for today exists
  //   // Example: Assuming you have a collection 'healthData' with a field 'dateTime'
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('healthData')
  //       .where('dateTime', isGreaterThanOrEqualTo: today)
  //       .where('dateTime', isLessThan: today.add(Duration(days: 1)))
  //       .get();
  //
  //   return querySnapshot.docs.isNotEmpty;
  // }
  Future<List<HealthRealModel>> fetchRealtime() async {
    try {
      final weight = await _healthRealRef.child('weight').get();
      final height = await _healthRealRef.child('height').get();
      final headCircumference = await _healthRealRef.child('lingkarKepala')
          .get();

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
