import 'package:flutter_bloc/flutter_bloc.dart';
import '../api_service.dart';
import 'prediction_event.dart';
import 'prediction_state.dart';

class PredictionBloc extends Bloc<PredictionEvent, PredictionState> {
  final ApiService apiService;

  PredictionBloc({required this.apiService}) : super(PredictionInitial()) {
    on<PredictScoreEvent>(_onPredictScore);
  }

  Future<void> _onPredictScore(PredictScoreEvent event, Emitter<PredictionState> emit) async {
    emit(PredictionLoading());
    try {
      final response = await apiService.predictScore(event.data);
      if (response['status'] == 'success') {
        emit(PredictionLoaded((response['predicted_math_score'] as num).toDouble()));
      } else {
        emit(const PredictionError('Failed to get prediction from server.'));
      }
    } catch (e) {
      emit(PredictionError(e.toString()));
    }
  }
}
