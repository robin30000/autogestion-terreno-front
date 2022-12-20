import 'package:flutter/material.dart';

class CustomShowDialog {

  static Future<dynamic> alert({required BuildContext context, required String title, required String message}) {
    return showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
}