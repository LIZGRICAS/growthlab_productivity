class RestDataSource {
  Future<List<String>> fetchExternalTasks() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return [
      'REST: Validate Engagement Rate', 
      'REST: Optimize Cold Start', 
      'REST: Sync LTV Data'
    ];
  }
}
