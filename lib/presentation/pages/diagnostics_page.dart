import 'dart:async';
import 'package:flutter/material.dart';

// Logger que expone un stream de eventos de diagnóstico
import '../../data/datasources/diagnostics_logger.dart';

// DataSource concreto de CleverTap (⚠️ esto lo analizamos luego)
import '../../data/datasources/clevertap_datasource.dart';

/// Página de diagnóstico usada para inspeccionar
/// logs internos y ejecutar llamadas de prueba.
///
/// Esta pantalla NO es de usuario final.
/// Está pensada para debug, QA o ambientes internos.
class DiagnosticsPage extends StatefulWidget {
  const DiagnosticsPage({super.key});

  @override
  State<DiagnosticsPage> createState() => _DiagnosticsPageState();
}

class _DiagnosticsPageState extends State<DiagnosticsPage> {
  /// Suscripción al stream de eventos de diagnóstico
  late final StreamSubscription<DiagnosticsEntry> _sub;

  /// Lista local de entradas que se muestran en pantalla
  List<DiagnosticsEntry> entries = [];

  @override
  void initState() {
    super.initState();

    // Inicializa la UI con el snapshot actual del logger
    entries = DiagnosticsLogger.snapshot;

    // Se suscribe al stream para recibir nuevos eventos en tiempo real
    _sub = DiagnosticsLogger.stream.listen((e) {
      setState(() => entries.insert(0, e));
    });
  }

  @override
  void dispose() {
    // Cancela la suscripción para evitar memory leaks
    _sub.cancel();
    super.dispose();
  }

  /// Ejecuta una serie de llamadas de ejemplo contra CleverTap
  /// para validar que la integración funcione correctamente.
  Future<void> _runSample() async {
    final ds = CleverTapDataSource();

    final profile = {
      'Name': 'Diag Tester',
      'Identity': '9999999999',
      'Email': 'diag@example.com',
      'Phone': '571234567890'
    };

    // Login de usuario de prueba
    try {
      await ds.onUserLoginFromMap(profile);
    } catch (_) {}

    // Actualización de atributos de perfil
    try {
      await ds.profilePush('9999999999', {'TestAttr': 'ok'});
    } catch (_) {}

    // Evento de tracking de prueba
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
          // Limpia el logger y la lista visible
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              DiagnosticsLogger.clear();
              setState(() => entries.clear());
            },
            tooltip: 'Clear logs',
          ),

          // Ejecuta las llamadas de ejemplo
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: _runSample,
            tooltip: 'Run sample calls',
          ),
        ],
      ),

      // Lista de logs
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, i) {
          final e = entries[i];
          return ListTile(
            dense: true,
            title: Text(
              e.message,
              style: const TextStyle(fontSize: 12),
            ),
            subtitle: Text(
              '${e.time.toIso8601String()} • ${e.level}',
            ),
          );
        },
      ),
    );
  }
}
