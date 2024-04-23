part of 'health_realtime_cubit.dart';

abstract class HealthRealtimeState extends Equatable {
  const HealthRealtimeState();

  @override
  List<Object> get props => [];
}

class HealthRealtimeInitial extends HealthRealtimeState {}

class HealthRealtimeLoading extends HealthRealtimeState {}


class HealthRealtimeSuccess extends HealthRealtimeState {
  final List<HealthRealModel> healthReal;

  HealthRealtimeSuccess(this.healthReal);

  @override
  List<Object> get props => [healthReal];
}
class HealthRealtimeConclusionSucces extends HealthRealtimeState {
  final String healthReal;

  HealthRealtimeConclusionSucces(this.healthReal);

  @override
  List<Object> get props => [healthReal];
}

class HealthRealtimeFailed extends HealthRealtimeState {
  final String error;

  HealthRealtimeFailed(this.error);

  @override
  List<Object> get props => [error];
}