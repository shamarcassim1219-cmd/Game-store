import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  final String myReferralCode = "MYGAME-9982";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Invite & Earn 🎁"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.card_giftcard, size: 80, color: Colors.purpleAccent),
            const SizedBox(height: 15),
            const Text(
              "Earn LKR 100 Per Invite!",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Invite your gamer friends to MYGame. When they buy their first account, LKR 100 is instantly added to your wallet!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
            const SizedBox(height: 30),

            // Referral Code Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAlignment: CrossAlignment.start,
                    children: [
                      const Text("YOUR REFERRAL CODE", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(myReferralCode, style: const TextStyle(color: Colors.purpleAccent, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: myReferralCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Referral code copied to clipboard!")),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Share Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                onPressed: () {
                  // Share via WhatsApp / Socials
                },
                icon: const Icon(Icons.share, color: Colors.white),
                label: const Text("SHARE WITH FRIENDS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 30),

            // Earnings Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat("Successful Invites", "12 Friends"),
                  Container(height: 30, width: 1, color: Colors.grey[800]),
                  _buildStat("Total Earned", "LKR 1,200.00"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
