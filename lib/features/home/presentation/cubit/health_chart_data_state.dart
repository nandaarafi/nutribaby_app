part of 'health_chart_data_cubit.dart';

abstract class HealthChartDataState extends Equatable {
  const HealthChartDataState();

  @override
  List<Object> get props => [];
}

class HealthChartDataInitial extends HealthChartDataState {}

class HealthNewLoading extends HealthChartDataState {}

class HealthAddedSuccess extends HealthChartDataState {}

class HealthNewSuccess extends HealthChartDataState {
  final Map<String, List<LineData>> health;
  HealthNewSuccess(this.health);

  @override
  List<Object> get props => [ health];
}

class HealthNewFailed extends HealthChartDataState {
  final String error;

  HealthNewFailed(this.error);

  @override
  List<Object> get props => [error];
}