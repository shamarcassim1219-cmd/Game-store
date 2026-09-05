import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String listingId;
  final String buyerUid;
  final String sellerUid;
  final double totalAmount;      // Total Paid by Buyer (e.g., LKR 10,000)
  final double platformCommission; // 15% Fee (e.g., LKR 1,500)
  final double sellerEarnings;   // 85% Balance for Seller (e.g., LKR 8,500)
  final String status;           // 'holding', 'completed', 'appealed'
  final DateTime holdEndTime;

  OrderModel({
    required this.orderId,
    required this.listingId,
    required this.buyerUid,
    required this.sellerUid,
    required this.totalAmount,
    required this.platformCommission,
    required this.sellerEarnings,
    required this.status,
    required this.holdEndTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'listingId': listingId,
      'buyerUid': buyerUid,
      'sellerUid': sellerUid,
      'totalAmount': totalAmount,
      'platformCommission': platformCommission,
      'sellerEarnings': sellerEarnings,
      'status': status,
      'holdEndTime': holdEndTime,
    };
  }
}
