import '../../models/practice_message.dart';

const emailMessages = <PracticeMessage>[
  PracticeMessage(
    id: 'parcel',
    channel: 'Email',
    sender: 'Delivery Team <alerts@parcel-update.example>',
    subject: 'Action required: missed delivery',
    body:
        'We could not deliver your parcel. Pay a \$1.95 rescheduling fee within 30 minutes to avoid return to sender.',
    isScam: true,
    explanation:
        'The urgent deadline, unexpected fee, and unfamiliar sender domain are warning signs. Check delivery status in the carrier’s official app.',
  ),
  PracticeMessage(
    id: 'appointment',
    channel: 'Email',
    sender: 'Community Center <hello@community-center.example>',
    subject: 'Reminder: workshop tomorrow',
    body:
        'Thanks for registering for the safety workshop. It begins tomorrow at 10 AM. Bring your registration confirmation to the front desk.',
    isScam: false,
    explanation:
        'This is a routine reminder without a payment or secret-code request. You can confirm it using your original registration if needed.',
  ),
];
