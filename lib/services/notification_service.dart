

import 'package:flutter/material.dart';
import 'package:autogestion_tecnico/global/globals.dart';

class NotificactionService {

  static late GlobalKey<ScaffoldMessengerState> messagerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar( String message ) {

    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontFamily: "OpenSans", color: whiteColor, fontSize: 15),
        textAlign: TextAlign.center,
      )
    );

    messagerKey.currentState!.showSnackBar(snackBar);

  }

  static showSnackBarPush( Map message, navigatorKey ) {

    final materialBanner = MaterialBanner(
      backgroundColor: whiteColor,
      padding: const EdgeInsets.only(top: 25.0, left: 10, right: 10),
      actions: [
        TextButton(
          child: Text('OK', style: TextStyle(color: blueColor)),
          onPressed: (){
            messagerKey.currentState!.hideCurrentMaterialBanner();
          },
        ),
      ],
      leading: const Icon(Icons.message_rounded),
      contentTextStyle: TextStyle(color: blueColor),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notificacion',
            style: TextStyle(fontFamily: "OpenSans", color: blueColor, fontSize: 17),
            textAlign: TextAlign.center,
          ),
          Text(
            'Atención en el proceso: ${message['data']['proceso']}',
            style: TextStyle(fontFamily: "OpenSans", color: blueColor, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ), 
    );

    messagerKey.currentState!..removeCurrentMaterialBanner()..showMaterialBanner(materialBanner);

  }
}