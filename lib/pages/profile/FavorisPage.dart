import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saha_map/FavoriteDoctorsModel.dart';

class FavorisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var favoriteDoctors = Provider.of<FavoriteDoctorsModel>(context).favoriteDoctors;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Médecins Favoris",
          style: TextStyle(color: Colors.teal),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: favoriteDoctors.isEmpty
          ? const Center(
              child: Text(
                "Aucun médecin ajouté aux favoris.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: favoriteDoctors.length,
              itemBuilder: (context, index) {
                final doctor = favoriteDoctors[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(doctor['imagepath']!),
                    ),
                    title: Text(
                      doctor['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(doctor['speciality']!),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.teal),
                      onPressed: () {
                        Provider.of<FavoriteDoctorsModel>(context, listen: false)
                            .removeFavorite(doctor);

                        final snackBar = SnackBar(
                          content: const Text("Médecin retiré des favoris"),
                          duration: const Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
