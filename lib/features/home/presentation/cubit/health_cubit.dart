import 'package:nutribaby_app/features/home/data/health_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/health_data_model.dart';


part 'health_state.dart';

class HealthCubit extends Cubit<HealthState> {
  HealthCubit() : super(HealthInitial());

  Future<void> addData({
    // String? id,
    required double weight,
    required double height,
    required double headCircumference,
    DateTime? dateTime,
  }) async {
    try {
      emit(HealthLoading());

      bool hasDataForToday = await HealthService().hasDataForToday(dateTime!);

      if (hasDataForToday) {
        emit(HealthFailed("Health data for today already exists."));
      } else {
        await HealthService().addData(
          // id: id,
          weight: weight,
          height: height,
          headCircumference: headCircumference,
          dateTime: dateTime,
        );
        emit(HealthAddedSuccess());
      }
    } catch (e) {
      emit(HealthFailed(e.toString()));
    }
  }

  void fetchHealthData() async {
    try {
      emit(HealthLoading());
      //Fetch From Firestore
      Map<String, List<List<dynamic>>> healthData =
      await HealthService().fetchHealthData();

      // Convert data to a more usable format for the Chart
      List<LineData> weightDataList =
      HealthService().convertDataToList(healthData, 'weight');
      List<LineData> heightDataList =
      HealthService().convertDataToList(healthData, 'height');
      List<LineData> headCircumferenceDataList =
      HealthService().convertDataToList(healthData, 'headCircumference');

      emit(HealthSuccess({
        'weight': weightDataList,
        'height': heightDataList,
        'headCircumference': headCircumferenceDataList,
      }));
    } catch (e) {
      emit(HealthFailed(e.toString()));
    }
  }

  // List<_LineData> getChartData(List<HealthModel> healthDataList) {
  //   return healthDataList.map((healthData) {
  //     return _LineData(healthData.weight, healthData.dateTime);
  //   }).toList();
  // }
}

