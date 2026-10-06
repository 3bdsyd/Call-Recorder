import 'ai_models.dart';

/// Phase 2 — speech-to-text. Arabic-first, must tolerate Arabic+English code-switching.
///
/// Deliberately vendor-agnostic: a concrete implementation (on-device model or a secure backend)
/// is added in Phase 2. API keys must NEVER be embedded in the APK — cloud calls go through a
/// backend the app authenticates to.
abstract class SpeechToTextService {
  Future<Transcript> transcribe({
    required String audioFilePath,
    String languageHint = 'ar',
  });
}

/// Phase 2 — structured analysis/summarisation over a transcript.
abstract class CallAnalysisService {
  Future<CallAnalysis> analyze({
    required Transcript transcript,
    String languageHint = 'ar',
  });

  /// "Ask AI about this call" — free-form Q&A grounded in the transcript.
  Future<String> ask({
    required Transcript transcript,
    required String question,
  });
}

/// Placeholder that makes the Phase-1 app honest: the feature exists in the architecture but is not
/// implemented yet, and says so rather than returning fake data.
class UnavailableSpeechToTextService implements SpeechToTextService {
  @override
  Future<Transcript> transcribe({required String audioFilePath, String languageHint = 'ar'}) =>
      throw UnimplementedError('التفريغ النصي يُضاف في المرحلة الثانية');
}

class UnavailableCallAnalysisService implements CallAnalysisService {
  @override
  Future<CallAnalysis> analyze({required Transcript transcript, String languageHint = 'ar'}) =>
      throw UnimplementedError('التحليل بالذكاء الاصطناعي يُضاف في المرحلة الثانية');

  @override
  Future<String> ask({required Transcript transcript, required String question}) =>
      throw UnimplementedError('ميزة السؤال عن المكالمة تُضاف في المرحلة الثانية');
}
