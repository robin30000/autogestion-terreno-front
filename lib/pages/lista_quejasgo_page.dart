import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListQuejasGoPage extends StatefulWidget {
  const ListQuejasGoPage({super.key});

  @override
  State<ListQuejasGoPage> createState() => _ListQuejasGoPageState();
}

class _ListQuejasGoPageState extends State<ListQuejasGoPage> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    final uiProvider = Provider.of<UiProvider>(context);
    final consultaquejasService = Provider.of<ConsultaQuejasService>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: consultaquejasService.isLoading
            ? SizedBox(
                width: mq.width * 1,
                height: mq.height * 0.75,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    color: blueColor,
                  ),
                ),
              )
            : Stack(
                children: [
                  SizedBox(
                    width: mq.height * 0.05,
                    height: mq.height * 0.05,
                    child: IconButton(
                        color: greyColor,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          uiProvider.selectedMenuOpt = 8;
                          uiProvider.selectedMenuName = 'Gestión QuejasGo';
                        },
                        icon: const Icon(Icons.arrow_back_ios_rounded)),
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: mq.height * 0.01,
                            bottom: 0,
                            left: mq.width * 0.10,
                            right: mq.width * 0.10),
                        child: Text(
                          'Estado de mis quejasGo',
                          style: TextStyle(
                            color: blueColor,
                            fontWeight: FontWeight.w500,
                            fontSize: mq.width * 0.06,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomDivider(mq: mq, colors: [
                        whiteColor,
                        blueColor,
                        whiteColor,
                      ]),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: mq.width * 0.01),
                          child: SizedBox(
                            width: mq.width,
                            height: mq.height * 0.75,
                            child: consultaquejasService.quejaslist.isEmpty
                                ? const Center(
                                    child: Text('Sin gestiones para listar'),
                                  )
                                : ListView.separated(
                                    itemCount:
                                        consultaquejasService.quejaslist.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: mq.height * 0.03,
                                      );
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        alignment: Alignment.center,
                                        width: mq.width,
                                        height: mq.height * 0.10,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                                spreadRadius: -6),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          tileColor: whiteColor,
                                          onTap: () {
                                            _showModalBottomSheet(
                                                context,
                                                consultaquejasService
                                                    .quejaslist[index]);
                                          },
                                          leading: Icon(
                                            (consultaquejasService
                                                        .quejaslist[index]
                                                        .en_gestion ==
                                                    '0')
                                                ? Icons.edit_off_outlined
                                                : (consultaquejasService
                                                            .quejaslist[index]
                                                            .en_gestion ==
                                                        '1')
                                                    ? Icons
                                                        .manage_accounts_outlined
                                                    : (consultaquejasService
                                                                .quejaslist[
                                                                    index]
                                                                .en_gestion ==
                                                            '2')
                                                        ? Icons
                                                            .check_circle_outline_rounded
                                                        : Icons.cancel_outlined,
                                            size: mq.width * 0.10,
                                            color: (consultaquejasService
                                                        .quejaslist[index]
                                                        .en_gestion ==
                                                    '0')
                                                ? redColor
                                                : (consultaquejasService
                                                            .quejaslist[index]
                                                            .en_gestion ==
                                                        '1')
                                                    ? blueColor
                                                    : (consultaquejasService
                                                                .quejaslist[
                                                                    index]
                                                                .en_gestion ==
                                                            '2')
                                                        ? greenColor
                                                        : redColor,
                                          ),
                                          title: Text(
                                            consultaquejasService
                                                .quejaslist[index].pedido,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: mq.width * 0.05),
                                          ),
                                          subtitle: Text(
                                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                                .format(consultaquejasService
                                                    .quejaslist[index].fecha),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: mq.width * 0.035),
                                          ),
                                          isThreeLine: true,
                                          trailing: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: mq.width * 0.02),
                                            child: Text(
                                              consultaquejasService
                                                          .quejaslist[index]
                                                          .en_gestion ==
                                                      "0"
                                                  ? 'Sin gestión'
                                                  : consultaquejasService
                                                              .quejaslist[index]
                                                              .en_gestion ==
                                                          "1"
                                                      ? 'En gestión'
                                                      : 'Finalizado',
                                              style: TextStyle(
                                                  color: consultaquejasService
                                                              .quejaslist[index]
                                                              .en_gestion ==
                                                          "0"
                                                      ? greyColor
                                                      : consultaquejasService
                                                                  .quejaslist[
                                                                      index]
                                                                  .en_gestion ==
                                                              "1"
                                                          ? blueColor
                                                          : greenColor,
                                                  fontSize: mq.width * 0.03),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          )),
                    ],
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          authService.getMenuApp();

          final resp = await consultaquejasService.getQuejasGoByUser();
          print('hora $resp');
          if (resp != null) {
            if (resp[0]['type'] == 'errorAuth') {
              final String resp = await authService.logout();

              if (resp == 'OK') {
                uiProvider.selectedMenuOpt = 0;
                uiProvider.selectedMenuName = 'Autogestión Terreno';
                Navigator.pushReplacementNamed(context, 'login');
              }
            }
          }
        },
        backgroundColor: orangeColor,
        child: const Icon(Icons.replay_rounded),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, QUEJASLIST data) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        final mq = MediaQuery.of(context).size;

        return Container(
          height: mq.height * 0.70,
          padding: EdgeInsets.all(mq.width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    splashRadius: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Numero SS:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.pedido)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Acción:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.accion)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gestión:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.gestion_asesor)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Asesor:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.asesor)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Observación asesor:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.observacion_gestion)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Fecha ingreso:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(data.fecha))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Fecha gestion:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(data.fecha_gestion))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Consecutivo respuesta:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.id)
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
