import '../features/email/email_messages.dart';
import '../features/text/text_messages.dart';
import '../models/practice_message.dart';

const practiceMessages = <PracticeMessage>[
  ...textMessages,
  ...emailMessages,
];
