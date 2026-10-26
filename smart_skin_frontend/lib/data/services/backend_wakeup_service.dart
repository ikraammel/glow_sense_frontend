import 'package:dio/dio.dart';

import '../../constants/constants.dart';

typedef HealthProbe = Future<bool> Function();

class BackendWakeUpService {
  BackendWakeUpService({
    Dio? dio,
    this.maxAttempts = 6,
    this.retryDelay = const Duration(seconds: 3),
    HealthProbe? probe,
  })  : _dio = dio ?? Dio(),
        _probe = probe;

  final Dio _dio;
  final int maxAttempts;
  final Duration retryDelay;
  final HealthProbe? _probe;
  Future<bool>? _inFlight;

  Future<bool> wakeUp() {
    final activeProbe = _inFlight;
    if (activeProbe != null) return activeProbe;

    final attempt = _runProbe();
    _inFlight = attempt;
    attempt.whenComplete(() {
      if (identical(_inFlight, attempt)) _inFlight = null;
    });
    return attempt;
  }

  Future<bool> _runProbe() async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final healthy = await (_probe?.call() ?? _defaultProbe());
        if (healthy) return true;
      } catch (_) {
        // A sleeping backend and a transient network failure are expected here.
      }
      if (attempt < maxAttempts - 1) {
        await Future<void>.delayed(retryDelay);
      }
    }
    return false;
  }

  Future<bool> _defaultProbe() async {
    final response = await _dio.get<dynamic>(
      '${AppConstants.baseUrl}/actuator/health',
      options: Options(
        sendTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 15),
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );
    if (response.statusCode != 200) return false;
    final data = response.data;
    if (data is Map && data['status'] != null) {
      return data['status'].toString().toUpperCase() == 'UP';
    }
    return false;
  }
}
