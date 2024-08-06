import 'package:flutter/material.dart';

class OCRSegment extends StatelessWidget {
  final String title;
  final TextEditingController arusSettingController;
  final TextEditingController tmsController;
  final TextEditingController waktuOperasiController;
  final TextEditingController arusMoment1Controller;
  final TextEditingController waktuMoment1Controller;
  final TextEditingController arusMoment2Controller;
  final TextEditingController waktuMoment2Controller;

  const OCRSegment({super.key, 
    required this.title,
    required this.arusSettingController,
    required this.tmsController,
    required this.waktuOperasiController,
    required this.arusMoment1Controller,
    required this.waktuMoment1Controller,
    required this.arusMoment2Controller,
    required this.waktuMoment2Controller,
  });

  Widget settingTile({required String title, required String hintText, required TextEditingController controller}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              flex: 5,
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan nilai';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harap masukkan angka yang valid';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    settingTile(title: 'Iset:', hintText: 'Is (A)', controller: arusSettingController),
                    const SizedBox(height: 10.0),
                    settingTile(title: 'TMS:', hintText: 'TMS', controller: tmsController),
                    const SizedBox(height: 10.0),
                    settingTile(title: 't:', hintText: 't (s)', controller: waktuOperasiController),
                    const SizedBox(height: 10.0),
                    settingTile(title: 'Im1:', hintText: 'Im1 (A)', controller: arusMoment1Controller),
                    const SizedBox(height: 10.0),
                    settingTile(title: 'tm1:', hintText: 'tm1(s)', controller: waktuMoment1Controller),
                    const SizedBox(height: 10.0),
                    settingTile(title: 'Im2:', hintText: 'Im2 (A)', controller: arusMoment2Controller),
                    const SizedBox(height: 10.0),
                    settingTile(title: 'tm2:', hintText: 'tm2 (s)', controller: waktuMoment2Controller),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
