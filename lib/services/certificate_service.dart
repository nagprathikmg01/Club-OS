import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/app_user.dart';

class CertificateService {
  static Future<void> generateAndPrint(AppUser user, String clubName) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(40),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.amber, width: 5),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('CERTIFICATE OF MERIT', style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey900)),
                pw.SizedBox(height: 20),
                pw.Text('THIS IS TO CERTIFY THAT', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text(user.name.toUpperCase(), style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold, color: PdfColors.blueAccent)),
                pw.SizedBox(height: 10),
                pw.Text('HAS SUCCESSFULLY ACHIEVED', style: const pw.TextStyle(fontSize: 14)),
                pw.SizedBox(height: 10),
                pw.Text('ELITE LEVEL ${user.level}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.amber700)),
                pw.SizedBox(height: 20),
                pw.Text('IN RECOGNITION OF OUTSTANDING CONTRIBUTION TO', style: const pw.TextStyle(fontSize: 12)),
                pw.Text(clubName.toUpperCase(), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Spacer(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [pw.SizedBox(width: 100, child: pw.Divider(color: PdfColors.black)), pw.Text('NEBULA COMMAND')]),
                    pw.Column(children: [pw.SizedBox(width: 100, child: pw.Divider(color: PdfColors.black)), pw.Text('DATE: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}')]),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
