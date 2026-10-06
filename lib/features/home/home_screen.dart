import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../platform/native_models.dart';
import '../permissions/permissions_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(deviceInfoProvider);
    final auto = ref.watch(autoRecordProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('مسجل المكالمات')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(deviceInfoProvider);
          ref.invalidate(autoRecordProvider);
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            _IntroCard(),
            info.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => _ErrorCard(message: '$e'),
              data: (d) => _CompatSummary(info: d),
            ),
            const PermissionsCard(),
            auto.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (enabled) => Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.fiber_manual_record),
                  title: const Text('التسجيل التلقائي للمكالمات'),
                  subtitle: Text(enabled
                      ? 'سيتم تسجيل المكالمات تلقائياً عند بدئها'
                      : 'التسجيل التلقائي متوقف'),
                  value: enabled,
                  onChanged: (v) async {
                    await ref.read(platformProvider).setAutoRecord(v);
                    ref.invalidate(autoRecordProvider);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'ملاحظة: تسجيل الطرفين في المكالمات الخلوية يحتاج صلاحية مستوى النظام '
                '(Shizuku). بدونها يسجّل التطبيق الميكروفون غالباً — أي طرفاً واحداً فقط. '
                'شغّل اختبار التوافق لمعرفة قدرة جهازك الحقيقية.',
                style: TextStyle(color: scheme.outline, fontSize: 12.5, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('قبل أن تبدأ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Text(
              'قبل استخدام التطبيق، لازم نختبر توافق جهازك مع تسجيل المكالمات. '
              'افتح تبويب «التوافق» وشغّل الاختبار بمكالمة حقيقية.',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompatSummary extends StatelessWidget {
  const _CompatSummary({required this.info});
  final DeviceInfoData info;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = info.savedColor ?? CompatColor.gray;
    return Card(
      child: ListTile(
        leading: Icon(Icons.circle, color: compatColorValue(color, scheme)),
        title: Text(color.arabicTitle),
        subtitle: Text('${info.manufacturer} ${info.model} • أندرويد ${info.androidRelease}'),
        trailing: info.savedColor == null
            ? const Chip(label: Text('لم يُختبر'))
            : null,
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: ListTile(
        leading: const Icon(Icons.error_outline),
        title: const Text('تعذّر قراءة معلومات الجهاز'),
        subtitle: Text(message),
      ),
    );
  }
}
