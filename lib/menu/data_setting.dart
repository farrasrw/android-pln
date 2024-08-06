import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_ocgf/menu/isi_set.dart';
import 'package:app_ocgf/custom_search.dart';

class DataSetting extends StatefulWidget {
  const DataSetting({super.key});

  @override
  State<DataSetting> createState() => _DataSettingState();
}

class _DataSettingState extends State<DataSetting> {
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('dataset');
  final TextEditingController _searchController = TextEditingController();

  void _handleBackPress() {
    Navigator.pop(context);
  }

  void _handleRefresh() {
    setState(() {});
  }

  void _navigateToSetting(DocumentSnapshot doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Dataset(
          data: doc.data() as Map<String, dynamic>,
          documentId: doc.id,
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context, DocumentSnapshot doc) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Data Setting'),
              onTap: () {
                Navigator.pop(context);
                _navigateToSetting(doc); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Data Simulasi Setting OCR'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Data Simulasi Setting GFR'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _startSearch() {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(
        collectionRef: _collectionRef,
        onSearchChanged: _handleRefresh,
        searchController: _searchController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Data Setting', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _handleBackPress,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white,),
            onPressed: _startSearch,
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _collectionRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doc = data[index];
              final title = doc['garduInduk'];
              final subtitle = doc['penyulang'];

              return ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                onTap: () => _showPopupMenu(context, doc),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _handleRefresh,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Dataset(data: {}, documentId: null)),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
