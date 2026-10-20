class PracticeMessage {
  const PracticeMessage({
    required this.id,
    required this.channel,
    required this.sender,
    required this.subject,
    required this.body,
    required this.isScam,
    required this.explanation,
  });

  final String id;
  final String channel;
  final String sender;
  final String subject;
  final String body;
  final bool isScam;
  final String explanation;
}
