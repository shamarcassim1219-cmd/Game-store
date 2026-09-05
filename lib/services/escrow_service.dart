import 'package:cloud_firestore/cloud_firestore.dart';

class EscrowService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Process New Purchase with 15% Commission Deduction
  Future<void> processPurchase({
    required String buyerUid,
    required String sellerUid,
    required String listingId,
    required double price,
  }) async {
    // 1. Calculate 15% Platform Commission
    double commission = price * 0.15;
    double sellerShare = price - commission;

    // 2. Set 3-Day Escrow Timer (72 Hours)
    DateTime holdEndTime = DateTime.now().add(const Duration(hours: 72));

    // 3. Create Order Document in Cloud Firestore
    DocumentReference orderRef = _db.collection('orders').doc();
    await orderRef.set({
      'orderId': orderRef.id,
      'listingId': listingId,
      'buyerUid': buyerUid,
      'sellerUid': sellerUid,
      'totalAmount': price,
      'platformCommission': commission, // App Profit Saved Here
      'sellerEarnings': sellerShare,     // Seller Balance
      'status': 'holding',
      'holdStartTime': FieldValue.serverTimestamp(),
      'holdEndTime': Timestamp.fromDate(holdEndTime),
    });

    // 4. Record Platform Profit Entry for Admin Dashboard
    await _db.collection('platform_profits').add({
      'orderId': orderRef.id,
      'amount': commission,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Release Funds to Seller Wallet after 3 Days
  Future<void> releaseFundsToSeller(String orderId) async {
    DocumentSnapshot orderSnap = await _db.collection('orders').doc(orderId).get();
    
    if (orderSnap.exists && orderSnap['status'] == 'holding') {
      double sellerShare = (orderSnap['sellerEarnings'] as num).toDouble();
      String sellerUid = orderSnap['sellerUid'];

      // Add 85% Net Earnings to Seller's Wallet
      await _db.collection('users').doc(sellerUid).update({
        'walletBalance': FieldValue.increment(sellerShare),
      });

      // Update Order Status to Completed
      await _db.collection('orders').doc(orderId).update({
        'status': 'completed',
      });
    }
  }
}
