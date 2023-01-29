import 'dart:io';

import 'package:brandiamv/model/orders_model.dart';
import 'package:brandiamv/shared/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:share_plus/share_plus.dart';

class PdfApi {
  static Future saveDocument({
    required String name,
    required Document pdf,
    required OrdersModel order,
  }) async {
    String? url;
    String firebasePath = 'orders/$name.pdf';
    final bytes = await pdf.save();

    try {
      await FirebaseStorage.instance.ref(firebasePath).putData(bytes).then((taskSnapshot) async {
        if (taskSnapshot.state == TaskState.success) {
          url = await FirebaseStorage.instance.ref(firebasePath).getDownloadURL();
        }
      });
    } catch (error) {
      errorSnackbar('Database Connection Error', '$error');
    }

    url = await firebase_storage.FirebaseStorage.instance.ref(firebasePath).getDownloadURL();

    final path = 'orders/$name';
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

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
