import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/providers.dart';
import 'core/theme.dart';
import 'features/shell/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  runApp(const ProviderScope(child: CallRecorderApp()));
}

class CallRecorderApp extends ConsumerWidget {
  const CallRecorderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ensure the repository is alive from launch so call events are captured even before the user
    // opens the calls tab.
    ref.watch(callRepositoryProvider);
    return MaterialApp(
      title: 'مسجل المكالمات',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const HomeShell(),
    );
  }
}
