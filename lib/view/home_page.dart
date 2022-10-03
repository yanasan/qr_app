import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_app/services/theme_service.dart';
import 'package:qr_app/theme.dart';
import 'package:qr_app/view/barcode.dart';
import 'package:qr_app/view/history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          _TitleText(),
          const SizedBox(
            height: 150,
          ),
          _QRPageButton(
            'QR認識',
            Icons.qr_code_2_outlined,
          ),
          const SizedBox(
            height: 100,
          ),
          _HistoryPageButton(
            '履歴',
            Icons.library_books_outlined,
          ),
        ],
      ),
    );
  }

  _QRPageButton(String title, icon) {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => const QRCodeReader());
      },
      child: Container(
        margin: const EdgeInsets.only(right: 30, left: 30),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.green[400],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(width: 30),
            Text(
              title,
              style: GoogleFonts.rampartOne(
                fontSize: 30,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _HistoryPageButton(String title, icon) {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => HistoryPage());
      },
      child: Container(
        margin: const EdgeInsets.only(right: 30, left: 30),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.green[400],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(width: 30),
            Text(
              title,
              // style: const TextStyle(
              //   fontSize: 30,
              //   color: Colors.white,
              // ),
              style: GoogleFonts.rampartOne(
                fontSize: 30,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _TitleText() {
    return Text(
      'QR認識アプリ',
      style: GoogleFonts.rampartOne(
        fontSize: 42,
        color: Colors.black,
      ),
    );
  }
}
