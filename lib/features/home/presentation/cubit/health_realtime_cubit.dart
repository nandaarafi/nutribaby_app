import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutribaby_app/features/home/data/health_data_source.dart';
import 'package:nutribaby_app/features/home/domain/health_data_model.dart';

part 'health_realtime_state.dart';

class HealthRealtimeCubit extends Cubit<HealthRealtimeState> {
  HealthRealtimeCubit() : super(HealthRealtimeInitial());

  void fetchRealtime() async {
    try {
      emit(HealthRealtimeLoading());

      List<HealthRealModel> healthReal =
      await HealthService().fetchRealtime();

      emit(HealthRealtimeSuccess(healthReal));
    } catch (e) {
      emit(HealthRealtimeFailed(e.toString()));
    }
  }

  void fetchRealtimeConclusion() async {
    try {
      emit(HealthRealtimeLoading());

      List<HealthConclusionModel> healthReal =
      await HealthService().fetchRealtimeConclusion();

      emit(HealthRealtimeConclusionSucces(healthReal));
    } catch (e) {
      emit(HealthRealtimeFailed(e.toString()));
    }
  }
}
