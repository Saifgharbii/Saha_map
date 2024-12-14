import 'package:flutter/material.dart';
import 'PaymentPage.dart';
import 'PaymentSuccessPage.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  DateTime currentDateTime = DateTime.now();
  String reserverPour = "Moi-même"; // Par défaut

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Payment", style: TextStyle(color: Colors.teal)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "70.00 D",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                      'assets/images/doctor1.png'), // Remplacez par votre image
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Dr.X",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Dermatologue",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    Text("5.0", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 60, 60, 60).withOpacity(0.3),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoRow(
                    label: "Date / Hour",
                    value:
                        "${currentDateTime.day}-${currentDateTime.month}-${currentDateTime.year} / ${currentDateTime.hour}:${currentDateTime.minute}",
                  ),
                  InfoRow(label: "Durée", value: "30 Minutes"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Réserver pour",
                        style: TextStyle(
                            color: Color.fromARGB(255, 97, 97, 97),
                            fontSize: 16),
                      ),
                      DropdownButton<String>(
                        value: reserverPour,
                        items: ["Moi-même", "Une autre personne"]
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            reserverPour = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  InfoRow(label: "Prix", value: "70.00D"),
                  InfoRow(label: "Duration", value: "30 Minutes"),
                  InfoRow(label: "Total", value: "70D"),
                  InfoRow(
                    label: "Carte Bancaire",
                    value: "Changer",
                    showButton: true,
                    onTapButton: () {
                      // Naviguer vers la page AddCardPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentSuccessPage(),
        ),
      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Payer Maintenant",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showButton;
  final VoidCallback? onTapButton;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.showButton = false,
    this.onTapButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),
          showButton
              ? TextButton(
                  onPressed: onTapButton,
                  child: const Text(
                    "Changer",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }
}


