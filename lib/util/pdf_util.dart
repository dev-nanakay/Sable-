import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfUtil {
  static PdfPageFormat PAGE_FORMAT = PdfPageFormat.a4;

  static pw.Document generatePDF(String text) {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PAGE_FORMAT,
        build: (pw.Context context) {
          return pw.Center(child: pw.Text(text));
        }));
    return pdf;
  }
}
