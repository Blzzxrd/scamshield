import '../../models/practice_message.dart';

const textMessages = <PracticeMessage>[
  PracticeMessage(
    id: 'library',
    channel: 'Text',
    sender: 'Town Library',
    subject: 'Your hold is ready',
    body:
        'The book you requested is ready for pickup at the front desk. We will hold it through Friday. No action is needed.',
    isScam: false,
    explanation:
        'This message matches a request you made and asks for no payment, code, or link click. If unsure, call the library using its public number.',
  ),
  PracticeMessage(
    id: 'bank',
    channel: 'Text',
    sender: '+1 (555) 010-0198',
    subject: 'Account alert',
    body:
        'Your card is locked! Reply with the six-digit code we just sent to restore access immediately.',
    isScam: true,
    explanation:
        'Never share a one-time code. Open your bank’s official app or call the number on your card to check the account.',
  ),
];
