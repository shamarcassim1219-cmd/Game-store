import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VaultCredentialsScreen extends StatefulWidget {
  const VaultCredentialsScreen({super.key});

  @override
  State<VaultCredentialsScreen> createState() => _VaultCredentialsScreenState();
}

class _VaultCredentialsScreenState extends State<VaultCredentialsScreen> {
  bool _showPassword = false;

  final String _email = "buyer_account@gmail.com";
  final String _password = "GamePass2026#Secure";
  final String _recoveryCode = "PUBG-2FA-992011";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Account Vault Credentials 🔐"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAlignment: CrossAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                border: Border.all(color: Colors.greenAccent),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock, color: Colors.greenAccent),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "These credentials are auto-decrypted for your order. Change password immediately after login.",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            _buildCredentialTile("Game Account Email / Login ID", _email, isObscured: false),
            const SizedBox(height: 15),

            // Password Tile with Toggle Reveal
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAlignment: CrossAlignment.start,
                    children: [
                      const Text("Password", style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 4),
                      Text(
                        _showPassword ? _password : "••••••••••••••••",
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, color: Colors.blueAccent),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _password));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Password copied!")),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            _buildCredentialTile("Recovery Codes / Linked Details", _recoveryCode, isObscured: false),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialTile(String label, String value, {required bool isObscured}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAlignment: CrossAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$label copied!")),
              );
            },
          ),
        ],
      ),
    );
  }
}
