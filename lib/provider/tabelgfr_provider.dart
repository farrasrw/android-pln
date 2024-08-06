import 'package:flutter/foundation.dart';

class DataGfrProvider with ChangeNotifier {
  double _arusSetZ1 = 0.0;
  double _tmsZ1 = 0.0;
  double _arusM1Z1 = 0.0;
  double _waktuM1Z1 = 0.0;
  double _arusM2Z1 = 0.0;
  double _waktuM2Z1 = 0.0;

  double _arusSetZ2 = 0.0;
  double _tmsZ2 = 0.0;
  double _arusM1Z2 = 0.0;
  double _waktuM1Z2 = 0.0;
  double _arusM2Z2 = 0.0;
  double _waktuM2Z2 = 0.0;
  
  double _panjangZona1 = 0.0;
  double _panjangZona2 = 0.0;
  double _teganganSekunder= 0.0;
  double _impedansiSumber= 0.0;
  double _impedansiTrafo = 0.0;
  double _pentanahan = 0.0;
  double _z0Trafo = 0.0;

  double _zG12R= 0.0;
  double _zG12Jx= 0.0;
  double _zJ12R= 0.0;
  double _zJ12Jx= 0.0;
  double _zG0R= 0.0;
  double _zG0Jx= 0.0;
  double _zJ0R= 0.0;
  double _zJ0Jx= 0.0;
  double _konsA= 0.0;
  double _konsB= 0.0;

  double get arusZ1 => _arusSetZ1;
  double get tmsZ1 => _tmsZ1;
  double get arusM1Z1 => _arusM1Z1;
  double get waktuM1Z1 => _waktuM1Z1;
  double get arusM2Z1 => _arusM2Z1;
  double get waktuM2Z1 => _waktuM2Z1;

  double get arusZ2 => _arusSetZ2;
  double get tmsZ2 => _tmsZ2;
  double get arusM1Z2 => _arusM1Z2;
  double get waktuM1Z2 => _waktuM1Z2;
  double get arusM2Z2 => _arusM2Z2;
  double get waktuM2Z2 => _waktuM2Z2;

  double get panjangZona1 => _panjangZona1;
  double get panjangZona2 => _panjangZona2;
  double get teganganSekunder => _teganganSekunder;
  double get impedansiSumber => _impedansiSumber;
  double get impedansiTrafo => _impedansiTrafo;
  double get pentanahan => _pentanahan;
  double get z0Trafo => _z0Trafo;
  double get zG12R => _zG12R;
  double get zG12Jx => _zG12Jx;
  double get zJ12R => _zJ12R;
  double get zJ12Jx => _zJ12Jx;
  double get zG0R => _zG0R;
  double get zG0Jx => _zG0Jx;
  double get zJ0R => _zJ0R;
  double get zJ0Jx => _zJ0Jx;
  double get konsA => _konsA;
  double get konsB => _konsB;

  void setArusZ1(double value) {
    _arusSetZ1 = value;
    notifyListeners();
  }

  void setTmsZ1(double value) {
    _tmsZ1 = value;
    notifyListeners();
  }

  void setArusM1Z1(double value) {
    _arusM1Z1 = value;
    notifyListeners();
  }

  void setWaktuM1Z1(double value) {
    _waktuM1Z1 = value;
    notifyListeners();
  }

  void setArusM2Z1(double value) {
    _arusM2Z1 = value;
    notifyListeners();
  }

  void setWaktuM2Z1(double value) {
    _waktuM2Z1 = value;
    notifyListeners();
  }

  void setArusZ2(double value) {
    _arusSetZ2 = value;
    notifyListeners();
  }

  void setTmsZ2(double value) {
    _tmsZ2 = value;
    notifyListeners();
  }
  
  void setArusM1Z2(double value) {
    _arusM1Z2 = value;
    notifyListeners();
  }

  void setWaktuM1Z2(double value) {
    _waktuM1Z2 = value;
    notifyListeners();
  }

  void setArusM2Z2(double value) {
    _arusM2Z2 = value;
    notifyListeners();
  }

  void setWaktuM2Z2(double value) {
    _waktuM2Z2 = value;
    notifyListeners();
  }

  void setPanjangZona1(double value) {
    _panjangZona1 = value;
    notifyListeners();
  }

  void setPanjangZona2(double value) {
    _panjangZona2 = value;
    notifyListeners();
  }

  void setVsekunder(double value) {
    _teganganSekunder = value;
    notifyListeners();
  }

  void setPentanahan(double value) {
    _pentanahan = value;
    notifyListeners();
  }
  void setZ0Trafo(double value) {
    _z0Trafo = value;
    notifyListeners();
  }
  //Impedansi
  void setZsumber(double value) {
    _impedansiSumber = value;
    notifyListeners();
  }

  void setZtrafo(double value) {
    _impedansiTrafo = value;
    notifyListeners();
  }

  void setZG12r(double value) {
    _zG12R = value;
    notifyListeners();
  }

  void setZG12jx(double value) {
    _zG12Jx = value;
    notifyListeners();
  }

  void setZJ12r(double value) {
    _zJ12R = value;
    notifyListeners();
  }

  void setZJ12jx(double value) {
    _zJ12Jx = value;
    notifyListeners();
  }

  void setZG0r(double value) {
    _zG0R = value;
    notifyListeners();
  }

  void setZG0jx(double value) {
    _zG0Jx = value;
    notifyListeners();
  }

  void setZJ0r(double value) {
    _zJ0R = value;
    notifyListeners();
  }

  void setZJ0jx(double value) {
    _zJ0Jx = value;
    notifyListeners();
  }

  void setA(double value) {
    _konsA = value;
    notifyListeners();
  }

  void setB(double value) {
    _konsB = value;
    notifyListeners();
  }
}