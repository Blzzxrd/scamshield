import json
import os

# Collection of practice messages (scam and safe scenarios)
messages = [
  {
    "id": "streaming_suspension",
    "channel": "Email",
    "sender": "StreamFlix Support <billing@streamflix-update.example>",
    "subject": "Account suspended: update payment",
    "body": "Your membership has been paused due to a billing error. Update your credit card details immediately to avoid cancellation.",
    "isScam": True,
    "explanation": "Generic greetings, urgent threats of cancellation, and suspicious domain names are common phishing signs."
  },
  {
    "id": "school_club",
    "channel": "Text",
    "sender": "Chess Club Leader",
    "subject": "Meeting room change",
    "body": "Hey everyone! Room 204 is locked today, so we are meeting in the library conference room after school. See you there!",
    "isScam": False,
    "explanation": "A casual, expected message from a peer with no links, money requests, or pressure."
  },
  {
    "id": "crypto_giveaway",
    "channel": "Email",
    "sender": "CryptoMoon <giveaway@moon-rewards.example>",
    "subject": "You won 2 BTC!",
    "body": "Congratulations! You have been selected for our community airdrop. Send 0.1 BTC to verify your wallet and claim your prize.",
    "isScam": True,
    "explanation": "Classic advance-fee scam. If something sounds too good to be True and requires you to send money first, it is a scam."
  },
  {
    "id": "friend_concert",
    "channel": "Text",
    "sender": "Maya",
    "subject": "Tickets",
    "body": "Are you still down for the indie concert next Friday? Let me know so I can buy our digital passes!",
    "isScam": False,
    "explanation": "Normal conversation from a friend you know, asking about shared plans without asking for personal codes or passwords."
  },
  {
    "id": "tax_refund",
    "channel": "Email",
    "sender": "Government Tax Office <noreply@tax-refund-gov.example>",
    "subject": "Your tax refund is ready",
    "body": "You are owed a refund of $450. Click the secure link below and enter your bank routing number to deposit it now.",
    "isScam": True,
    "explanation": "Government agencies rarely text or email unexpected money links requiring immediate banking details."
  },
  {
    "id": "game_store",
    "channel": "Email",
    "sender": "PlayVerse Store <receipts@playverse-official.example>",
    "subject": "Receipt for your purchase",
    "body": "Thank you for purchasing 'Pixel Quest'. Your digital key is: PQ-8832-9911. View your library anytime in the app.",
    "isScam": False,
    "explanation": "A standard purchase confirmation matching an action you took, with no malicious links or pressure."
  },
  {
    "id": "instagram_verify",
    "channel": "Text",
    "sender": "+1 (800) 555-0192",
    "subject": "Security alert",
    "body": "Someone tried to log into your social media account from Russia. Reply 'STOP' or click here to secure your profile.",
    "isScam": True,
    "explanation": "Unsolicited security alerts with unverified links are often used to steal login credentials."
  },
  {
    "id": "doctor_appointment",
    "channel": "Text",
    "sender": "City Medical Clinic",
    "subject": "Appointment reminder",
    "body": "Reminder: You have a check-up tomorrow at 3:15 PM. Reply C to confirm or call 555-0144 to reschedule.",
    "isScam": False,
    "explanation": "A standard medical reminder with a public phone number to verify rather than a sketchy link."
  },
  {
    "id": "job_offer",
    "channel": "Email",
    "sender": "Recruiting Team <hr@remote-job-opportunity.example>",
    "subject": "Work from home offer - $35/hr",
    "body": "We reviewed your resume and want to hire you instantly as a data entry specialist. Reply with your full name, address, and SSN to start.",
    "isScam": True,
    "explanation": "Real employers do not hire without interviews, nor do they ask for sensitive info like your SSN over casual email."
  },
  {
    "id": "family_grocery",
    "channel": "Text",
    "sender": "Mom",
    "subject": "Groceries",
    "body": "Can you pick up a gallon of milk and some bread on your way home from practice? Love you!",
    "isScam": False,
    "explanation": "A typical message from a family member with no suspicious requests."
  },
  {
    "id": "free_giftcard",
    "channel": "Email",
    "sender": "SurveyRewards <rewards@opinion-poll-win.example>",
    "subject": "Claim your $100 gift card!",
    "body": "You've been chosen to receive a $100 store gift card. Just pay $1.99 shipping and handling to claim it!",
    "isScam": True,
    "explanation": "Small shipping fees for 'free' gift cards are a trap to steal credit card numbers."
  },
  {
    "id": "bank_fraud_alert",
    "channel": "Text",
    "sender": "SecureBank Fraud Dept",
    "subject": "Suspicious charge",
    "body": "Did you spend $499.99 at Electronics Depot? If NOT, reply with your mobile banking password immediately to cancel it.",
    "isScam": True,
    "explanation": "Banks will never ask for your password or PIN via text message."
  },
  {
    "id": "mobile_carrier",
    "channel": "Text",
    "sender": "Metro Wireless",
    "subject": "Bill ready",
    "body": "Your auto-pay for this month's bill was successful. Thank you for being a customer. Log into the app to view details.",
    "isScam": False,
    "explanation": "A standard informational notification directing you to log into the official app safely."
  },
  {
    "id": "apple_id_lock",
    "channel": "Email",
    "sender": "Apple Support <support@apple-id-security-check.example>",
    "subject": "Your Apple ID has been locked",
    "body": "Due to multiple incorrect login attempts, your Apple ID is locked. Verify your identity within 24 hours at apple-id-secure.example.",
    "isScam": True,
    "explanation": "The fake domain name and urgent countdown timer indicate a phishing attempt to steal Apple credentials."
  },
  {
    "id": "study_group",
    "channel": "Text",
    "sender": "Jordan (Classmate)",
    "subject": "History notes",
    "body": "Hey! Did you get the notes from yesterday's lecture? I missed class because I was sick.",
    "isScam": False,
    "explanation": "An ordinary request from a classmate with no security risks."
  },
  {
    "id": "lottery_winner",
    "channel": "Email",
    "sender": "International Sweepstakes <winner@global-prizes.example>",
    "subject": "Claim Notification",
    "body": "You won $1,000,000 in our international email lottery. Contact our claims agent via WhatsApp to receive your funds.",
    "isScam": True,
    "explanation": "You cannot win a lottery you never entered. Moving conversations to WhatsApp is a major red flag."
  },
  {
    "id": "package_delivery_real",
    "channel": "Text",
    "sender": "USPS Tracking",
    "subject": "Out for delivery",
    "body": "Your package with tracking #9400 is out for delivery today by 5 PM. Track it in the official carrier app.",
    "isScam": False,
    "explanation": "A general tracking notice that directs you to official channels rather than asking for payment or codes."
  },
  {
    "id": "tech_support_popup",
    "channel": "Email",
    "sender": "Microsoft Security <alert@windows-tech-fix.example>",
    "subject": "Critical Virus Detected!",
    "body": "Your computer is infected with 14 trojans! Call our toll-free support line immediately at 1-800-555-0199 to clean your system.",
    "isScam": True,
    "explanation": "Scare tactics trying to trick you into calling a fake tech support line to steal remote access or money."
  },
  {
    "id": "club_meeting",
    "channel": "Email",
    "sender": "School Robotics Club",
    "subject": "Saturday workshop reminder",
    "body": "Reminder that our weekend build session is this Saturday from 10 AM to 2 PM in the STEM lab. Pizza will be provided.",
    "isScam": False,
    "explanation": "A legitimate school communication from a known address with clear, safe details."
  },
  {
    "id": "friend_money_emergency",
    "channel": "Text",
    "sender": "Alex (Friend)",
    "subject": "Emergency",
    "body": "Hey, I'm stuck in a bad situation and my card isn't working. Can you Venmo me $50 right now? I'll pay you back tomorrow!",
    "isScam": True,
    "explanation": "Account takeovers often result in messages like this asking friends for money. Always verify by calling them directly."
  }
]
def split_messages_to_files(output_dir="assets/practice_messages"):
    # Ensure the output directory exists
    os.makedirs(output_dir, exist_ok=True)
    
    count = 0
    for msg in messages:
        file_path = os.path.join(output_dir, f"{msg['id']}.json")
        with open(file_path, "w", encoding="utf-8") as f:
            json.dump(msg, f, indent=2)
        count += 1
        
    print(f"Successfully saved {count} practice message files into '{output_dir}/'.")

if __name__ == "__main__":
    split_messages_to_files()
