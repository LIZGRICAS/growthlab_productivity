import 'package:equatable/equatable.dart';

class AppConfig extends Equatable {
  final bool enablePremium;
  final String activeCampaign;
  final int syncThreshold;

  const AppConfig({
    required this.enablePremium, 
    required this.activeCampaign,
    required this.syncThreshold,
  });

  @override
  List<Object?> get props => [enablePremium, activeCampaign, syncThreshold];
}
