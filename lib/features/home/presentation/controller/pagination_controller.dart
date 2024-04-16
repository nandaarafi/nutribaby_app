// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:get/get.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:nutribaby_app/features/home/data/health_data_source.dart';
// import '../../domain/health_data_model.dart';
//
// class PaginationProvider extends ChangeNotifier {
//   final _usersSnapshot = <DocumentSnapshot>[];
//   String _errorMessage = '';
//   int documentLimit = 20;
//   bool _hasNext = true;
//   bool _isFetchingUsers = false;
//
//   String get errorMessage => _errorMessage;
//
//   bool get hasNext => _hasNext;
//
//   List<LineData> get lineData => _usersSnapshot.map((snap) {
//     final doc = snap.data() as Map<String, dynamic>?;
//
//     if (doc != null && doc['weight'] != null && doc['dateTime'] != null) {
//       return LineData(
//         sideValue: (doc['weight'] as num).toDouble(), // Assuming 'weight' is a numeric value
//         date: (doc['dateTime'] as Timestamp).toDate(),
//       );
//     } else {
//       // Handle the case where the data is missing or not in the expected format
//       return LineData(sideValue: 0.0, date: DateTime.now());
//     }
//   }).toList();
//
//   Future fetchNextUsers() async {
//     if (_isFetchingUsers) return;
//     _errorMessage = '';
//     _isFetchingUsers = true;
//
//     try {
//       final snap = await getUsers(
//         documentLimit,
//         startAfter: _usersSnapshot.isNotEmpty ? _usersSnapshot.last : null,
//       );
//       if (_usersSnapshot.isEmpty) {
//         _usersSnapshot.clear();
//       }
//       _usersSnapshot.addAll(snap.docs);
//
//       if (snap.docs.length < documentLimit) _hasNext = false;
//       notifyListeners();
//     } catch (error) {
//       _errorMessage = error.toString();
//       notifyListeners();
//     }
//
//     _isFetchingUsers = false;
//   }
//   static Future<QuerySnapshot> getUsers(
//       int limit, {
//         required DocumentSnapshot? startAfter,
//       }) async {
//     final refUsers = FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .collection('health')
//         .orderBy('dateTime', descending: false)
//         // .where('dateTime',
//         // isLessThan: DateTime(2023,12,25),
//         // isGreaterThan: DateTime(2023,12,20))
//         .limit(limit);
//
//     if (startAfter == null) {
//       return refUsers.get();
//     } else {
//       return refUsers.startAfterDocument(startAfter).get();
//     }
//   }
// }
// // class PaginationController extends GetxController {
// //   final PagingController<int, LineData> _pagingController = PagingController(firstPageKey: 0);
// //   final RxList<LineData> dataList = <LineData>[].obs;
// //   final RxBool isLoading = false.obs;
// //
// //   final ScrollController myScrollController = ScrollController();
// //   bool isLoadmore = true;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     // Fetch initial data
// //     fetchData();
// //     dataList.clear();
// //     print(dataList.length);
// //
// //     myScrollController.addListener(() {
// //       if (myScrollController.offset + 10 > myScrollController.position.maxScrollExtent) {
// //         if (isLoadmore && !isLoading.value) {
// //           isLoading.value = true;
// //           isLoadmore = false;
// //           asyncLoadMoreData();
// //           print("...Loading");
// //         }
// //       }
// //     });
// //   }
// //
// //   Future<void> fetchData() async {
// //     try {
// //       QuerySnapshot data = await FirebaseFirestore.instance
// //           .collection("users")
// //           .doc(FirebaseAuth.instance.currentUser!.uid)
// //           .collection('health')
// //           .orderBy("dateTime", descending: false)
// //           .where("weight", isNotEqualTo: null)
// //           .where('dateTime', isNotEqualTo: null)
// //           .limit(20)
// //           .get();
// //
// //       dataList.assignAll(data.docs.map((doc) {
// //         return LineData(
// //           sideValue: doc['weight'],
// //           date: doc['dateTime'],
// //         );
// //       }));
// //       print(dataList.length);
// //     } catch (error) {
// //       print("Error fetching initial data: $error");
// //     }
// //   }
// //
// //   Future<void> asyncLoadMoreData() async {
// //     try {
// //       QuerySnapshot data = await FirebaseFirestore.instance
// //           .collection("users")
// //           .doc(FirebaseAuth.instance.currentUser!.uid)
// //           .collection('health')
// //           .orderBy("dateTime", descending: false)
// //           .where("dateTime", isLessThan: dataList.last.date)
// //           .where("weight", isNotEqualTo: null)
// //           .where('dateTime', isNotEqualTo: null)
// //           .limit(20)
// //           .get();
// //
// //       if (data.docs.isNotEmpty) {
// //         dataList.addAll(data.docs.map((doc) {
// //           return LineData(
// //             sideValue: doc['weight'],
// //             date: doc['dateTime'],
// //           );
// //         }));
// //         print(dataList.length);
// //       }
// //     } catch (error) {
// //       print("Error fetching more data: $error");
// //     } finally {
// //       isLoading.value = false;
// //       isLoadmore = true;
// //     }
// //   }
// //
// //   @override
// //   void onClose() {
// //     myScrollController.dispose();
// //     super.onClose();
// //   }
// // }