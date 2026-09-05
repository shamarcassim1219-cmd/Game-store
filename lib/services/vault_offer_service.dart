import 'package:cloud_firestore/cloud_firestore.dart';

class VaultOfferService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. 🔐 Vault Credentials Save කිරීම (Encrypted Login Details)
  Future<void> saveVaultCredentials({
    required String listingId,
    required String email,
    required String password,
    required String recoveryInfo,
  }) async {
    await _db.collection('vault_credentials').doc(listingId).set({
      'listingId': listingId,
      'accountEmail': email,
      'accountPassword': password,
      'recoveryInfo': recoveryInfo,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 2. 🤝 Make an Offer (Bidding) Send කිරීම
  Future<void> sendOffer({
    required String listingId,
    required String buyerUid,
    required String sellerUid,
    required double offerPrice,
  }) async {
    await _db.collection('offers').add({
      'listingId': listingId,
      'buyerUid': buyerUid,
      'sellerUid': sellerUid,
      'offerPrice': offerPrice,
      'status': 'pending', // 'accepted', 'rejected'
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 3. 🚀 Boost Listing (Paid Feature)
  Future<void> boostListing(String listingId) async {
    await _db.collection('listings').doc(listingId).update({
      'isFeatured': true,
    });
  }
}
