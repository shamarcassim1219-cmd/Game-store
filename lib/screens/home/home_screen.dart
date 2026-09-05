import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/listing_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _dbService = DatabaseService();
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['All', 'PUBG Mobile', 'Free Fire', 'COD Mobile', 'MLBB'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          "MYGame 🎮",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search PUBG, Free Fire accounts...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                suffixIcon: const Icon(Icons.tune, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 2. Game Categories Filter (Horizontal Scroll)
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.blueAccent,
                    backgroundColor: const Color(0xFF1E1E1E),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          // 3. Listings Stream from Firestore
          Expanded(
            child: StreamBuilder<List<ListingModel>>(
              stream: _dbService.getListings(
                gameType: _selectedCategory == 'All' ? null : _selectedCategory,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No account listings found.",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  );
                }

                final listings = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final item = listings[index];
                    return _buildAccountCard(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Account Card Widget with Verified Blue Checkmark
  Widget _buildAccountCard(ListingModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[850]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          // Image Placeholder / Carousel
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 160,
              width: double.infinity,
              color: Colors.grey[900],
              child: item.imageUrls.isNotEmpty
                  ? Image.network(item.imageUrls.first, fit: BoxFit.cover)
                  : const Center(
                      child: Icon(Icons.sports_esports, size: 60, color: Colors.blueAccent),
                    ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAlignment.start,
              children: [
                // Title & Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "LKR ${item.price.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Seller Name with Verified Blue Checkmark Badge [✔]
                Row(
                  children: [
                    Text(
                      "Seller: ${item.sellerName}",
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    const SizedBox(width: 4),
                    if (item.isSellerVerified)
                      const Icon(
                        Icons.verified, // Standard Verified Blue Badge
                        color: Colors.blueAccent,
                        size: 16,
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blueAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {},
                        child: const Text("💬 Chat", style: TextStyle(color: Colors.blueAccent)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          // 15% Platform Commission Checkout Modal එක පෙන්නීම
                          _showCheckoutSummary(context, item.price, item);
                        },
                        child: const Text("🛒 Buy Now", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Checkout Breakdown Modal (15% Commission Calculations)
  void _showCheckoutSummary(BuildContext context, double price, ListingModel item) {
    double commission = price * 0.15;
    double sellerPayout = price - commission;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAlignment: CrossAlignment.start,
            children: [
              const Text(
                "Checkout Breakdown 🛒",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              _buildSummaryRow("Listing Price", "LKR ${price.toStringAsFixed(2)}", Colors.white),
              const SizedBox(height: 8),
              _buildSummaryRow("MYGame Platform Fee (15%)", "LKR ${commission.toStringAsFixed(2)}", Colors.grey),
              const SizedBox(height: 8),
              _buildSummaryRow("Net Payout to Seller", "LKR ${sellerPayout.toStringAsFixed(2)}", Colors.greenAccent),

              const Divider(color: Colors.grey, height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Payable:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("LKR ${price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Processing purchase with 15% Platform Commission...")),
                    );
                  },
                  child: const Text("PAY VIA MYGAME WALLET", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}
