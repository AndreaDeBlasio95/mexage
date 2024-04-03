import 'package:flutter/material.dart';

class SecurityView extends StatelessWidget {
  TextStyle get appBarText => const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        color: Color(0xFF141F23),
      );

  TextStyle get titleText => const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: Color(0xFF141F23),
      );

  TextStyle get subtitleText => TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
    color: Colors.grey.shade800,
      );

  TextStyle get normalText => TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: Colors.grey.shade700,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security', style: appBarText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: titleText,
            ),
            const SizedBox(height: 16.0),
            // First
            Text(
              'Introduction',
              style: subtitleText,
            ),
            const SizedBox(height: 12.0),
            Text(
              'Welcome to SeaBottle. Your privacy is paramount to us, and we are committed to protecting the privacy and security of our users. '
                  'This Privacy Policy outlines how we collect, use, disclose, and safeguard your information when you engage with our mobile application. '
                  'Our practices are in full compliance with the General Data Protection Regulation (GDPR) and other relevant privacy laws.',
              style: normalText,
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 1.0,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8.0),
            // Second
            Text(
              'Data Collection and Use',
              style: subtitleText,
            ),
            const SizedBox(height: 12.0),
            Text(
              'Google Authentication: SeaBottle uses Google account authentication. By signing in, we collect your email (e.g., test@gmail.com) '
                  'and display name (e.g., Name Surname). This information is used to create your account, ensure application security, and provide '
                  'a personalized user experience. These details are visible only to the SeaBottle team and are securely stored in the Firebase '
                  'Firestore database.',
              style: normalText,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Anonymity in Messaging: Users are assigned a random username at registration to ensure anonymity. You can send up to two anonymous '
                  'messages per day, which are randomly assigned to users within the same country.',
              style: normalText,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Content Filtering: Messages are screened through ChatGPT to ensure a respectful communication environment, free from hate speech and '
                  'socially unethical content.',
              style: normalText,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Message Visibility and Trending: All messages can be accessed by the SeaBottle administrative team for compliance and monitoring '
                  'purposes. Messages may also be featured in the "Trending" section based on user interactions.',
              style: normalText,
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 1.0,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8.0),
            // Third
            Text(
              'Data Sharing and Disclosure',
              style: subtitleText,
            ),
            const SizedBox(height: 12.0),
            Text(
              'No Third-Party Sharing: Personal data collected through Google authentication or during app use is not shared with third parties, '
                  'except as necessary to provide the SeaBottle service or as mandated by law.',
              style: normalText,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Legal Compliance: We may disclose your information where required by law, to comply with a legal process, or to protect our rights or the safety of our users.',
              style: normalText,
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 1.0,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8.0),
            // Fourth
            Text(
              'Data Security',
              style: subtitleText,
            ),
            const SizedBox(height: 12.0),
            Text(
              'We employ robust security measures to protect your data from unauthorized access, alteration, disclosure, or destruction. Our '
                  'commitment to data security includes implementing suitable physical, electronic, and managerial procedures to safeguard the information we collect.',
              style: normalText,
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 1.0,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8.0),
            // Fifth
            Text(
              'Your Rights',
              style: subtitleText,
            ),
            const SizedBox(height: 12.0),
            Text(
              'You have rights under the GDPR, including the right to access, correct, delete, or limit the use of your personal data. If you wish to '
                  'exercise any of these rights, please contact us directly.',
              style: normalText,
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 1.0,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8.0),
            // Sixth
            Text(
              'Changes to This Privacy Policy',
              style: subtitleText,
            ),
            const SizedBox(height: 12.0),
            Text(
              'We may update our Privacy Policy to reflect changes to our information practices. We will notify you of any significant changes by posting'
                  ' the new policy on our app.',
              style: normalText,
            ),
            const SizedBox(height: 8.0),
            Container(
              height: 1.0,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8.0),
            // Seventh
            Text(
              'Contact Us',
              style: subtitleText,
            ),
            const SizedBox(height: 12.0),
            Text(
              'If you have any questions about this Privacy Policy, please contact us at seabottle@gmail.com.',
              style: normalText,
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
