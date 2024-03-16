import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/health_data_source.dart';
import '../../domain/health_data_model.dart';

part 'health_chart_data_state.dart';

class HealthChartDataCubit extends Cubit<HealthChartDataState> {
  HealthChartDataCubit() : super(HealthChartDataInitial());

  Future fetchNewHealthData(
      DateTime startDate,
      DateTime endDate,
      ) async {
    try {
      emit(HealthNewLoading());
      Map<String, List<List<dynamic>>> healthData =
      await HealthService().fetchNewHealthData(startDate: startDate, endDate: endDate);
      // List<List<dynamic>>? specificData = healthData['your_key_here'];
      // if (specificData == null || specificData.isEmpty) {
      //   emit(HealthNewFailed('No health data found for the specified date range'));
      //   return; // Exit early from the method
      // } else {
        List<LineData> weightDataList = HealthService().convertDataToList(healthData, 'weight');
        List<LineData> heightDataList = HealthService().convertDataToList(healthData, 'height');
        List<LineData> headCircumferenceDataList =
        HealthService().convertDataToList(healthData, 'headCircumference');

        if (weightDataList.isEmpty || weightDataList == null){
          emit(HealthNewFailed("Data Error"));
        }else{
        emit(HealthNewSuccess({
          'weight': weightDataList,
          'height': heightDataList,
          'headCircumference': headCircumferenceDataList,
        }));
      }
    } catch (e) {
      emit(HealthNewFailed(e.toString()));
    }
  }
}

