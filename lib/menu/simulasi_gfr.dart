import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:app_ocgf/provider/tabelgfr_provider.dart';
import 'package:app_ocgf/tabelgrafik/tabelgrafik_gfr.dart';

class SimulasiGfr extends StatefulWidget {
  const SimulasiGfr({super.key});

  @override
  State<SimulasiGfr> createState() => _SimulasiGfrState();
}

class _SimulasiGfrState extends State<SimulasiGfr>with ChangeNotifier {
  final TextEditingController _teganganSekunderController = TextEditingController();
  final TextEditingController _panjangZona1Controller = TextEditingController();
  final TextEditingController _panjangZona2Controller = TextEditingController();
  final TextEditingController _impedansiSumberController = TextEditingController();
  final TextEditingController _impedansiTrafoController = TextEditingController();
  final TextEditingController _arusBebanController = TextEditingController();
  final TextEditingController _pentanahanController = TextEditingController();
  final TextEditingController _z0TrafoController = TextEditingController();
  final TextEditingController _arusSettingZona1Controller = TextEditingController();
  final TextEditingController _tmsZona1Controller = TextEditingController();
  final TextEditingController _waktuOperasiZona1Controller = TextEditingController();
  final TextEditingController _arusMoment1Zona1Controller = TextEditingController();
  final TextEditingController _waktuMoment1Zona1Controller = TextEditingController();
  final TextEditingController _arusMoment2Zona1Controller = TextEditingController();
  final TextEditingController _waktuMoment2Zona1Controller = TextEditingController();
  final TextEditingController _konsAController = TextEditingController();
  final TextEditingController _konsBController = TextEditingController();
  final TextEditingController _zG12RController = TextEditingController();
  final TextEditingController _zG12jxController = TextEditingController();
  final TextEditingController _zG0RController = TextEditingController();
  final TextEditingController _zG0jxController = TextEditingController();
  final TextEditingController _zJ12RController = TextEditingController();
  final TextEditingController _zJ12jxController = TextEditingController();
  final TextEditingController _zJ0RController = TextEditingController();
  final TextEditingController _zJ0jxController = TextEditingController();

  final TextEditingController _arusSettingZona2Controller = TextEditingController();
  final TextEditingController _tmsZona2Controller = TextEditingController();
  final TextEditingController _waktuOperasiZona2Controller = TextEditingController();
  final TextEditingController _arusMoment1Zona2Controller = TextEditingController();
  final TextEditingController _waktuMoment1Zona2Controller = TextEditingController();
  final TextEditingController _arusMoment2Zona2Controller = TextEditingController();
  final TextEditingController _waktuMoment2Zona2Controller = TextEditingController();

  final double _hasilPerhitungan = 0.0;

  String? _selectedGarduInduk;
  String? _selectedPenyulang;
  String? _selectedKarakteristik;
  String? _selectedPenghantarZona1;
  String? _selectedPenghantarZona2;

  
  List<DocumentSnapshot> _documents = [];
  List<String> _penyulang = [];

  final Map<String, Map<String, double>> _karakteristikValues = {
    'Standart Inverse': {'a': 0.02, 'b': 0.14},
    'Very Inverse': {'a': 1.0, 'b': 13.2},
    'Extreme Inverse': {'a': 2.0, 'b': 80.0},
    'Long Time Inverse': {'a': 1.0, 'b': 120.0},
  };

