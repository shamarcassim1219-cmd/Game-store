import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String listingId;
  final String buyerUid;
  final String sellerUid;
  final double amount;
  final String status; // 'holding', 'completed', 'appealed', 'refunded'
  final DateTime holdStartTime;
  final DateTime holdEndTime; // 3 Days (72 Hours) countdown

  OrderModel({
    required this.orderId,
    required this.listingId,
    required this.buyerUid,
    required this.sellerUid,
    required this.amount,
    required this.status,
    required this.holdStartTime,
    required this.holdEndTime,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String docId) {
    return OrderModel(
      orderId: docId,
      listingId: data['listingId'] ?? '',
      buyerUid: data['buyerUid'] ?? '',
      sellerUid: data['sellerUid'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'holding',
      holdStartTime: (data['holdStartTime'] as Timestamp).toDate(),
      holdEndTime: (data['holdEndTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'listingId': listingId,
      'buyerUid': buyerUid,
      'sellerUid': sellerUid,
      'amount': amount,
      'status': status,
      'holdStartTime': holdStartTime,
      'holdEndTime': holdEndTime,
    };
  }
}
