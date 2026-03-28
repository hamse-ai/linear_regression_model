import 'package:equatable/equatable.dart';

abstract class PredictionEvent extends Equatable {
  const PredictionEvent();

  @override
  List<Object?> get props => [];
}

class PredictScoreEvent extends PredictionEvent {
  final Map<String, dynamic> data;

  const PredictScoreEvent(this.data);

  @override
  List<Object?> get props => [data];
}
