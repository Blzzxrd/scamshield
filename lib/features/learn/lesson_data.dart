class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.answers,
    required this.correctIndex,
    required this.explanation,
  });

  final String prompt;
  final List<String> answers;
  final int correctIndex;
  final String explanation;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.eyebrow,
    required this.description,
    required this.example,
    required this.questions,
  });

  final String id;
  final String title;
  final String eyebrow;
  final String description;
  final String example;
  final List<QuizQuestion> questions;
}

const lessons = <Lesson>[
  Lesson(
    id: 'basics',
    title: 'Spot the warning signs',
    eyebrow: 'LESSON 01 · 3 MIN',
    description:
        'Scammers often create urgency so you act before you think. Pause, check who contacted you, and use a trusted way to verify their story.',
    example:
        '“Your account will close in 10 minutes. Send the one-time code now.” A real support agent should not ask you to share that code.',
    questions: [
      QuizQuestion(
        prompt:
            'A message says you must act in 10 minutes. What should you do first?',
        answers: [
          'Tap its link',
          'Pause and verify independently',
          'Reply with your password',
        ],
        correctIndex: 1,
        explanation:
            'Urgency is a common tactic. Use an official app or a number you already trust.',
      ),
      QuizQuestion(
        prompt:
            'Someone claiming to be support asks for your one-time login code. Is that safe?',
        answers: [
          'Yes, if they sound professional',
          'Only by text',
          'No, never share the code',
        ],
        correctIndex: 2,
        explanation:
            'One-time codes protect your account. A caller can use them to sign in as you.',
      ),
      QuizQuestion(
        prompt: 'Which clue deserves a closer look?',
        answers: [
          'A request for gift cards',
          'A familiar company logo',
          'A polite greeting',
        ],
        correctIndex: 0,
        explanation:
            'Gift cards and unusual payment methods are strong warning signs.',
      ),
    ],
  ),
  Lesson(
    id: 'phishing',
    title: 'Read an email like a detective',
    eyebrow: 'LESSON 02 · 4 MIN',
    description:
        'A phishing email may copy a brand, but its sender address, link, or request can reveal the trick. Check the details before you click.',
    example:
        '“Delivery failed. Pay \$1.95 at parcel-help.example to reschedule.” If you did not expect a package, check the carrier directly.',
    questions: [
      QuizQuestion(
        prompt:
            'A delivery email asks for a small fee. What is the safest check?',
        answers: [
          'Open the email link',
          'Use the carrier’s official app',
          'Send card details by reply',
        ],
        correctIndex: 1,
        explanation:
            'Open a trusted app or type the known address yourself. Do not rely on the message link.',
      ),
      QuizQuestion(
        prompt: 'Which detail can expose an impersonator?',
        answers: ['Sender address', 'Brand colors', 'A large logo'],
        correctIndex: 0,
        explanation:
            'A familiar design is easy to copy. Inspect the actual sender address.',
      ),
      QuizQuestion(
        prompt:
            'The email asks you to download an unexpected invoice. What now?',
        answers: [
          'Open it immediately',
          'Forward it to friends',
          'Verify with the sender another way',
        ],
        correctIndex: 2,
        explanation:
            'Unexpected attachments can be harmful. Contact the sender through a known channel.',
      ),
    ],
  ),
];
