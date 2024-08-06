import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dataset extends StatefulWidget {
  final Map<String, dynamic> data;
  final String? documentId;

  const Dataset({super.key, required this.data, this.documentId});

  @override
  State<Dataset> createState() => _DatasetState();
}

class _DatasetState extends State<Dataset> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _garduIndukController = TextEditingController();
  final TextEditingController _penyulangController = TextEditingController();
  final TextEditingController _kapasitasController = TextEditingController();
  final TextEditingController _teganganPrimerController = TextEditingController();
  final TextEditingController _teganganSekunderController = TextEditingController();
  final TextEditingController _arusNominalController = TextEditingController();
  final TextEditingController _ratioCTController = TextEditingController();
  final TextEditingController _panjangZona1Controller = TextEditingController();
  final TextEditingController _panjangZona2Controller = TextEditingController();
  final TextEditingController _mvaScController = TextEditingController();
  final TextEditingController _impedansiSumberController = TextEditingController();
  final TextEditingController _persenImpedansiController = TextEditingController();
  final TextEditingController _impedansiTrafoController = TextEditingController();
  final TextEditingController _arusBebanController = TextEditingController();
  final TextEditingController _pentanahanController = TextEditingController();
  final TextEditingController _z0TrafoController = TextEditingController();
  String _selectedPenghantarZona1 = 'A3C 3x35';
  String _selectedPenghantarZona2 = 'A3C 3x35';

  final List<String> _jenisPenghantar = [
    'A3C 3x35',
    'A3C 3x70',
    'A3C 3x95',
    'A3C 3x150',
    'A3C 3x240',
    'SKTM Al 3x150',
    'SKTM Al 3x240',
    'SKTM Cu 3x150',
    'SKTM Cu 3x240',
    'MVTIC Al 3x150',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _addTextControllersListeners();
  }

  void _loadData() {
    if (widget.data.isNotEmpty) {
      _garduIndukController.text = widget.data['garduInduk'] ?? '';
      _penyulangController.text = widget.data['penyulang'] ?? '';
      _kapasitasController.text = widget.data['kapasitas']?.toString() ?? '';
      _teganganPrimerController.text = widget.data['teganganPrimer']?.toString() ?? '';
      _teganganSekunderController.text = widget.data['teganganSekunder']?.toString() ?? '';
      _arusNominalController.text = widget.data['arusNominal']?.toString() ?? '';
      _ratioCTController.text = widget.data['ratioCT']?.toString() ?? '';
      _arusBebanController.text = widget.data['arusBeban']?.toString() ?? '';
      _pentanahanController.text = widget.data['pentanahan']?.toString() ?? '';
      _z0TrafoController.text = widget.data['z0Trafo']?.toString() ?? '';
      _panjangZona1Controller.text = widget.data['panjangZona1'] ?? '';
      _panjangZona2Controller.text = widget.data['panjangZona2']?.toString() ?? '';
      _mvaScController.text = widget.data['mvaSc']?.toString() ?? '';
      _impedansiSumberController.text = widget.data['impedansiSumber']?.toString() ?? '';
      _persenImpedansiController.text = widget.data['persenImpedansi']?.toString() ?? '';
      _impedansiTrafoController.text = widget.data['impedansiTrafo']?.toString() ?? '';
      _selectedPenghantarZona1 = widget.data['penghantarZona1'] ?? _jenisPenghantar.first;
      _selectedPenghantarZona2 = widget.data['penghantarZona2'] ?? _jenisPenghantar.first;
      _hitungImpedansiSumber();
      _hitungPersenImpedansi();
    }
  }

  void _addTextControllersListeners() {
    _persenImpedansiController.addListener(_hitungPersenImpedansi);
    _mvaScController.addListener(_hitungImpedansiSumber);
  }

  void _hitungImpedansiSumber() {
    if (_teganganSekunderController.text.isNotEmpty && _mvaScController.text.isNotEmpty) {
      final teganganSekunder = double.tryParse(_teganganSekunderController.text) ?? 0.0;
      final mvaSc = double.tryParse(_mvaScController.text) ?? 0.0;

      if (teganganSekunder > 0 && mvaSc > 0) {
        final impedansiSumber = (teganganSekunder * 0.001) * (teganganSekunder * 0.001) / mvaSc;
        setState(() {
          _impedansiSumberController.text = impedansiSumber.toStringAsFixed(2);
        });
      }
    }
  }

  void _hitungPersenImpedansi() {
    if (_persenImpedansiController.text.isNotEmpty && _teganganSekunderController.text.isNotEmpty && _kapasitasController.text.isNotEmpty) {
      final persenImpedansi = double.tryParse(_persenImpedansiController.text) ?? 0.0;
      final teganganSekunder = double.tryParse(_teganganSekunderController.text) ?? 0.0;
      final kapasitas = double.tryParse(_kapasitasController.text) ?? 0.0;

      if (persenImpedansi > 0 && teganganSekunder > 0 && kapasitas > 0) {
        final impedansiTrafo = (persenImpedansi / 100) * (teganganSekunder * 0.001) * (teganganSekunder * 0.001) / (kapasitas * 0.001);
        setState(() {
          _impedansiTrafoController.text = impedansiTrafo.toStringAsFixed(2);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'Data Setting',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            textFormFieldWithTitle('Gardu Induk', _garduIndukController),
            const SizedBox(height: 10.0),
            textFormFieldWithTitle('Penyulang', _penyulangController),
            const SizedBox(height: 10.0),
            const Center(
              child: Text(
                'Data Transformator',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20.0),
            settingTile(title: 'Kapasitas:', hintText: 'MVA Trafo (VA)', controller: _kapasitasController),
            const SizedBox(height: 10.0),
            settingTile(title: 'Tegangan Primer:', hintText: 'Vp(V)', controller: _teganganPrimerController),
            const SizedBox(height: 10.0),
            settingTile(title: 'Tegangan Sekunder:', hintText: 'Vs(V)', controller: _teganganSekunderController),
            const SizedBox(height: 10.0),
            settingTile(title: 'Arus Nominal:', hintText: 'In(A)', controller: _arusNominalController),
            const SizedBox(height: 10.0),
            settingTile(title: 'Ratio CT:', hintText: 'Input nilai ratio', controller: _ratioCTController),
            const SizedBox(height: 10.0),
            settingTile(title: 'Pentanahan:', hintText: '(Ω)', controller: _pentanahanController),
            const SizedBox(height: 10.0),
            settingTile(title: 'Belitan Δ:', hintText: '(Zo Ω)', controller: _z0TrafoController),
            const SizedBox(height: 20.0),
            const Center(
              child: Text(
                'Data Penghantar',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20.0),
            settingTile(title: 'Panjang GI-GH(Zona 1):', hintText: 'Input (km)', controller: _panjangZona1Controller),
            const SizedBox(height: 10.0),
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: DropdownButtonFormField<String>(
                  value: _selectedPenghantarZona1,
                  items: _jenisPenghantar.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPenghantarZona1 = newValue!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Jenis Penghantar:'),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            settingTile(title: 'Panjang GH-Jaringan(Zona2):', hintText: 'Input (km)', controller: _panjangZona2Controller),
            const SizedBox(height: 10.0),
            Card(
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: DropdownButtonFormField<String>(
                  value: _selectedPenghantarZona2,
                  items: _jenisPenghantar.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPenghantarZona2 = newValue!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Jenis Penghantar:'),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            settingTile(title: 'MVA SC:', hintText: 'Input (MVA)', controller: _mvaScController),
            const SizedBox(height: 10.0),
            settingTile(title: 'Impedansi Sumber:', hintText: 'Zs (Ω)', controller: _impedansiSumberController),
            const SizedBox(height: 10.0),
            settingTile(title: 'Persen Impedansi:', hintText: 'Input (%)', controller: _persenImpedansiController),
            const SizedBox(height: 10.0),
            settingTile(title: 'Impedansi Trafo:', hintText: 'Zt (Ω)', controller: _impedansiTrafoController),
            const SizedBox(height: 10.0),
            settingTile(title: 'I beban maks:', hintText: 'Ibm (A)', controller: _arusBebanController),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: _saveData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Simpan Data', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ElevatedButton(
                      onPressed: _deleteData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Hapus Data',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textFormFieldWithTitle(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field ini harus diisi';
          }
          return null;
        },
      ),
    );
  }

  Widget settingTile({required String title, required String hintText, required TextEditingController controller, String? Function(String?)? validator,}) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  errorStyle: const TextStyle(color: Colors.redAccent),
                ),
                keyboardType: TextInputType.number,
                validator: validator ?? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap isi dengan benar';
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


  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'garduInduk': _garduIndukController.text,
        'penyulang': _penyulangController.text,
        'kapasitas': double.tryParse(_kapasitasController.text) ?? 0.0,
        'teganganPrimer': double.tryParse(_teganganPrimerController.text) ?? 0.0,
        'teganganSekunder': double.tryParse(_teganganSekunderController.text) ?? 0.0,
        'arusNominal': double.tryParse(_arusNominalController.text) ?? 0.0,
        'ratioCT': double.tryParse(_ratioCTController.text) ?? 0.0,
        'arusBeban': double.tryParse(_arusBebanController.text)?? 0.0,
        'pentanahan': double.tryParse(_pentanahanController.text)?? 0.0,
        'z0Trafo': double.tryParse(_z0TrafoController.text)?? 0.0,
        'panjangZona1': _panjangZona1Controller.text,
        'panjangZona2': _panjangZona2Controller.text,
        'mvaSc': double.tryParse(_mvaScController.text) ?? 0.0,
        'impedansiSumber': double.tryParse(_impedansiSumberController.text) ?? 0.0,
        'persenImpedansi': double.tryParse(_persenImpedansiController.text) ?? 0.0,
        'impedansiTrafo': double.tryParse(_impedansiTrafoController.text) ?? 0.0,
        'penghantarZona1': _selectedPenghantarZona1,
        'penghantarZona2': _selectedPenghantarZona2,
      };

      if (widget.documentId == null) {
      await FirebaseFirestore.instance.collection('dataset').add(data);
    } else {
      await FirebaseFirestore.instance.collection('dataset').doc(widget.documentId).update(data);
    }

    Navigator.pop(context);
  }
}


  void _deleteData() async {
    if (widget.documentId != null) {
      await FirebaseFirestore.instance.collection('dataset').doc(widget.documentId).delete();
      Navigator.pop(context);
    }
  }
}