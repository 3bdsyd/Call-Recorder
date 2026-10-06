import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../../core/format.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import 'call_details_screen.dart';

class CallsScreen extends ConsumerWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calls = ref.watch(callsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('سجل المكالمات')),
      body: calls.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const _Empty();
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) => _CallTile(call: list[i]),
          );
        },
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.call_missed_outgoing, size: 48, color: scheme.outline),
          const SizedBox(height: 12),
          const Text('لا توجد مكالمات مسجّلة بعد'),
          const SizedBox(height: 4),
          Text('ستظهر المكالمات هنا بعد تسجيلها',
              style: TextStyle(color: scheme.outline, fontSize: 12)),
        ],
      ),
    );
  }
}

class _CallTile extends StatelessWidget {
  const _CallTile({required this.call});
  final Call call;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final direction = CallDirection.fromWire(call.direction);
    final status = RecordingStatus.fromWire(call.recordingStatus);
    final badge = statusBadge(status, scheme);
    final title = (call.contactName?.isNotEmpty ?? false)
        ? call.contactName!
        : (call.phoneNumber?.isNotEmpty ?? false ? call.phoneNumber! : 'رقم غير محفوظ');

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.surfaceContainerHighest,
        child: Icon(
          direction == CallDirection.incoming ? Icons.call_received : Icons.call_made,
          color: direction == CallDirection.incoming ? const Color(0xFF2E7D32) : scheme.primary,
          size: 20,
        ),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${direction.arabic} • ${Fmt.relativeDateTime(call.startedAt)}',
              style: const TextStyle(fontSize: 12)),
          Row(
            children: [
              Icon(badge.icon, size: 14, color: badge.color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(badge.label,
                    style: TextStyle(fontSize: 12, color: badge.color),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
      trailing: Text(Fmt.duration(call.durationMs), style: const TextStyle(fontSize: 12)),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CallDetailsScreen(callId: call.id)),
      ),
    );
  }
}
