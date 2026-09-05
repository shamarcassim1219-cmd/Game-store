import 'package:flutter/material.dart';
import 'verification_screen.dart';
import '../wallet/wallet_screen.dart';
import '../../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

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
                  crossAxisAlignment: CrossAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text(
                          "Gamer Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
            subtitle: "Balance: LKR 0.00",
            iconColor: Colors.greenAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            },
          ),
          const SizedBox(height: 10),

          // Seller Verification Option (Blue Tick Badge Application)
          _buildSettingsTile(
            icon: Icons.verified,
            title: "Become a Verified Seller",
            subtitle: "Pay LKR 500 & Upload Documents to Sell Accounts",
            iconColor: Colors.blueAccent,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VerificationScreen()),
              );
            },
          ),
          const SizedBox(height: 20),

          const Text(
            "Account & App",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          _buildSettingsTile(
            icon: Icons.history,
            title: "My Listings & Orders",
            subtitle: "View your active posts and 3-Day Escrow purchases",
            iconColor: Colors.orangeAccent,
            onTap: () {},
          ),
          const SizedBox(height: 10),

          _buildSettingsTile(
            icon: Icons.help_outline,
            title: "Help & Support",
            subtitle: "Report Fraud or Contact MYGame Admin",
            iconColor: Colors.purpleAccent,
            onTap: () {},
          ),
          const SizedBox(height: 10),

          _buildSettingsTile(
            icon: Icons.logout,
            title: "Log Out",
            subtitle: "Sign out of your account",
            iconColor: Colors.redAccent,
            onTap: () async {
              await authService.signOut();
            },
          ),
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
}