  final Map<String, Map<String, double>> _impedansiValues = {
    'A3C 3x35': {'Z12R': 0.922, 'Z12jX': 0.38, 'Z0R': 1.07, 'Z0jX': 1.67},
    'A3C 3x70': {'Z12R': 0.461, 'Z12jX': 0.36, 'Z0R': 0.61, 'Z0jX': 1.64},
    'A3C 3x95': {'Z12R': 0.340, 'Z12jX': 0.35, 'Z0R': 0.49, 'Z0jX': 1.63},
    'A3C 3x150': {'Z12R': 0.216, 'Z12jX': 0.33, 'Z0R': 0.36, 'Z0jX': 1.62},
    'A3C 3x240': {'Z12R': 0.134, 'Z12jX': 0.32, 'Z0R': 0.28, 'Z0jX': 1.60},
    'SKTM Al 3x150': {'Z12R': 0.265, 'Z12jX': 0.13, 'Z0R': 0.66, 'Z0jX': 0.32},
    'SKTM Al 3x240': {'Z12R': 0.162, 'Z12jX': 0.12, 'Z0R': 0.41, 'Z0jX': 0.3},
    'SKTM Cu 3x150': {'Z12R': 0.159, 'Z12jX': 0.13, 'Z0R': 0.40, 'Z0jX': 0.32},
    'SKTM Cu 3x240': {'Z12R': 0.098, 'Z12jX': 0.12, 'Z0R': 0.25, 'Z0jX': 0.30},
    'MVTIC Al 3x150': {'Z12R': 0.265, 'Z12jX': 0.13, 'Z0R': 0.66, 'Z0jX': 0.32},
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('dataset').get();
    setState(() {
      _documents = snapshot.docs;
    });
  }

  void _handleBackPress() {
    Navigator.pop(context);
  }

  void _updateKonstanta(String karakteristik) {
    final karakteristikData = _karakteristikValues[karakteristik];
    if (karakteristikData != null) {
      _konsAController.text = karakteristikData['a'].toString();
      _konsBController.text = karakteristikData['b'].toString();
    }
  }

  void _updateImpedansiGi(String jenisPenghantar) {
    final impedanceValues = _impedansiValues[jenisPenghantar];
    if (impedanceValues != null) {
      setState(() {
        _zG12RController.text = impedanceValues['Z12R'].toString();
        _zG12jxController.text = impedanceValues['Z12jX'].toString();
        _zG0RController.text = impedanceValues['Z0R'].toString();
        _zG0jxController.text = impedanceValues['Z0jX'].toString();
      });
    }
  }

  void _updateImpedansiJar(String jenisPenghantar) {
    final impedanceValues = _impedansiValues[jenisPenghantar];
    if (impedanceValues != null) {
      setState(() {
        _zJ12RController.text = impedanceValues['Z12R'].toString();
        _zJ12jxController.text = impedanceValues['Z12jX'].toString();
        _zJ0RController.text = impedanceValues['Z0R'].toString();
        _zJ0jxController.text = impedanceValues['Z0jX'].toString();
      });
    }
  }

  void _hitungSet() {
    double arusBeban= double.tryParse(_arusBebanController.text) ?? 0.0;
    _arusSettingZona1Controller.text = (0.2 * arusBeban).toString();
  }

