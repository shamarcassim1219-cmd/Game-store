import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of listings for Home Screen
  Stream<List<ListingModel>> getListings({String? gameType}) {
    Query query = _db.collection('listings').where('status', isEqualTo: 'active');
    
    if (gameType != null && gameType.isNotEmpty && gameType != 'All') {
      query = query.where('gameType', isEqualTo: gameType);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ListingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Create new account listing
  Future<void> createListing(ListingModel listing) async {
    await _db.collection('listings').add(listing.toMap());
  }

  // Submit Seller Verification Details
  Future<void> submitVerification({
    required String userId,
    required String nicFrontUrl,
    required String nicBackUrl,
    required String selfieUrl,
    required String gameId,
  }) async {
    await _db.collection('verification_requests').doc(userId).set({
      'userId': userId,
      'nicFrontUrl': nicFrontUrl,
      'nicBackUrl': nicBackUrl,
      'selfieUrl': selfieUrl,
      'gameId': gameId,
      'status': 'pending',
      'feePaid': true,
      'submittedAt': FieldValue.serverTimestamp(),
    });

    // Update user status
    await _db.collection('users').doc(userId).update({
      'verificationStatus': 'pending',
    });
  }
}
