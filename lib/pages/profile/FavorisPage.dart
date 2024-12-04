import 'package:flutter/material.dart';
List<Map<String, String>> favoriteDoctors = [];

class FavorisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Médecins Favoris",
          style: TextStyle(color: Colors.teal),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: favoriteDoctors.isEmpty
          ? Center(
        child: Text(
          "Aucun médecin ajouté aux favoris.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: favoriteDoctors.length,
        itemBuilder: (context, index) {
          final doctor = favoriteDoctors[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(doctor['imagepath']!),
            ),
            title: Text(doctor['name']!),
            subtitle: Text(doctor['speciality']!),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                favoriteDoctors.removeAt(index);
                (context as Element).rebuild();
              },
            ),
          );
        },
      ),
    );
  }
}
