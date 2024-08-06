import 'package:flutter/material.dart';
import 'package:app_ocgf/screens/login.dart';
import 'package:app_ocgf/menu/data_setting.dart';
import 'package:app_ocgf/menu/simulasi_ocr.dart';
import 'package:app_ocgf/menu/simulasi_gfr.dart';
import 'dart:io';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const String keluarText = 'Keluar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Center(
          child: Text('Beranda', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people_alt_rounded),
              title: const Text('Ganti Akun'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(keluarText),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi Keluar'),
                    content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () => exit(0),
                        child: const Text('Keluar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 20),
          _buildElevatedButtonWithNavigation(
            icon: Icons.cloud,
            text: 'Data Setting',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DataSetting(),
              ),
            ),
          ),
          const Divider(thickness: 1),
          _buildElevatedButtonWithNavigation(
            icon: Icons.bar_chart,
            text: 'Simulasi Setting OCR',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SimulasiOcr(),
              ),
            ),
          ),
          const Divider(thickness: 1),
          _buildElevatedButtonWithNavigation(
            icon: Icons.bar_chart,
            text: 'Simulasi Setting GFR',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SimulasiGfr(),
              ),
            ),
          ),
        const SizedBox(height: 20),
          Text(
            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildElevatedButtonWithNavigation({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        minimumSize: const Size(150, 50),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