  void _providerGfr(){
    //buat provider
    double arusZ1 = double.tryParse(_arusSettingZona1Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setArusZ1(arusZ1);
    double tmsZ1 = double.tryParse(_tmsZona1Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setTmsZ1(tmsZ1);
    double arusM1Z1 = double.tryParse(_arusMoment1Zona1Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setArusM1Z1(arusM1Z1);
    double waktuM1Z1 = double.tryParse(_waktuMoment1Zona1Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setWaktuM1Z1(waktuM1Z1);
    double arusM2Z1 = double.tryParse(_arusMoment2Zona1Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setArusM2Z1(arusM2Z1);
    double waktuM2Z1 = double.tryParse(_waktuMoment2Zona1Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setWaktuM2Z1(waktuM2Z1);

    double arusZ2 = double.tryParse(_arusSettingZona2Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setArusZ2(arusZ2);
    double tmsZ2 = double.tryParse(_tmsZona2Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setTmsZ2(tmsZ2);
    double arusM1Z2 = double.tryParse(_arusMoment1Zona2Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setArusM1Z2(arusM1Z2);
    double waktuM1Z2 = double.tryParse(_waktuMoment1Zona2Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setWaktuM1Z2(waktuM1Z2);
    double arusM2Z2 = double.tryParse(_arusMoment2Zona2Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setArusM2Z2(arusM2Z2);
    double waktuM2Z2 = double.tryParse(_waktuMoment2Zona2Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setWaktuM2Z2(waktuM2Z2);

    double teganganSekunder = double.tryParse(_teganganSekunderController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setVsekunder(teganganSekunder);
    double pentanahan = double.tryParse(_pentanahanController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setPentanahan(pentanahan);
    double z0Trafo = double.tryParse(_z0TrafoController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setZ0Trafo(z0Trafo);
    double panjangZona1 = double.tryParse(_panjangZona1Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setPanjangZona1(panjangZona1);
    double panjangZona2 = double.tryParse(_panjangZona2Controller.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setPanjangZona2(panjangZona2);
    double impedansiSumber = double.tryParse(_impedansiSumberController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setZsumber(impedansiSumber);
    double impedansiTrafo = double.tryParse(_impedansiTrafoController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setZtrafo(impedansiTrafo);
    
    double zG12R = double.tryParse(_zG12RController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setZG12r(zG12R);
    double zG12Jx = double.tryParse(_zG12jxController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setZG12jx(zG12Jx);
    double zJ12R = double.tryParse(_zJ12RController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setZJ12r(zJ12R);
    double zJ12Jx = double.tryParse(_zJ12jxController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setZJ12jx(zJ12Jx);
    double zG0R = double.tryParse(_zG0RController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setZG0r(zG0R);
    double zG0Jx = double.tryParse(_zG0jxController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setZG0jx(zG0Jx);
    double zJ0R = double.tryParse(_zJ0RController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setZJ0r(zJ0R);
    double zJ0Jx = double.tryParse(_zJ0jxController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setZJ0jx(zJ0Jx);
    double konsA = double.tryParse(_konsAController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setA(konsA);
    double konsB = double.tryParse(_konsBController.text) ?? 0.0;
    Provider.of<DataGfrProvider>(context, listen: false).setB(konsB);
  }
  Future<void> _saveData() async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference hasil = FirebaseFirestore.instance.collection('simulsi-gfr');

      // Create a map of the data to save
      Map<String, dynamic> data = {
        'garduInduk': _selectedGarduInduk,
        'penyulang': _selectedPenyulang,
        'teganganSekunder': double.tryParse(_teganganSekunderController.text),
        'pentanahan': double.tryParse(_pentanahanController.text),
        'z0Trafo': double.tryParse(_z0TrafoController.text),
        'panjangZona1': double.tryParse(_panjangZona1Controller.text),
        'panjangZona2': double.tryParse(_panjangZona2Controller.text),
        'impedansiSumber': double.tryParse(_impedansiSumberController.text),
        'impedansiTrafo': double.tryParse(_impedansiTrafoController.text),        
        'arusBeban': double.tryParse(_arusBebanController.text),
        'penghantarZona1': _selectedPenghantarZona1,
        'penghantarZona2': _selectedPenghantarZona2,
        'karakteristik': _selectedKarakteristik,
        'konsA': double.tryParse(_konsAController.text),
        'konsB': double.tryParse(_konsBController.text),
        'gfrZona1': {
          'arusSetting': double.tryParse(_arusSettingZona1Controller.text),
          'tms': double.tryParse(_tmsZona1Controller.text),
          'waktuOperasi': double.tryParse(_waktuOperasiZona1Controller.text),
          'arusMoment1': double.tryParse(_arusMoment1Zona1Controller.text),
          'waktuMoment1': double.tryParse(_waktuMoment1Zona1Controller.text),
          'arusMoment2': double.tryParse(_arusMoment2Zona1Controller.text),
          'waktuMoment2': double.tryParse(_waktuMoment2Zona1Controller.text),
        },
        'gfrZona2': {
          'arusSetting': double.tryParse(_arusSettingZona2Controller.text),
          'tms': double.tryParse(_tmsZona2Controller.text),
          'waktuOperasi': double.tryParse(_waktuOperasiZona2Controller.text),
          'arusMoment1': double.tryParse(_arusMoment1Zona2Controller.text),
          'waktuMoment1': double.tryParse(_waktuMoment1Zona2Controller.text),
          'arusMoment2': double.tryParse(_arusMoment2Zona2Controller.text),
          'waktuMoment2': double.tryParse(_waktuMoment2Zona2Controller.text),
        },
        'impedansiZ1': {
          'Z12R': double.tryParse(_zG12RController.text),
          'Z12jX': double.tryParse(_zG12jxController.text),
          'Z0R': double.tryParse(_zG0RController.text),
          'Z0jX': double.tryParse(_zG0jxController.text),
        },
        'impedansiZ2': {
          'Z12R': double.tryParse(_zJ12RController.text),
          'Z12jX': double.tryParse(_zJ12jxController.text),
          'Z0R': double.tryParse(_zJ0RController.text),
          'Z0jX': double.tryParse(_zJ0jxController.text),
        },
      };

      // Add the document to Firestore
      await hasil.add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }



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
                  if (double.tryParse(value) == null) {
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

  Widget ocrSegment({
    required String title,
    required TextEditingController arusSettingController,
    required TextEditingController tmsController,
    required TextEditingController waktuOperasiController,
    required TextEditingController arusMoment1Controller,
    required TextEditingController waktuMoment1Controller,
    required TextEditingController arusMoment2Controller,
    required TextEditingController waktuMoment2Controller,
  }) {
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
                    settingTile(title: 'Im1 (I>1):', hintText: 'Im1 (A)', controller: arusMoment1Controller),
                    const SizedBox(height: 10.0),
                    settingTile(title: 'tm1 (t>1):', hintText: 'tm1(s)', controller: waktuMoment1Controller),
                    const SizedBox(height: 10.0),
                    settingTile(title: 'Im2 (I>2):', hintText: 'Im2 (A)', controller: arusMoment2Controller),
                    const SizedBox(height: 10.0),
                    settingTile(title: 'tm2 (t>2):', hintText: 'tm2 (s)', controller: waktuMoment2Controller),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Simulasi GFR', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _handleBackPress,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: _selectedGarduInduk,
                hint: const Text('Pilih Gardu Induk'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGarduInduk = newValue;
                    _penyulang = _documents
                        .where((doc) => doc['garduInduk'] == newValue)
                        .map((doc) => doc['penyulang'] as String)
                        .toList();
                    _selectedPenyulang = null;
                    _selectedPenghantarZona1 = null;
                    _selectedPenghantarZona2 = null;
                    _teganganSekunderController.clear();
                    _pentanahanController.clear();
                    _z0TrafoController.clear();
                    _panjangZona1Controller.clear();
                    _panjangZona2Controller.clear();
                    _impedansiSumberController.clear();
                    _impedansiTrafoController.clear();
                    _arusBebanController.clear();
                  });
                },
                items: _documents.map<DropdownMenuItem<String>>((DocumentSnapshot document) {
                  return DropdownMenuItem<String>(
                    value: document['garduInduk'],
                    child: Text(document['garduInduk']),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: _selectedPenyulang,
                hint: const Text('Pilih Penyulang'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPenyulang = newValue;
                    final selectedDoc = _documents.firstWhere((doc) =>
                        doc['garduInduk'] == _selectedGarduInduk && doc['penyulang'] == newValue);
                    _teganganSekunderController.text = selectedDoc['teganganSekunder'].toString();
                    _pentanahanController.text = selectedDoc['pentanahan'].toString();
                    _z0TrafoController.text = selectedDoc['z0Trafo'].toString();
                    _panjangZona1Controller.text = selectedDoc['panjangZona1'].toString();
                    _panjangZona2Controller.text = selectedDoc['panjangZona2'].toString();
                    _impedansiSumberController.text = selectedDoc['impedansiSumber'].toString();
                    _impedansiTrafoController.text = selectedDoc['impedansiTrafo'].toString();
                    _arusBebanController.text = selectedDoc['arusBeban'].toString();
                    _selectedPenghantarZona1 = selectedDoc['penghantarZona1'];
                    _selectedPenghantarZona2 = selectedDoc['penghantarZona2'];
                    _updateImpedansiGi(_selectedPenghantarZona1!);
                    _updateImpedansiJar(_selectedPenghantarZona2!);
                  });
                },
                items: _penyulang.map<DropdownMenuItem<String>>((String penyulang) {
                  return DropdownMenuItem<String>(
                    value: penyulang,
                    child: Text(penyulang),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: const Text('I beban maks (Ibm):'),
              trailing: SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _arusBebanController,
                  decoration: const InputDecoration(
                    hintText: 'A'
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Panjang GI-GH(Zona 1):'),
              trailing: SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _panjangZona1Controller,
                  decoration: const InputDecoration(
                    hintText: 'km'
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Panjang GH-Jaringan(Zona 2):'),
              trailing: SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _panjangZona2Controller,
                  decoration: const InputDecoration(
                    hintText: 'km'
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Impedansi Sumber (Zs):'),
              trailing: SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _impedansiSumberController,
                  decoration: const InputDecoration(
                    hintText: 'Ω'
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Impedansi Trafo (Zt):'),
              trailing: SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _impedansiTrafoController,
                  decoration: const InputDecoration(
                    hintText: 'Ω'
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ocrSegment(
                  title: 'GFR Zona 1',
                  arusSettingController: _arusSettingZona1Controller,
                  tmsController: _tmsZona1Controller,
                  waktuOperasiController: _waktuOperasiZona1Controller,
                  arusMoment1Controller: _arusMoment1Zona1Controller,
                  waktuMoment1Controller: _waktuMoment1Zona1Controller,
                  arusMoment2Controller: _arusMoment2Zona1Controller,
                  waktuMoment2Controller: _waktuMoment2Zona1Controller,
                ),
                ocrSegment(
                  title: 'GFR Zona 2',
                  arusSettingController: _arusSettingZona2Controller,
                  tmsController: _tmsZona2Controller,
                  waktuOperasiController: _waktuOperasiZona2Controller,
                  arusMoment1Controller: _arusMoment1Zona2Controller,
                  waktuMoment1Controller: _waktuMoment1Zona2Controller,
                  arusMoment2Controller: _arusMoment2Zona2Controller,
                  waktuMoment2Controller: _waktuMoment2Zona2Controller,
                ),
              ],
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: _selectedKarakteristik,
                    hint: const Text('Pilih Karakteristik'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedKarakteristik = newValue;
                        _updateKonstanta(newValue!);
                      });
                    },
                    items: _karakteristikValues.keys.map<DropdownMenuItem<String>>((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: settingTile(title: 'Nilai a:', hintText: 'a', controller: _konsAController),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: settingTile(title: 'Nilai b:', hintText: 'b', controller: _konsBController),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: 'Penghantar Zona 1',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            ),
                            controller: TextEditingController(text: _selectedPenghantarZona1 ?? ''),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        settingTile(title: 'Z1&2 R:', hintText: 'Z1&2 R', controller: _zG12RController),
                        const SizedBox(height: 10.0),
                        settingTile(title: 'Z1&2 jX:', hintText: 'Z1&2 jX', controller: _zG12jxController),
                        const SizedBox(height: 10.0),
                        settingTile(title: 'Z0 R:', hintText: 'Z0 R', controller: _zG0RController),
                        const SizedBox(height: 10.0),
                        settingTile(title: 'Z0 jX:', hintText: 'Z0 jX', controller: _zG0jxController),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: 'Penghantar Zona 2',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            ),
                            controller: TextEditingController(text: _selectedPenghantarZona2 ?? ''),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        settingTile(title: 'Z1&2 R:', hintText: 'Z1&2 R', controller: _zJ12RController),
                        const SizedBox(height: 10.0),
                        settingTile(title: 'Z1&2 jX:', hintText: 'Z1&2 jX', controller: _zJ12jxController),
                        const SizedBox(height: 10.0),
                        settingTile(title: 'Z0 R:', hintText: 'Z0 R', controller: _zJ0RController),
                        const SizedBox(height: 10.0),
                        settingTile(title: 'Z0 jX:', hintText: 'Z0 jX', controller: _zJ0jxController),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.tonal(
                  onPressed: () {
                    _hitungSet();
                  },
                  style: FilledButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    minimumSize: const Size(100, 40),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Hitung'),
                ),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: _saveData,
                  style: FilledButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    minimumSize: const Size(100, 40),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Simpan'),
                ),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    minimumSize: const Size(100, 40),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Hapus'),
                ),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: () {_providerGfr();},
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    minimumSize: const Size(100, 40),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Tampilkan'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TabelGrafikGfr(
              hasilPerhitungan: _hasilPerhitungan,
              ),
          ],
        ),
      ),
    );
  }
}