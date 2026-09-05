import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  final String id;
  final String sellerUid;
  final String sellerName;
  final bool isSellerVerified; // Shows Blue Tick [✔]
  final String gameType; // 'PUBG Mobile', 'Free Fire', etc.
  final String title;
  final double price;
  final List<String> imageUrls;
  final String description;
  final String status; // 'active', 'sold', 'disputed'
  final DateTime createdAt;

  ListingModel({
    required this.id,
    required this.sellerUid,
    required this.sellerName,
    required this.isSellerVerified,
    required this.gameType,
    required this.title,
    required this.price,
    required this.imageUrls,
    required this.description,
    this.status = 'active',
    required this.createdAt,
  });

  factory ListingModel.fromMap(Map<String, dynamic> data, String docId) {
    return ListingModel(
      id: docId,
      sellerUid: data['sellerUid'] ?? '',
      sellerName: data['sellerName'] ?? '',
      isSellerVerified: data['isSellerVerified'] ?? false,
      gameType: data['gameType'] ?? '',
      title: data['title'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      description: data['description'] ?? '',
      status: data['status'] ?? 'active',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sellerUid': sellerUid,
      'sellerName': sellerName,
      'isSellerVerified': isSellerVerified,
      'gameType': gameType,
      'title': title,
      'price': price,
      'imageUrls': imageUrls,
      'description': description,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
