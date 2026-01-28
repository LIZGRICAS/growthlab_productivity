
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

enum GrowthStatus { initial, loading, success, error }

class GrowthState extends Equatable {
  final GrowthStatus status;
  final int activeTab;
  final UserProfile? user;
  final List<String> tasks;
  final List<String> logs;

  const GrowthState({
    this.status = GrowthStatus.initial,
    this.activeTab = 0,
    this.user,
    this.tasks = const [],
    this.logs = const ['Growth Engine Booted...'],
  });

  GrowthState copyWith({
    GrowthStatus? status,
    int? activeTab,
    UserProfile? user,
    List<String>? tasks,
    List<String>? logs,
  }) {
    return GrowthState(
      status: status ?? this.status,
      activeTab: activeTab ?? this.activeTab,
      user: user ?? this.user,
      tasks: tasks ?? this.tasks,
      logs: logs ?? this.logs,
    );
  }

  @override
  List<Object?> get props => [status, activeTab, user, tasks, logs];
}
