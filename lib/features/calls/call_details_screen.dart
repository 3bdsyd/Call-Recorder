import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../../core/format.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../recordings/player_screen.dart';

class CallDetailsScreen extends ConsumerStatefulWidget {
  const CallDetailsScreen({super.key, required this.callId});
  final String callId;

  @override
  ConsumerState<CallDetailsScreen> createState() => _CallDetailsScreenState();
}

class _CallDetailsScreenState extends ConsumerState<CallDetailsScreen> {
  Call? _call;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await ref.read(callRepositoryProvider).callById(widget.callId);
    if (mounted) setState(() { _call = c; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المكالمة')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _call == null
              ? const Center(child: Text('المكالمة غير موجودة'))
              : _body(context, _call!, scheme),
    );
  }

  Widget _body(BuildContext context, Call call, ColorScheme scheme) {
    final direction = CallDirection.fromWire(call.direction);
    final status = RecordingStatus.fromWire(call.recordingStatus);
    final strategy = RecordingStrategy.fromWire(call.recordingStrategy);
    final badge = statusBadge(status, scheme);
    final notes = call.notes == null ? const [] : (jsonDecode(call.notes!) as List);
    final hasFile = (call.recordingPath?.isNotEmpty ?? false);

    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (call.contactName?.isNotEmpty ?? false)
                      ? call.contactName!
                      : (call.phoneNumber ?? 'رقم غير محفوظ'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (call.contactName?.isNotEmpty ?? false)
                  Text(call.phoneNumber ?? '', style: TextStyle(color: scheme.outline)),
                const SizedBox(height: 8),
                Text('${direction.arabic} • ${Fmt.fullDateTime(call.startedAt)}'),
                Text('المدة: ${Fmt.duration(call.durationMs)}'),
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(badge.icon, color: badge.color),
            title: Text(badge.label, style: TextStyle(color: badge.color)),
            subtitle: Text('طريقة التسجيل: ${strategy.arabic}'),
          ),
        ),
        if (hasFile)
          Card(
            child: ListTile(
              leading: const Icon(Icons.play_circle_fill, size: 36),
              title: const Text('تشغيل التسجيل'),
              subtitle: Text(Fmt.fileSize(call.fileSizeBytes)),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PlayerScreen(path: call.recordingPath!, title: call.contactName ?? call.phoneNumber ?? 'التسجيل'),
              )),
            ),
          ),
        _DiagnosticsCard(call: call, notes: notes),
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            onPressed: () async {
              await ref.read(callRepositoryProvider).deleteCall(call.id);
              if (context.mounted) Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('حذف المكالمة'),
          ),
        ),
      ],
    );
  }
}

class _DiagnosticsCard extends StatelessWidget {
  const _DiagnosticsCard({required this.call, required this.notes});
  final Call call;
  final List<dynamic> notes;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget row(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              SizedBox(width: 140, child: Text(k, style: TextStyle(color: scheme.outline, fontSize: 13))),
              Expanded(child: Text(v, style: const TextStyle(fontSize: 13))),
            ],
          ),
        );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('التشخيص الفني', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            row('القنوات', call.channelCount == 0 ? '—' : '${call.channelCount}'),
            row('معدل العينات', call.sampleRate == 0 ? '—' : '${call.sampleRate} Hz'),
            row('طاقة القناة اليسرى', call.leftEnergy.toStringAsFixed(4)),
            row('طاقة القناة اليمنى', call.rightEnergy.toStringAsFixed(4)),
            row('نسبة الصمت', '${(call.silenceRatio * 100).toStringAsFixed(0)}%'),
            row('الطرفان مُكتشفان', call.bothSidesDetected ? 'نعم' : 'لا'),
            row('مصدر الصوت', call.audioSourceUsed ?? '—'),
            row('حجم الملف', Fmt.fileSize(call.fileSizeBytes)),
            if (call.errorReason != null) row('سبب الخطأ', call.errorReason!),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 6),
              ...notes.map((n) => Text('• $n', style: TextStyle(fontSize: 12, color: scheme.outline))),
            ],
          ],
        ),
      ),
    );
  }
}
