import 'package:flutter/material.dart';
import 'login_register_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Logo & Welcome Text
              Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "MYGame 🎮",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Buy & Sell Verified Game Accounts Safely",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                ],
              ),

              // Gaming Illustration Placeholder
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.sports_esports,
                    size: 80,
                    color: Colors.blueAccent,
                  ),
                ),
              ),

              // Terms & Conditions Checkbox + Button
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _isAgreed,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          setState(() {
                            _isAgreed = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          "I agree to Terms & Conditions and Privacy Policy",
                          style: TextStyle(color: Colors.grey[300], fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAgreed ? Colors.blueAccent : Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isAgreed
                          ? () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginRegisterScreen(),
                                ),
                              );
                            }
                          : null,
                      child: const Text(
                        "GET STARTED",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
