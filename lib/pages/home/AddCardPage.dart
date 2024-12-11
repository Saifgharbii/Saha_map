import 'package:flutter/material.dart';

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
                  Text(
                    cardNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Nom Et Prénom",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _nameController.text.isNotEmpty
                        ? _nameController.text
                        : "votre nom",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Date D'expiration",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _expiryDateController.text.isNotEmpty
                        ? _expiryDateController.text
                        : "04/28",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 20),

            // Champs de saisie pour le formulaire
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nom Et Prénom",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),

            // Numéro de carte avec validation de 16 chiffres
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: 16, // Limite à 16 caractères
              decoration: const InputDecoration(
                labelText: "Numéro",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                counterText: "", // Cache l'indicateur de longueur
              ),
              onChanged: (value) {
                if (value.length == 16) {
                  setState(() {
                    cardNumber = _formatCardNumber(value);
                  });
                } else {
                  setState(() {
                    cardNumber = "0000 0000 0000 0000";
                  });
                }
              },
            ),
            const SizedBox(height: 10),

            // Date d'expiration et CVV
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: "Date D'expiration",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
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
              ],
            ),
            const SizedBox(height: 20),

            // Bouton Enregistrer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_cardNumberController.text.length == 16) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Carte enregistrée avec succès !"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Veuillez entrer un numéro de carte valide (16 chiffres)."),
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
