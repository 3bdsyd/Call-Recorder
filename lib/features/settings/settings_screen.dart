import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/enums.dart';
import '../../core/providers.dart';
import '../diagnostics/diagnostics_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  RecordingStrategy? _preferred;
  bool _loadedPref = false;

  @override
  Widget build(BuildContext context) {
    final auto = ref.watch(autoRecordProvider);
    final info = ref.watch(deviceInfoProvider);
    if (!_loadedPref) {
      ref.read(platformProvider).getPreferredStrategy().then((v) {
        if (mounted) setState(() { _preferred = v; _loadedPref = true; });
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          auto.when(
            loading: () => const ListTile(title: Text('...')),
            error: (_, _) => const SizedBox.shrink(),
            data: (enabled) => SwitchListTile(
              secondary: const Icon(Icons.fiber_manual_record),
              title: const Text('التسجيل التلقائي'),
              subtitle: const Text('تسجيل كل مكالمة تلقائياً عند بدئها'),
              value: enabled,
              onChanged: (v) async {
                await ref.read(platformProvider).setAutoRecord(v);
                ref.invalidate(autoRecordProvider);
              },
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text('طريقة التسجيل المفضّلة', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          info.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (d) {
              final options = <RecordingStrategy?>[null, ...d.availableStrategies];
              return RadioGroup<RecordingStrategy?>(
                groupValue: _preferred,
                onChanged: (v) async {
                  await ref.read(platformProvider).setPreferredStrategy(v);
                  if (mounted) setState(() => _preferred = v);
                },
                child: Column(
                  children: options.map((s) {
                    return RadioListTile<RecordingStrategy?>(
                      value: s,
                      title: Text(s?.arabic ?? 'تلقائي (الأفضل المتاح)'),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.battery_saver),
            title: const Text('استثناء من توفير البطارية'),
            subtitle: const Text('يحسّن موثوقية التسجيل في الخلفية'),
            onTap: () => Permission.ignoreBatteryOptimizations.request(),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('إذن Shizuku'),
            subtitle: const Text('مطلوب لتسجيل الطرفين'),
            onTap: () async {
              final ok = await ref.read(platformProvider).requestShizukuPermission();
              ref.invalidate(deviceInfoProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ok ? 'تم منح الإذن' : 'Shizuku غير متاح أو لم يُمنح')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('سجل التشخيص'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DiagnosticsScreen()),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'إخلاء مسؤولية: تسجيل المكالمات قد يكون مقيّداً قانونياً في بعض الدول ويتطلب '
              'موافقة الطرف الآخر. هذا التطبيق للاختبار على أجهزة يملكها المستخدم. '
              'لا تُرفع التسجيلات إلى أي خادم في المرحلة الأولى.',
              style: TextStyle(fontSize: 12, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
