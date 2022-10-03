import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_app/theme.dart';
import 'package:qr_app/view/history_page.dart';
import 'package:qr_app/view/home_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class QRCodeReader extends StatefulWidget {
  const QRCodeReader({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeReaderState();
}

class _QRCodeReaderState extends State<QRCodeReader> {
  final _controller = TextEditingController();
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: _buildQrView(context)),
          if (result != null)
            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: AlertDialog(
                title: Text('QRを認識しました'),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _showBottomSheet();
        },
        tooltip: 'Increment',
        icon: const Icon(Icons.qr_code_2),
        label: const Text("タイトルを付ける"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  // QRコードを読み取る枠の部分
  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 180.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.grey,
          borderRadius: 5,
          borderLength: 15,
          borderWidth: 5,
          cutOutSize: scanArea),
      // onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      onPermissionSet: (ctrl, p) {
        _onPermissionSet(context, ctrl, p);
      },
    );
  }

  _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  _showBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.65,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30, right: 30, left: 30),
              child: TextField(
                controller: _controller,
                maxLength: 20,
                maxLines: 1,
                decoration: InputDecoration(
                  icon: Icon(Icons.title_outlined),
                  hintText: "タイトルを入力",
                  labelText: "タイトル",
                ),
                // obscureText: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 30, left: 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final document = <String, dynamic>{
                      'url': result!.code,
                      'title': _controller.text,
                      'createdAt': Timestamp.fromDate(DateTime.now()),
                    };

                    FirebaseFirestore.instance
                        .collection('QR')
                        .doc()
                        .set(document);

                    if (await launchUrl(Uri.parse('${result!.code}'))) {
                      await Get.to(() => const HomePage());
                    }
                    {
                      throw 'QR読み込みに失敗しました';
                    }
                  },
                  child: Text('サイトを開く'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
