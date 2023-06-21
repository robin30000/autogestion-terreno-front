import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;
  String qrText = '';

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void restartCamera() {
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    var colores = const Color.fromARGB(255, 180, 81, 72);

    return Scaffold(
        appBar: AppBar(
          title: const Text('QR Code Scanner'),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: colores,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: scanArea),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text('Código: $qrText'),
              ),
            ),
          ],
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton.small(
            onPressed: () {
              setState(() {
                qrText = '';
                restartCamera();
              });
            },
            backgroundColor: const Color.fromARGB(255, 0, 51, 94),
            child: const Icon(Icons.refresh_outlined),
          ),
        ]));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code!;
        Clipboard.setData(ClipboardData(text: scanData.code));
      });
    });
  }

/*   void restartCamera() {
    if (controller != null) {
      controller.resumeCamera();
    }
  } */

}
