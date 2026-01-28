
import 'package:equatable/equatable.dart';

abstract class GrowthEvent extends Equatable {
  const GrowthEvent();
  @override
  List<Object?> get props => [];
}

class CreateUserRequested extends GrowthEvent {}
class CompleteProfileRequested extends GrowthEvent {}
class TrackEventRequested extends GrowthEvent {}
class SyncDataRequested extends GrowthEvent {}
class GenerateTasksRequested extends GrowthEvent {}
class NavigationTabChanged extends GrowthEvent {
  final int index;
  const NavigationTabChanged(this.index);
}
