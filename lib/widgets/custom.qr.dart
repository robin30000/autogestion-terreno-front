import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  QRViewController? controller;
  String qrText = '';
  bool isCodeDetected = false;
  Color borderColor = const Color.fromARGB(255, 180, 81, 72); // Border color

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void restartCamera() {
    setState(() {
      qrText = '';
      isCodeDetected = false;
    });
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    var borderColor =
        isCodeDetected ? Colors.green : const Color.fromARGB(255, 180, 81, 72);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                      borderColor: borderColor,
                      borderRadius: 0,
                      borderLength: 30,
                      borderWidth: 5,
                      // cutOutSize: scanArea,
                      cutOutHeight: 40,
                      cutOutWidth: 250),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150), // Agregamos un espacio horizontal
                    child: const Divider(
                        height: 1,
                        thickness: 2,
                        color: Color.fromARGB(255, 180, 81, 72)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Código: $qrText'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (qrText.isNotEmpty) {
                        /* final snackBar = SnackBar(
                          content:
                              Text('Código $qrText copiado al portapapeles'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar); */
                        Clipboard.setData(ClipboardData(text: qrText));
                      }
                    },
                    child: const Text('Copiar Código'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code!;
        isCodeDetected = true; // Set the flag when code is detected
        //Clipboard.setData(ClipboardData(text: qrText));
      });
    });
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: qrText));
    //Clipboard.setData(ClipboardData(text: text));
    /* const snackBar = SnackBar(
      content: Text('Código copiado al portapapeles'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); */
  }
}
