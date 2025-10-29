import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

class HandStream {
  static const _channel = MethodChannel('signlink/hands');
  final _controller = StreamController<List<List<double>>?>.broadcast();

  HandStream() {
    if (!kIsWeb) {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'landmarks') {
          final dynamic data = call.arguments;
          if (data is List && data.isNotEmpty) {
            final first = data.first as List<dynamic>;
            final pts = first.map<List<double>>(
              (e) => (e as List).map((n) => (n as num).toDouble()).toList()
            ).toList();
            _controller.add(pts);
          } else {
            _controller.add(null);
          }
        }
        return null;
      });
    }
  }

  Stream<List<List<double>>?> get stream => _controller.stream;

  Future<void> start() async {
    if (kIsWeb) {
      // Web platform: hand tracking not supported
      // Just emit null to prevent errors
      return;
    }
    return _channel.invokeMethod('start');
  }

  Future<void> stop() async {
    if (kIsWeb) {
      return;
    }
    return _channel.invokeMethod('stop');
  }
}
