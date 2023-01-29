import '../model/orders_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'pdf_api.dart';

class PdfReportApi {
  static Future generate(OrdersModel order) async {
    final pdf = Document();

    // final font = await rootBundle.load("fonts/Roboto-Regular.ttf");
    // final bfont = await rootBundle.load("fonts/Roboto-Bold.ttf");
    // final ttf = Font.ttf(font);
    // final bttf = Font.ttf(bfont);

    // final logo = MemoryImage(
    //   (await rootBundle.load(klogowhite)).buffer.asUint8List(),
    // );

    // final sidebg = MemoryImage(
    //   (await rootBundle.load(ksideBg)).buffer.asUint8List(),
    // );

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
        build: (context) => [
          Text(
            'Brandiamv',
            style: TextStyle(
              fontSize: 20,
              color: PdfColors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.5 * PdfPageFormat.cm),
          Table(
            border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(5),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(3),
            },
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "#",
                      style: TextStyle(
                        // font: bttf,
                        color: PdfColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Name",
                      style: TextStyle(
                        // font: bttf,
                        color: PdfColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Quantity",
                      style: TextStyle(
                        // font: bttf,
                        color: PdfColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Price/Unit",
                      style: TextStyle(
                        // font: bttf,
                        color: PdfColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Amount",
                      style: TextStyle(
                        // font: bttf,
                        color: PdfColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              for (int i = 0; i < order.products.length; i++)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        (i + 1).toString(),
                        style: const TextStyle(
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        order.products[i]['name'],
                        style: const TextStyle(
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        (order.products[i]['quantity']).toString(),
                        style: const TextStyle(
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        (order.products[i]['price']).toString(),
                        style: const TextStyle(
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        (order.products[i]['price'] * order.products[i]['quantity']).toString(),
                        style: const TextStyle(
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 1.5 * PdfPageFormat.cm),
        ],
      ),
    );

    return PdfApi.saveDocument(name: order.id, pdf: pdf, order: order);
  }
}
