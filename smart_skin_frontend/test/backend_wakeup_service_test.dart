import 'package:flutter_test/flutter_test.dart';

import 'package:glowsense_app/data/services/backend_wakeup_service.dart';

void main() {
  test('retries a failed probe and shares concurrent requests', () async {
    var calls = 0;
    final service = BackendWakeUpService(
      maxAttempts: 3,
      retryDelay: Duration.zero,
      probe: () async {
        calls++;
        await Future<void>.delayed(Duration.zero);
        return calls == 3;
      },
    );

    final results = await Future.wait([service.wakeUp(), service.wakeUp()]);

    expect(results, [true, true]);
    expect(calls, 3);
  });

  test('returns false after the bounded retry period', () async {
    var calls = 0;
    final service = BackendWakeUpService(
      maxAttempts: 2,
      retryDelay: Duration.zero,
      probe: () async {
        calls++;
        return false;
      },
    );

    expect(await service.wakeUp(), isFalse);
    expect(calls, 2);
  });
}
