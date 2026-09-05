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
                        onPressed: () {},
                        child: const Text("🛒 View Details", style: TextStyle(color: Colors.white)),
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
}
