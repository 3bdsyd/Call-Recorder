import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// Requests and reports the runtime permissions Phase 1 needs. Call-log access is requested as part
/// of the phone permission; when the OS withholds it, number resolution simply degrades to null.
class PermissionsCard extends ConsumerStatefulWidget {
  const PermissionsCard({super.key});

  @override
  ConsumerState<PermissionsCard> createState() => _PermissionsCardState();
}

class _PermissionsCardState extends ConsumerState<PermissionsCard> {
  final _required = const [
    (Permission.microphone, 'الميكروفون', 'لتسجيل صوت المكالمة'),
    (Permission.phone, 'الهاتف وسجل المكالمات', 'لاكتشاف المكالمات ومعرفة الرقم'),
    (Permission.contacts, 'جهات الاتصال', 'لعرض اسم المتصل'),
    (Permission.notification, 'الإشعارات', 'لإظهار إشعار أثناء التسجيل'),
  ];

  Map<Permission, PermissionStatus> _statuses = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final map = <Permission, PermissionStatus>{};
    for (final p in _required) {
      map[p.$1] = await p.$1.status;
    }
    if (mounted) setState(() { _statuses = map; _loading = false; });
  }

  Future<void> _requestAll() async {
    await [for (final p in _required) p.$1].request();
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final granted = _statuses.values.where((s) => s.isGranted).length;
    final total = _required.length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified_user_outlined),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('الأذونات المطلوبة', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                if (!_loading) Text('$granted / $total'),
              ],
            ),
            const SizedBox(height: 8),
            if (_loading)
              const Padding(padding: EdgeInsets.all(8), child: LinearProgressIndicator())
            else
              ..._required.map((p) {
                final s = _statuses[p.$1];
                final ok = s?.isGranted ?? false;
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: ok ? const Color(0xFF2E7D32) : Theme.of(context).colorScheme.outline),
                  title: Text(p.$2),
                  subtitle: Text(p.$3),
                );
              }),
            const SizedBox(height: 4),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Wrap(
                spacing: 8,
                children: [
                  FilledButton.tonal(onPressed: _requestAll, child: const Text('منح الأذونات')),
                  TextButton(onPressed: openAppSettings, child: const Text('فتح الإعدادات')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
