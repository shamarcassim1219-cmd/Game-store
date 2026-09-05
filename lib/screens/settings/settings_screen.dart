import 'package:flutter/material.dart';
import 'verification_screen.dart';
import '../wallet/wallet_screen.dart';
import '../referral/referral_screen.dart';
import '../../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  bool _isBiometricEnabled = true;
  bool _isPushNotificationsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          "Settings & Profile ⚙️",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Info Tile
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 35, color: Colors.white),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAlignment: CrossAlignment.start,
                  children: [
                    const Text(
                      "Gamer Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "gamer@email.com",
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // MYGame Wallet Shortcut
          _buildSettingsTile(
            icon: Icons.account_balance_wallet,
            title: "MYGame Wallet",
            subtitle: "Balance, Top-Up & Bank Withdrawals",
            iconColor: Colors.greenAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            },
          ),
          const SizedBox(height: 10),

          // Seller Verification Option
          _buildSettingsTile(
            icon: Icons.verified,
            title: "Become a Verified Seller",
            subtitle: "Pay LKR 500 & Upload Documents for Blue Checkmark",
            iconColor: Colors.blueAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VerificationScreen()),
              );
            },
          ),
          const SizedBox(height: 10),

          // Invite & Earn (Referral)
          _buildSettingsTile(
            icon: Icons.card_giftcard,
            title: "Invite & Earn LKR 100",
            subtitle: "Share referral code with friends",
            iconColor: Colors.purpleAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReferralScreen()),
              );
            },
          ),
          const SizedBox(height: 25),

          const Text(
            "Security & Privacy 🔐",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Biometric Toggle Tile
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              secondary: const Icon(Icons.fingerprint, color: Colors.cyanAccent, size: 28),
              title: const Text("Biometric Lock (Fingerprint)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text("Require fingerprint on app launch", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              value: _isBiometricEnabled,
              activeColor: Colors.blueAccent,
              onChanged: (val) {
                setState(() {
                  _isBiometricEnabled = val;
                });
              },
            ),
          ),
          const SizedBox(height: 25),

          const Text(
            "App Preferences 🌐",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Push Notifications Toggle Tile
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_active, color: Colors.amberAccent, size: 28),
              title: const Text("Push Notifications", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text("Order updates, chat messages & offers", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              value: _isPushNotificationsEnabled,
              activeColor: Colors.blueAccent,
              onChanged: (val) {
                setState(() {
                  _isPushNotificationsEnabled = val;
                });
              },
            ),
          ),
          const SizedBox(height: 10),

          // Language Tile
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.tealAccent, size: 28),
              title: const Text("Language", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(_selectedLanguage, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onTap: () {
                _showLanguagePicker(context);
              },
            ),
          ),
          const SizedBox(height: 25),

          const Text(
            "Support & Legal 📄",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _buildSettingsTile(
            icon: Icons.gavel,
            title: "Escrow Rules & Terms of Service",
            subtitle: "3-Day hold, commission & dispute guidelines",
            iconColor: Colors.orangeAccent,
            onTap: () {},
          ),
          const SizedBox(height: 10),

          _buildSettingsTile(
            icon: Icons.privacy_tip,
            title: "Privacy Policy",
            subtitle: "Data protection & NIC verification safety",
            iconColor: Colors.blueGrey,
            onTap: () {},
          ),
          const SizedBox(height: 10),

          _buildSettingsTile(
            icon: Icons.logout,
            title: "Log Out",
            subtitle: "Sign out of your account",
            iconColor: Colors.redAccent,
            onTap: () async {
              await _authService.signOut();
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Select Language", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: const Text("English", style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => _selectedLanguage = 'English');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("සිංහල (Sinhala)", style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => _selectedLanguage = 'Sinhala');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("தமிழ் (Tamil)", style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => _selectedLanguage = 'Tamil');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
