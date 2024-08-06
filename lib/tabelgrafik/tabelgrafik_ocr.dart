import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import '../provider/tabelocr_provider.dart';
import 'dart:math';

class TabelGrafikOcr extends StatelessWidget {
  final double hasilPerhitungan;

  const TabelGrafikOcr({
    super.key,
    required this.hasilPerhitungan,
  });
  
  @override
  Widget build(BuildContext context) {
    final dataOcrProvider = Provider.of<DataOcrProvider>(context);
    final double iZ1 = dataOcrProvider.arusZ1;
    final double tmsZ1 = dataOcrProvider.tmsZ1;
    final double im1Z1 = dataOcrProvider.arusM1Z1;
    final double tm1Z1 = dataOcrProvider.waktuM1Z1;
    final double im2Z1 = dataOcrProvider.arusM2Z1;
    final double tm2Z1 = dataOcrProvider.waktuM2Z1;
    final double iZ2 = dataOcrProvider.arusZ2;
    final double tmsZ2 = dataOcrProvider.tmsZ2;
    final double im1Z2 = dataOcrProvider.arusM1Z2;
    final double tm1Z2 = dataOcrProvider.waktuM1Z2;
    final double im2Z2 = dataOcrProvider.arusM2Z2;
    final double tm2Z2 = dataOcrProvider.waktuM2Z2;
    final double pZona1 = dataOcrProvider.panjangZona1;
    final double pZona2 = dataOcrProvider.panjangZona2;
    final double vS = dataOcrProvider.teganganSekunder;
    final double zS= dataOcrProvider.impedansiSumber;
    final double zT= dataOcrProvider.impedansiTrafo;
    final double zG1R= dataOcrProvider.zG12R;
    final double zG1Jx= dataOcrProvider.zG12Jx;
    final double zJ1R= dataOcrProvider.zJ12R;
    final double zJ1Jx= dataOcrProvider.zJ12Jx;
    final double a = dataOcrProvider.konsA;
    final double b = dataOcrProvider.konsB;
    
    // Data untuk grafik
    List<ChartData> chartDatatZ1if1 = [];
    List<ChartData> chartDatatZ1if2 = [];
    List<ChartData> chartDataZ2 = [];
    List<DataRow> dataRows = [];
    for (int i = 100; i >= 5; i -= 5){
      double pz1 = pZona1 * i / 100;
      double pz2 = pZona2 * i / 100;

      double z1Req = ((pz1 * zG1R) * (pz1 * zG1R));
      double z1Jeq = ((zS + zT + (pz1 * zG1Jx)) * (zS + zT + (pz1 * zG1Jx)));
      double z1eq = z1Req + z1Jeq;
      double ifZ1 = (vS / sqrt(3)) / sqrt(z1eq);

      double z2Req = (((pz2 * zJ1R) + (pZona1*zG1R)) * ((pz2 * zJ1R) + (pZona1*zG1R)));
      double z2Jeq = ((zS + zT + ((pz2 * zJ1Jx) + (pZona1 * zG1Jx))) * (zS + zT + ((pz2 * zJ1Jx) + (pZona1 * zG1Jx))));
      double z2eq = z2Req + z2Jeq;
      double ifZ2 = (vS / sqrt(3)) / sqrt(z2eq);
      
      double tZ1if1;
      if(ifZ1 >= iZ1 && ifZ1 <= im1Z1){
        tZ1if1 = (b * tmsZ1) / ((pow((ifZ1 / iZ1),a)-1));
      } else if (ifZ1 > im1Z1 && ifZ1 <= im2Z1){
        tZ1if1 = tm1Z1;
      } else if (ifZ1 > im2Z1){
        tZ1if1 = tm2Z1;
      } else {
        tZ1if1 = 0;
      }

      double tZ1if2;
      if(ifZ2 >= iZ1 && ifZ2 <= im1Z1){
        tZ1if2 = (b * tmsZ1) / ((pow((ifZ2 / iZ1),a)-1));
      } else if (ifZ2 > im1Z1 && ifZ2 <= im2Z1){
        tZ1if2 = tm1Z1;
      } else if (ifZ2 > im2Z1){
        tZ1if2 = tm2Z1;
      } else {
        tZ1if2 = 0;
      }
      
      double tZ2;
      if(ifZ2 >= iZ2 && ifZ2 <= im1Z2){
        tZ2 = (b * tmsZ2) / (pow((ifZ2 / iZ2),a)- 1);
      } else if (ifZ2 > im1Z2 && ifZ2 <= im2Z2){
        tZ2 = tm1Z2;
      } else if (ifZ2 > im2Z2){
        tZ2 = tm2Z2;
      } else {
        tZ2 = 0;
      }

      chartDatatZ1if1.add(ChartData(x: ifZ1, y: tZ1if1));
      chartDatatZ1if2.add(ChartData(x: ifZ2, y: tZ1if2));
      chartDataZ2.add(ChartData(x: ifZ2, y: tZ2));

      dataRows.add(
        DataRow(cells: [
          DataCell(Text('$i%')),
          DataCell(Text('${(pz1).toStringAsFixed(2)}km')),
          DataCell(Text('${(pz2).toStringAsFixed(2)}km')),
          DataCell(Text('${(ifZ1).toStringAsFixed(0)}A')),
          DataCell(Text('${(ifZ2).toStringAsFixed(0)}A')),
          DataCell(Text('${(tZ1if1).toStringAsFixed(4)}s')),
          DataCell(Text('${(tZ1if2).toStringAsFixed(4)}s')),
          DataCell(Text('${(tZ2).toStringAsFixed(4)}s')),
        ]),
      );
    }

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 1),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Persentase')),
                DataColumn(label: Text('Zona1(Km)')),
                DataColumn(label: Text('Zona2(Km)')),
                DataColumn(label: Text('If3(Zona1)')),
                DataColumn(label: Text('If3(Zona2)')),
                DataColumn(label: Text('t(Zona1)-if1')),
                DataColumn(label: Text('t(Zona1)-if2')),
                DataColumn(label: Text('t(Zona2)')),
              ],
              rows: dataRows,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 400,
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfCartesianChart(
                  primaryXAxis: const NumericAxis(
                    title: AxisTitle(
                      text: 'If (A)',
                    ),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                  ),
                  primaryYAxis: const NumericAxis(
                    title: AxisTitle(
                      text: 't (s)',
                    ),
                  ),
                  series: <CartesianSeries>[
                    // Garis pertama untuk waktu Zona 1 dengan arus gangguan Zona 1
                    LineSeries<ChartData, double>(
                      dataSource: chartDatatZ1if1,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Zona 1',
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                      ),
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                      color: Colors.blue,
                    ),
                    // Garis pertama untuk waktu Zona 1 dengan arus gangguan Zona 2
                    LineSeries<ChartData, double>(
                      dataSource: chartDatatZ1if2,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Zona 1',
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                      ),
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                      color: Colors.blue,
                    ),
                    // Garis kedua untuk Zona 2
                    LineSeries<ChartData, double>(
                      dataSource: chartDataZ2,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Zona 2',
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                      ),
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                      color: Colors.red,
                    ),
                  ],
                  legend: const Legend(isVisible: true, position: LegendPosition.bottom),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  final double x;
  final double y;

  ChartData({required this.x, required this.y});
}