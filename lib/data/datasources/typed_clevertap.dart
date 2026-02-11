// Este es un wrapper tipado ligero alrededor del complemento CleverTap MethodChannel
// Aísla:
// MethodChannel
// cambios de API del plugin
// 📌 decisión para estabilidad. Evita conversiones dinámicas a la vez que preserva la compatibilidad en tiempo de ejecución con la implementación del complemento de la plataforma.

import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'diagnostics_logger.dart';


class TypedCleverTap {
  static const MethodChannel _channel = MethodChannel('clevertap_plugin');

  static Future<void> onUserLogin(Map<String, dynamic> profile) async {
    DiagnosticsLogger.log('REQ onUserLogin: $profile', level: 'req');
    try {
      await _channel.invokeMethod('onUserLogin', profile);
      DiagnosticsLogger.log('RESP onUserLogin: ok', level: 'resp');
    } on PlatformException catch (e, st) {
      developer.log('TypedCleverTap.onUserLogin failed: $e', name: 'TypedCleverTap', error: e, stackTrace: st);
      DiagnosticsLogger.log('ERR onUserLogin: $e', level: 'err');
      rethrow;
    }
  }

  static Future<void> profilePush(Map<String, dynamic> attrs) async {
    DiagnosticsLogger.log('REQ profilePush: $attrs', level: 'req');
    try {
      await _channel.invokeMethod('profilePush', attrs);
      DiagnosticsLogger.log('RESP profilePush: ok', level: 'resp');
    } on PlatformException catch (e, st) {
      developer.log('TypedCleverTap.profilePush failed: $e', name: 'TypedCleverTap', error: e, stackTrace: st);
      DiagnosticsLogger.log('ERR profilePush: $e', level: 'err');
      rethrow;
    }
  }

  static Future<void> recordEvent(String name, Map<String, dynamic> props) async {
    DiagnosticsLogger.log('REQ recordEvent: $name $props', level: 'req');
    try {
      await _channel.invokeMethod('recordEvent', {'name': name, 'props': props});
      DiagnosticsLogger.log('RESP recordEvent: ok', level: 'resp');
    } on PlatformException catch (e, st) {
      developer.log('TypedCleverTap.recordEvent failed: $e', name: 'TypedCleverTap', error: e, stackTrace: st);
      DiagnosticsLogger.log('ERR recordEvent: $e', level: 'err');
      rethrow;
    }
  }
}
