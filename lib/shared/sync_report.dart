import 'package:brandiamv/model/orders_model.dart';
import 'package:brandiamv/shared/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

Future<void> generatePDF(OrdersModel order) async {
  String? url;
  String firebasePath = 'orders/${order.id}.pdf';
  //Create a PDF document.
  final PdfDocument document = PdfDocument();
  //Add page to the PDF
  final PdfPage page = document.pages.add();
  //Get page client size
  final Size pageSize = page.getClientSize();
  //Draw rectangle
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
      pen: PdfPen(PdfColor(142, 170, 219)));
  //Generate PDF grid.
  final PdfGrid grid = getGrid(order);
  //Draw the header section by creating text element
  final PdfLayoutResult result = drawHeader(page, pageSize, grid, order);
  //Draw grid
  drawGrid(page, grid, result, order);
  //Add invoice footer
  _drawFooter(page, pageSize);
  //Save and dispose the document.
  final List<int> bytes = await document.save();
  document.dispose();
  //Launch file.
  //await FileSaveHelper.saveAndLaunchFile(bytes, 'Invoice.pdf');

  Uint8List u8Byte = Uint8List.fromList(bytes);

  try {
    await FirebaseStorage.instance.ref(firebasePath).putData(u8Byte).then((taskSnapshot) async {
      if (taskSnapshot.state == TaskState.success) {
        url = await FirebaseStorage.instance.ref(firebasePath).getDownloadURL();
      }
    });
  } catch (error) {
    errorSnackbar('Database Connection Error', '$error');
  }

  url = await firebase_storage.FirebaseStorage.instance.ref(firebasePath).getDownloadURL();

  final path = 'orders/${order.id}';
  final ref = FirebaseFirestore.instance.doc(path);
  await ref.update({
    'pdf': url,
  });

  await Clipboard.setData(ClipboardData(text: url));

  // final Uri whatsappURL = Uri.parse('https://wa.me/${order.phone}');
  // if (!await launchUrl(whatsappURL)) {
  //   throw 'Could not launch $whatsappURL';
  // }
  Share.share(url!);
}

//Draws the invoice header
PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid, OrdersModel order) {
  //Draw rectangle
  page.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(91, 126, 215)),
      bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
  //Draw string
  page.graphics.drawString('BRANDIAMV', PdfStandardFont(PdfFontFamily.helvetica, 15),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
      brush: PdfSolidBrush(PdfColor(65, 104, 205)));
  page.graphics.drawString(
      r'RF' + getTotalAmount(order).toString(), PdfStandardFont(PdfFontFamily.helvetica, 18),
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
      brush: PdfBrushes.white,
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle));
  final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
  //Draw string
  page.graphics.drawString('Amount', contentFont,
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.bottom));
  //Create data foramt and convert it to text.
  final DateFormat format = DateFormat.yMMMMd('en_US');
  final String invoiceNumber =
      'Invoice Number: ${order.id}\r\n\r\nDate: ${format.format(DateTime.now())}';
  final Size contentSize = contentFont.measureString(invoiceNumber);
  String address =
      'Bill To: \r\n\r\n ${order.name}, \r\n\r\n${order.atoll}, ${order.island}, \r\n\r\n${order.phone}';
  PdfTextElement(text: invoiceNumber, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120, contentSize.width + 30,
          pageSize.height - 120));
  return PdfTextElement(text: address, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(
          30, 120, pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
}

//Draws the grid
void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result, OrdersModel order) {
  Rect? totalPriceCellBounds;
  Rect? quantityCellBounds;
  //Invoke the beginCellLayout event.
  grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
    final PdfGrid grid = sender as PdfGrid;
    if (args.cellIndex == grid.columns.count - 1) {
      totalPriceCellBounds = args.bounds;
    } else if (args.cellIndex == grid.columns.count - 2) {
      quantityCellBounds = args.bounds;
    }
  };
  //Draw the PDF grid and get the result.
  result = grid.draw(page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
  //Draw grand total.
  page.graphics.drawString(
      'Grand Total', PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(quantityCellBounds!.left, result.bounds.bottom + 10,
          quantityCellBounds!.width, quantityCellBounds!.height));
  page.graphics.drawString(getTotalAmount(order).toString(),
      PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(totalPriceCellBounds!.left, result.bounds.bottom + 10,
          totalPriceCellBounds!.width, totalPriceCellBounds!.height));
}

//Draw the invoice footer data.
void _drawFooter(PdfPage page, Size pageSize) {
  final PdfPen linePen = PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
  linePen.dashPattern = <double>[3, 3];
  //Draw line
  page.graphics.drawLine(
      linePen, Offset(0, pageSize.height - 100), Offset(pageSize.width, pageSize.height - 100));
  const String footerContent =
      "Bank Name: BML (MVR)\r\n\r\nBank Account No: 7770000095245\r\n\r\nAccount Holder's Name: BRANDIA";
  //Added 30 as a margin for the layout
  page.graphics.drawString(footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
}

//Create PDF grid and return
PdfGrid getGrid(OrdersModel order) {
  //Create a PDF grid
  final PdfGrid grid = PdfGrid();
  //Secify the columns count to the grid.
  grid.columns.add(count: 5);
  //Create the header row of the grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  //Set style
  headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
  headerRow.style.textBrush = PdfBrushes.white;
  headerRow.cells[0].value = '#';
  headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
  headerRow.cells[1].value = 'Item name';
  headerRow.cells[2].value = 'Quantity';
  headerRow.cells[3].value = 'Price/unit';
  headerRow.cells[4].value = 'Amount';

  for (var i = 0; i < order.products.length; i++) {
    addProducts(
        '${i + 1}',
        order.products[i]['name'],
        order.products[i]['quantity'],
        order.products[i]['price'],
        (order.products[i]['quantity'] * order.products[i]['price']),
        grid);
  }

  grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
  grid.columns[1].width = 200;
  for (int i = 0; i < headerRow.cells.count; i++) {
    headerRow.cells[i].style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
  }
  for (int i = 0; i < grid.rows.count; i++) {
    final PdfGridRow row = grid.rows[i];
    for (int j = 0; j < row.cells.count; j++) {
      final PdfGridCell cell = row.cells[j];
      if (j == 0) {
        cell.stringFormat.alignment = PdfTextAlignment.center;
      }
      cell.style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
  }
  return grid;
}

//Create and row for the grid.
void addProducts(
    String productId, String productName, double price, int quantity, double total, PdfGrid grid) {
  final PdfGridRow row = grid.rows.add();
  row.cells[0].value = productId;
  row.cells[1].value = productName;
  row.cells[2].value = price.toString();
  row.cells[3].value = quantity.toString();
  row.cells[4].value = total.toString();
}

//Get the total amount.
double getTotalAmount(OrdersModel order) {
  double total = 0;
  for (int i = 0; i < order.products.length; i++) {
    total += (order.products[i]['price'] * order.products[i]['quantity']);
  }
  return total;
}

///Dart imports

// ignore: avoid_classes_with_only_static_members
///To save the pdf file in the device
class FileSaveHelper {
  ///To save the pdf file in the device
  static Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    AnchorElement(
        href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', fileName)
      ..click();
  }
}
