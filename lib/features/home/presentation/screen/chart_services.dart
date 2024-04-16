import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChartDataRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<int, double>> fetchDataFromFirestore() async {
    User? user = _auth.currentUser;

    if (user != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('chartData')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp')
          .get();

      Map<int, double> data = {};

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Timestamp timestamp = documentSnapshot['timestamp'];
        double value = documentSnapshot['value'];

        // Convert timestamp to milliseconds
        int timestampMilliseconds = timestamp.millisecondsSinceEpoch;

        data[timestampMilliseconds] = value;
      }

      return data;
    } else {
      // Handle the case where the user is not authenticated
      throw Exception('User not authenticated');
    }
  }
}