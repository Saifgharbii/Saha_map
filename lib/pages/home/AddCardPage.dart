import 'package:flutter/material.dart';
import 'package:saha_map/pages/home/CheckoutPage.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String cardNumber = "0000 0000 0000 0000";
  String name = "Votre nom";
  String expiryDate = "04/28";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          "Ajouter Carte",
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
          children: [
            // Carte bleue simulée
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      
                      Text(
                        cardNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Nom Et Prénom",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Date D'expiration",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    expiryDate,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Champs de saisie pour le formulaire
            SizedBox(
              width: double.infinity, // Assurez-vous que le champ a une largeur fixe
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nom Et Prénom",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {
                    name = _nameController.text.isNotEmpty
                        ? _nameController.text
                        : "Votre nom";
                  });
                },
              ),
            ),
            const SizedBox(height: 10),

            // Numéro de carte avec validation de 16 chiffres
            SizedBox(
              width: double.infinity, // Largeur fixe pour le champ de numéro de carte
              child: TextField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                maxLength: 16, // Limite à 16 caractères
                decoration: const InputDecoration(
                  labelText: "Numéro de carte",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  counterText: "", // Cache l'indicateur de longueur
                ),
                onChanged: (value) {
                  setState(() {
                    cardNumber = _formatCardNumber(value);
                  });
                },
              ),
            ),
            const SizedBox(height: 10),

            // Date d'expiration et CVV avec largeur fixe
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity, // Largeur fixe pour le champ de date d'expiration
                    child: TextField(
                      controller: _expiryDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        labelText: "Date D'expiration",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        setState(() {
                          expiryDate = _expiryDateController.text.isNotEmpty
                              ? _expiryDateController.text
                              : "04/28";
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    width: double.infinity, // Largeur fixe pour le champ de CVV
                    child: TextField(
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      maxLength: 3, // CVV limite à 3 chiffres
                      decoration: const InputDecoration(
                        labelText: "CVV",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        counterText: "",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Bouton Enregistrer avec validation
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String cardNumberInput = _cardNumberController.text.replaceAll(" ", "");
                  String cvvInput = _cvvController.text;

                  if (cardNumberInput.length == 16 && cvvInput.length == 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Carte enregistrée avec succès !"),
                        backgroundColor: Color.fromARGB(255, 200, 232, 201),
                      ),
                    );
                    // Navigue vers la nouvelle page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckoutPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Veuillez entrer un numéro de carte valide (16 chiffres) et un CVV valide (3 chiffres)."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Enregistrer",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour formater le numéro de carte
  String _formatCardNumber(String number) {
    final buffer = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      buffer.write(number[i]);
      if ((i + 1) % 4 == 0 && i != number.length - 1) {
        buffer.write(" "); // Ajoute un espace toutes les 4 chiffres
      }
    }
    return buffer.toString();
  }
}
