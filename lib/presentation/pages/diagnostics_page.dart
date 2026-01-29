import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/datasources/diagnostics_logger.dart';
import '../../data/datasources/clevertap_datasource.dart';

class DiagnosticsPage extends StatefulWidget {
  const DiagnosticsPage({super.key});

  @override
  State<DiagnosticsPage> createState() => _DiagnosticsPageState();
}

class _DiagnosticsPageState extends State<DiagnosticsPage> {
  late final StreamSubscription<DiagnosticsEntry> _sub;
  List<DiagnosticsEntry> entries = [];

  @override
  void initState() {
    super.initState();
    entries = DiagnosticsLogger.snapshot;
    _sub = DiagnosticsLogger.stream.listen((e) {
      setState(() => entries.insert(0, e));
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  Future<void> _runSample() async {
    final ds = CleverTapDataSource();
    final profile = {
      'Name': 'Diag Tester',
      'Identity': '9999999999',
      'Email': 'diag@example.com',
      'Phone': '571234567890'
    };
    try {
      await ds.onUserLoginFromMap(profile);
    } catch (_) {}
    try {
      await ds.profilePush('9999999999', {'TestAttr': 'ok'});
    } catch (_) {}
    try {
      await ds.trackEvent('Diag_Hola', {'from': 'diag'});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              DiagnosticsLogger.clear();
              setState(() => entries.clear());
            },
            tooltip: 'Clear logs',
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _runSample,
            tooltip: 'Run sample calls',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, i) {
          final e = entries[i];
          return ListTile(
            dense: true,
            title: Text(e.message, style: const TextStyle(fontSize: 12)),
            subtitle: Text('${e.time.toIso8601String()} • ${e.level}'),
          );
        },
      ),
    );
  }
}
