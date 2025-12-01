import 'package:flutter/services.dart';

class UptimeService {
  static const MethodChannel _channel = MethodChannel('uptime_channel');

  /// Retorna tempo desde ultimo boot
  static Future<int> getUptimeMillis() async {
    try {
      final int uptime = await _channel.invokeMethod('getUptime');
      return uptime;
    } catch (e) {
      return 0;
    }
  }
}
