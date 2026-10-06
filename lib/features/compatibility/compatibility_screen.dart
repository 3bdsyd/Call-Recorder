import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../platform/native_models.dart';
import '../diagnostics/diagnostics_screen.dart';

class CompatibilityScreen extends ConsumerStatefulWidget {
  const CompatibilityScreen({super.key});

  @override
  ConsumerState<CompatibilityScreen> createState() => _CompatibilityScreenState();
}

class _CompatibilityScreenState extends ConsumerState<CompatibilityScreen> {
  RecordingStrategy? _strategy;
  bool _testing = false;
  StreamSubscription<NativeCallEvent>? _sub;
  NativeCallEvent? _lastResult;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _startTest() async {
    final platform = ref.read(platformProvider);
    final repo = ref.read(callRepositoryProvider);
    setState(() { _testing = true; _lastResult = null; });

    // Capture the next completed recording as the test result.
    _sub?.cancel();
    _sub = repo.completedRecordings.listen((e) async {
      if (!mounted) return;
      final diag = e.diagnostics;
      if (diag == null) return;
      final color = CompatColor.fromStatus(diag.status);
      await platform.saveCompatResult(color, diag.strategy, diag.status);
      ref.invalidate(deviceInfoProvider);
      setState(() { _testing = false; _lastResult = e; });
      _sub?.cancel();
    });

    await platform.manualStart(strategy: _strategy);
  }

  Future<void> _stopTest() async {
    await ref.read(platformProvider).manualStop();
  }

  @override
  Widget build(BuildContext context) {
    final info = ref.watch(deviceInfoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار توافق الجهاز'),
        actions: [
          IconButton(
            tooltip: 'سجل التشخيص',
            icon: const Icon(Icons.bug_report_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DiagnosticsScreen()),
            ),
          ),
        ],
      ),
      body: info.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (d) => ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            _deviceCard(d),
            _resultCard(d),
            _strategyPicker(d),
            _testCard(d),
            const _GuidanceCard(),
          ],
        ),
      ),
    );
  }

  Widget _deviceCard(DeviceInfoData d) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('الجهاز', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${d.manufacturer} ${d.model}'),
              Text('أندرويد ${d.androidRelease} (SDK ${d.sdkInt})'),
              const SizedBox(height: 8),
              Text('Shizuku: ${d.shizukuInstalled ? 'مثبّت' : 'غير مثبّت'}'
                  '${d.shizukuRunning ? ' • يعمل' : ''}'
                  '${d.shizukuAuthorized ? ' • مُصرّح' : ''}'),
              if (d.shizukuRunning && !d.shizukuAuthorized)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FilledButton.tonal(
                    onPressed: () async {
                      await ref.read(platformProvider).requestShizukuPermission();
                      ref.invalidate(deviceInfoProvider);
                    },
                    child: const Text('منح إذن Shizuku'),
                  ),
                ),
            ],
          ),
        ),
      );

  Widget _resultCard(DeviceInfoData d) {
    final scheme = Theme.of(context).colorScheme;
    final color = (_lastResult?.diagnostics != null)
        ? CompatColor.fromStatus(_lastResult!.diagnostics!.status)
        : (d.savedColor ?? CompatColor.gray);
    return Card(
      child: ListTile(
        leading: Icon(Icons.circle, color: compatColorValue(color, scheme), size: 28),
        title: Text(color.arabicTitle),
        subtitle: _lastResult?.diagnostics != null
            ? Text('آخر اختبار: ${_lastResult!.diagnostics!.status.arabic} • '
                'قنوات ${_lastResult!.diagnostics!.channelCount}')
            : const Text('النتيجة مبنية على آخر اختبار حقيقي'),
      ),
    );
  }

  Widget _strategyPicker(DeviceInfoData d) {
    final options = <RecordingStrategy?>[null, ...d.availableStrategies];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('طريقة التسجيل للاختبار', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: options.map((s) {
                final selected = _strategy == s;
                return ChoiceChip(
                  label: Text(s?.arabic ?? 'تلقائي (الأفضل المتاح)'),
                  selected: selected,
                  onSelected: _testing ? null : (_) => setState(() => _strategy = s),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _testCard(DeviceInfoData d) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('اختبار بمكالمة حقيقية', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'أجرِ مكالمة حقيقية (واردة أو صادرة). أثناء المكالمة اضغط «ابدأ الاختبار»، '
                'تحدث أنت والطرف الآخر بضع ثوانٍ، ثم اضغط «أوقف الاختبار». سنحلّل الصوت '
                'ونخبرك هل التُقط الطرفان فعلاً.',
                style: TextStyle(height: 1.5, fontSize: 13),
              ),
              const SizedBox(height: 12),
              if (_testing)
                FilledButton.icon(
                  onPressed: _stopTest,
                  icon: const Icon(Icons.stop),
                  label: const Text('أوقف الاختبار وحلّل'),
                )
              else
                FilledButton.icon(
                  onPressed: _startTest,
                  icon: const Icon(Icons.fiber_manual_record),
                  label: const Text('ابدأ الاختبار'),
                ),
              if (_testing)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Row(children: [
                    SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 8),
                    Text('جارٍ التسجيل… تحدثوا الآن'),
                  ]),
                ),
            ],
          ),
        ),
      );
}

class _GuidanceCard extends StatelessWidget {
  const _GuidanceCard();
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget legend(CompatColor c) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(children: [
            Icon(Icons.circle, size: 14, color: compatColorValue(c, scheme)),
            const SizedBox(width: 8),
            Expanded(child: Text(c.arabicTitle, style: const TextStyle(fontSize: 13))),
          ]),
        );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('دليل النتائج', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            legend(CompatColor.green),
            legend(CompatColor.yellow),
            legend(CompatColor.red),
            legend(CompatColor.gray),
            const SizedBox(height: 8),
            Text(
              'النتيجة لا تعتمد على توفّر الواجهات البرمجية فقط، بل على تسجيل حقيقي نقيس صوته.',
              style: TextStyle(fontSize: 12, color: scheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
