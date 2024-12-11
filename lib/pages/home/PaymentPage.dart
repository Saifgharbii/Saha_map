import 'package:flutter/material.dart';
import 'package:saha_map/pages/home/AddCardPage.dart'; // Remplacez par le bon chemin


class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = "Ajouter Carte Bancaire"; // Méthode par défaut sélectionnée

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Crédit",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildPaymentOption(
              icon: Icons.credit_card,
              title: "Ajouter Carte Bancaire",
              isSelected: _selectedPaymentMethod == "Ajouter Carte Bancaire",
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = "Ajouter Carte Bancaire";
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCardPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Autres Méthodes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildPaymentOption(
              icon: Icons.payment,
              title: "Paypal",
              isSelected: _selectedPaymentMethod == "Paypal",
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = "Paypal";
                });
              },
            ),
            _buildPaymentOption(
              icon: Icons.account_balance_wallet,
              title: "Google Pay",
              isSelected: _selectedPaymentMethod == "Google Pay",
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = "Google Pay";
                });
              },
            ),
            _buildPaymentOption(
              icon: Icons.apple,
              title: "Apple Pay",
              isSelected: _selectedPaymentMethod == "Apple Pay",
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = "Apple Pay";
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: Colors.blue,
      ),
      onTap: onTap,
    );
  }
}
