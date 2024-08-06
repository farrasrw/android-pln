import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_ocgf/menu/isi_set.dart';

class CustomSearchDelegate extends SearchDelegate {
  final CollectionReference collectionRef;
  final VoidCallback onSearchChanged;
  final TextEditingController searchController;

  CustomSearchDelegate({
    required this.collectionRef,
    required this.onSearchChanged,
    required this.searchController,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          searchController.clear();
          query = '';
          onSearchChanged();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: collectionRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        final data = snapshot.data!.docs.where((doc) {
          final title = doc['garduInduk'].toString().toLowerCase();
          final subtitle = doc['penyulang'].toString().toLowerCase();
          return title.contains(query.toLowerCase()) || subtitle.contains(query.toLowerCase());
        }).toList();

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final doc = data[index];
            final title = doc['garduInduk'];
            final subtitle = doc['penyulang'];

            return ListTile(
              title: Text(title),
              subtitle: Text(subtitle),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dataset(
                      data: doc.data() as Map<String, dynamic>,
                      documentId: doc.id,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
