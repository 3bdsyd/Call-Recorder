import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../platform/native_models.dart';

/// Developer-facing live log of the native recording layer. Shows the structured events
/// (CALL_STARTED, RECORDING_ENGINE_SELECTED, RECORDING_STARTED, FILE_VALIDATED, …) as they happen.
class DiagnosticsScreen extends ConsumerStatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  ConsumerState<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends ConsumerState<DiagnosticsScreen> {
  final List<NativeLogEvent> _logs = [];

  @override
  Widget build(BuildContext context) {
    ref.listen(nativeLogProvider, (prev, next) {
      next.whenData((e) {
        setState(() {
          _logs.insert(0, e);
          if (_logs.length > 300) _logs.removeLast();
        });
      });
    });
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل التشخيص'),
        actions: [
          IconButton(
            tooltip: 'حالة النظام الآن',
            icon: const Icon(Icons.info_outline),
            onPressed: () async {
              final diag = await ref.read(platformProvider).getNativeDiagnostics();
              if (!context.mounted) return;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('حالة النظام'),
                  content: SingleChildScrollView(
                    child: Text(const JsonEncoder.withIndent('  ').convert(_jsonSafe(diag))),
                  ),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسناً'))],
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'مسح',
            icon: const Icon(Icons.clear_all),
            onPressed: () => setState(_logs.clear),
          ),
        ],
      ),
      body: _logs.isEmpty
          ? Center(child: Text('لا توجد سجلات بعد', style: TextStyle(color: scheme.outline)))
          : ListView.separated(
              itemCount: _logs.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final e = _logs[i];
                final color = switch (e.level) {
                  'error' => scheme.error,
                  'warn' => const Color(0xFFE6A700),
                  _ => scheme.onSurface,
                };
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.circle, size: 10, color: color),
                  title: Text(e.event, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: Text(
                    const JsonEncoder().convert(_jsonSafe(Map.of(e.raw)..remove('event')..remove('level')..remove('ts'))),
                    style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                  ),
                );
              },
            ),
    );
  }

  /// Make an arbitrary platform map JSON-encodable (keys to String).
  dynamic _jsonSafe(dynamic v) {
    if (v is Map) {
      return v.map((k, val) => MapEntry(k.toString(), _jsonSafe(val)));
    }
    if (v is List) return v.map(_jsonSafe).toList();
    return v;
  }
}
