/// Phase 2 data shapes. Defined now so the DB/UI can evolve toward them, but no provider is wired
/// and no network call is made in Phase 1.
library;

/// A single transcript segment, optionally speaker-labelled.
class TranscriptSegment {
  const TranscriptSegment({
    required this.startMs,
    required this.endMs,
    required this.text,
    this.speaker,
  });
  final int startMs;
  final int endMs;
  final String text;
  final String? speaker; // e.g. "A" / "B" / contact name
}

class Transcript {
  const Transcript({required this.language, required this.segments});
  final String language; // "ar", "ar-en", ...
  final List<TranscriptSegment> segments;

  String get fullText => segments.map((s) => s.text).join(' ');
}

/// Structured analysis of a call, matching the Phase 2 schema in the spec.
class CallAnalysis {
  const CallAnalysis({
    required this.summary,
    this.keyPoints = const [],
    this.actionItems = const [],
    this.decisions = const [],
    this.followUps = const [],
    this.people = const [],
    this.dates = const [],
    this.amounts = const [],
    this.topics = const [],
    this.sentiment = '',
  });

  final String summary;
  final List<String> keyPoints;
  final List<String> actionItems;
  final List<String> decisions;
  final List<String> followUps;
  final List<String> people;
  final List<String> dates;
  final List<String> amounts;
  final List<String> topics;
  final String sentiment;
}
