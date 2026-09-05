import 'package:flutter/material.dart';
import '../services/vault_offer_service.dart';

void showMakeOfferDialog({
  required BuildContext context,
  required String listingId,
  required String sellerUid,
  required double currentPrice,
}) {
  final offerController = TextEditingController();
  final VaultOfferService service = VaultOfferService();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF1E1E1E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAlignment: CrossAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.local_offer, color: Colors.orangeAccent),
                SizedBox(width: 8),
                Text(
                  "Make an Offer 🏷️",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Listing Price: LKR ${currentPrice.toStringAsFixed(0)}. Enter your negotiated price below:",
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: offerController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Your Offer Price (LKR)",
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF121212),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                onPressed: () async {
                  double? offer = double.tryParse(offerController.text.trim());
                  if (offer != null && offer > 0) {
                    await service.sendOffer(
                      listingId: listingId,
                      buyerUid: "CURRENT_USER_UID", // Will pass from Auth
                      sellerUid: sellerUid,
                      offerPrice: offer,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Offer sent to seller successfully!")),
                    );
                  }
                },
                child: const Text("SEND OFFER TO SELLER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    },
  );
}
