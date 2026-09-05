import 'package:flutter/material.dart';
import '../../services/vault_offer_service.dart';
import '../../services/database_service.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _gameUidController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Vault Controllers (Encrypted Storage)
  final TextEditingController _vaultEmailController = TextEditingController();
  final TextEditingController _vaultPasswordController = TextEditingController();
  final TextEditingController _vaultRecoveryController = TextEditingController();

  String _selectedGame = 'PUBG Mobile';
  bool _allowOffers = true;
  bool _isVaultEnabled = true;
  bool _isLoading = false;

  final List<String> _games = ['PUBG Mobile', 'Free Fire', 'COD Mobile', 'MLBB'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          "Sell Game Account 🎮",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAlignment: CrossAlignment.start,
            children: [
              // 1. Select Game Category
              const Text("Game Category", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGame,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1E1E1E),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    items: _games.map((String game) {
                      return DropdownMenuItem<String>(
                        value: game,
                        child: Text(game),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedGame = newValue!;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2. Listing Title & Price
              _buildTextField(_titleController, "Listing Title", "e.g. PUBG Lv 72 Glacier M4 Max", Icons.title),
              const SizedBox(height: 16),
              _buildTextField(_priceController, "Selling Price (LKR)", "e.g. 25000", Icons.attach_money, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(_gameUidController, "In-Game Character UID", "e.g. 512093829", Icons.badge),

              const SizedBox(height: 16),

              // Description
              _buildTextField(_descriptionController, "Account Description & Outfits", "Mention skins, passes, levels, Kd ratio...", Icons.description, maxLines: 3),

              const SizedBox(height: 20),

              // 3. Image Upload Section Placeholder
              const Text("Account Screenshots 📸", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Select images from gallery...")),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, color: Colors.blueAccent, size: 30),
                      SizedBox(height: 6),
                      Text("Tap to upload account screenshots", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 4. Encrypted Vault Storage Option
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                ),
                child: Column(
                  crossAlignment: CrossAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lock, color: Colors.greenAccent),
                            SizedBox(width: 8),
                            Text("MYGame Account Vault 🔐", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        Switch(
                          value: _isVaultEnabled,
                          activeColor: Colors.greenAccent,
                          onChanged: (val) => setState(() => _isVaultEnabled = val),
                        ),
                      ],
                    ),
                    Text(
                      "Store login details securely. Buyer gets auto-access only after payment confirmation.",
                      style: TextStyle(color: Colors.grey[400], fontSize: 11),
                    ),
                    if (_isVaultEnabled) ...[
                      const SizedBox(height: 15),
                      _buildTextField(_vaultEmailController, "Game Account Email / ID", "account@gmail.com", Icons.email),
                      const SizedBox(height: 12),
                      _buildTextField(_vaultPasswordController, "Account Password", "••••••••", Icons.key, isObscure: true),
                      const SizedBox(height: 12),
                      _buildTextField(_vaultRecoveryController, "Recovery Codes / Phone Details", "Recovery info...", Icons.security),
                    ]
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Allow Bidding / Offers Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Allow Buyers to Make Offers (Bidding)", style: TextStyle(color: Colors.white, fontSize: 14)),
                value: _allowOffers,
                activeColor: Colors.orangeAccent,
                onChanged: (val) => setState(() => _allowOffers = val),
              ),

              const SizedBox(height: 25),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: _isLoading ? null : _submitListing,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("PUBLISH LISTING 🚀", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    bool isNumber = false,
    bool isObscure = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      obscureText: isObscure,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      validator: (val) => val == null || val.isEmpty ? "Please enter $label" : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: TextStyle(color: Colors.grey[700], fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  void _submitListing() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate Firebase DB saving
      await Future.delayed(const Duration(seconds: 2));

      if (_isVaultEnabled) {
        final VaultOfferService vaultService = VaultOfferService();
        await vaultService.saveVaultCredentials(
          listingId: "NEW_GENERATED_ID",
          email: _vaultEmailController.text.trim(),
          password: _vaultPasswordController.text.trim(),
          recoveryInfo: _vaultRecoveryController.text.trim(),
        );
      }

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Game Account Listed Successfully!")),
        );
        Navigator.pop(context);
      }
    }
  }
}
