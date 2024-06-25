import 'package:equatable/equatable.dart';

class HealthModel extends Equatable {
  final String? documentId;
  final double weight;
  final double height;
  final double headCircumference;
  final DateTime dateTime;

  HealthModel({
    this.documentId,
    required this.weight,
    required this.height,
    required this.headCircumference,
    DateTime? dateTime, // Use DateTime? to allow nullable values
  }) : dateTime = dateTime ?? DateTime.now(); // Use the null-aware coalescing operator to provide a default value


  @override
  List<Object?> get props => [documentId,weight, height, headCircumference, dateTime];
}

class TrendModel extends Equatable {
  final double weightTrend;
  final double heightTrend;
  final double headCircumferenceTrend;

  TrendModel({
    required this.weightTrend,
    required this.heightTrend,
    required this.headCircumferenceTrend,
  });


  @override
  List<Object?> get props => [weightTrend, heightTrend, headCircumferenceTrend];
}

class LineData {
  String? documentId;
  double sideValue;
  DateTime date;


  LineData({
      this.documentId,
      required this.sideValue,
      required this.date
  });

  double calculateWeightAverage(List<HealthModel> dataList) {
    double sum = dataList.fold(0, (prev, current) => prev + current.weight);
    return dataList.isEmpty ? 0.0 : sum / dataList.length;
  }

  double calculateHeightAverage(List<HealthModel> dataList) {
    double sum = dataList.fold(0, (prev, current) => prev + current.height);
    return dataList.isEmpty ? 0.0 : sum / dataList.length;
  }

  double calculateHeadCircumferenceAverage(List<HealthModel> dataList) {
    double sum = dataList.fold(0, (prev, current) => prev + current.headCircumference);
    return dataList.isEmpty ? 0.0 : sum / dataList.length;
  }

  @override
  List<Object?> get props => [sideValue, date];
}


//
//   factory HealthModel.fromJson(String id, Map<String, dynamic> json) =>
//       HealthModel(
//         id: id,
//         weight: json['weight'].toDouble(),
//         height: json['height'].toDouble(),
//         headCircumference: json['headCircumference'].toDouble(),
//       );
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'weight': weight,
//     'height': height,
//     'headCircumference': headCircumference,
//   };
//
//   @override
//   List<Object?> get props => [id, weight, height, headCircumference];
// }
//
class HealthRealModel extends Equatable {
  final String weight;
  final String height;
  final String headCircumference;
  final String dateNow;

  HealthRealModel({
    required this.weight,
    required this.height,
    required this.headCircumference,
    required this.dateNow,
  });

  @override
  List<Object?> get props => [weight, height, headCircumference, dateNow];
}

  class HealthConclusionModel extends Equatable {
  final String statusGizi;
  final String statusKepala;
  // final String headCircumference;
  // final String dateNow;

  HealthConclusionModel({
    required this.statusGizi,
    required this.statusKepala,
    // required this.headCircumference,
    // required this.dateNow,
  });

  @override
  List<Object?> get props => [statusGizi, statusKepala];
  }
// class HealthSaveRemoteModel extends Equatable {
//   final String id;
//   final String weight;
//   final String height;
//   final String headCircumference;
//   final DateTime datetime;
//
//   HealthSaveRemoteModel({
//     this.id = "",
//     this.weight = "",
//     this.height = "",
//     this.headCircumference = "",
//     DateTime? datetime,
// }) : datetime = datetime ?? DateTime.now();
//
//   @override
//   List<Object?> get props => [id, weight, height, headCircumference];
// }

// class HealthRealtimeModel extends Equatable {
//   // final String id;
//   final double weight;
//   final double height;
//   final double headCircumference;
//
//
//   HealthRealtimeModel({
//     // required this.id,
//     this.weight = 0.0,
//     this.height = 0.0,
//     this.headCircumference = 0.0,
//   });
//
//   factory HealthRealtimeModel.fromJson(String id, Map<String, dynamic> json) =>
//       HealthRealtimeModel(
//         // id: id,
//         weight: json['weight'].toDouble(),
//         height: json['height'].toDouble(),
//         headCircumference: json['headCircumference'].toDouble(),
//       );
//
//   Map<String, dynamic> toJson() => {
//     // 'id': id,
//     'weight': weight,
//     'height': height,
//     'headCircumference': headCircumference,
//   };
//
//   @override
//   List<Object?> get props => [ weight, height, headCircumference];
