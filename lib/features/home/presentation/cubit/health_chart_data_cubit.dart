import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutribaby_app/features/home/presentation/cubit/health_cubit.dart';
import 'package:nutribaby_app/features/home/presentation/cubit/utils.dart';

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

        List<LineData> weightDataList = HealthService().convertDataToList(healthData, 'weight');
        List<LineData> heightDataList = HealthService().convertDataToList(healthData, 'height');
        List<LineData> headCircumferenceDataList = HealthService().convertDataToList(healthData, 'headCircumference');

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
  void exportNewDataToCsv() {
    if (state is HealthNewSuccess) {
      final currentState = state as HealthNewSuccess;

      List<LineData> weightDataList = currentState.health['weight'] ?? [];
      List<LineData> heightDataList = currentState.health['height'] ?? [];
      List<LineData> headCircumferenceDataList = currentState.health['headCircumference'] ?? [];

      Map<String, List<LineData>> healthData = {
        'weight': weightDataList,
        'height': heightDataList,
        'headCircumference': headCircumferenceDataList,
      };

      saveToCsv(healthData);
    }
  }




}

