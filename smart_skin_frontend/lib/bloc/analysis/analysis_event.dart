import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();
  @override
  List<Object?> get props => [];
}

class SubmitAnalysis extends AnalysisEvent {
  final XFile image;
  const SubmitAnalysis(this.image);
  @override
  List<Object?> get props => [image.path];
}

class LoadAnalysisHistory extends AnalysisEvent {
  const LoadAnalysisHistory();
}
