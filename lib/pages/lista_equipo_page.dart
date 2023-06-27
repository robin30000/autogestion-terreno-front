import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListEquipoPage extends StatefulWidget {
  const ListEquipoPage({super.key});

  @override
  State<ListEquipoPage> createState() => _ListEquipoPageState();
}

class _ListEquipoPageState extends State<ListEquipoPage> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    final uiProvider = Provider.of<UiProvider>(context);
    final registroEquipoService = Provider.of<RegistroEquiposService>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: registroEquipoService.isLoading
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
                          uiProvider.selectedMenuOpt = 11;
                          uiProvider.selectedMenuName = 'Registro equipos';
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
                          'Mi registro de equipos',
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
                            child: registroEquipoService.equipos.isEmpty
                                ? const Center(
                                    child: Text('Sin gestiones para listar'),
                                  )
                                : ListView.separated(
                                    itemCount:
                                        registroEquipoService.equipos.length,
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
                                                registroEquipoService
                                                    .equipos[index]);
                                          },
                                          title: Text(
                                            registroEquipoService
                                                .equipos[index].pedido,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: mq.width * 0.05),
                                          ),
                                          subtitle: Text(
                                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                                .format(registroEquipoService
                                                    .equipos[index]
                                                    .fecha_ingreso),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: mq.width * 0.035),
                                          ),
                                          isThreeLine: true,
                                          trailing: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: mq.width * 0.02),
                                            child: Text(
                                              registroEquipoService
                                                          .equipos[index]
                                                          .pedido ==
                                                      "0"
                                                  ? 'Sin gestión'
                                                  : registroEquipoService
                                                              .equipos[index]
                                                              .pedido ==
                                                          "1"
                                                      ? 'En gestión'
                                                      : 'Finalizado',
                                              style: TextStyle(
                                                  color: registroEquipoService
                                                              .equipos[index]
                                                              .pedido ==
                                                          "0"
                                                      ? greyColor
                                                      : registroEquipoService
                                                                  .equipos[
                                                                      index]
                                                                  .pedido ==
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

          final resp = await registroEquipoService.getRegistroEquiposByUser();

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

  void _showModalBottomSheet(BuildContext context, RegistrosEq data) {
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
                    const Text('Pedido:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.pedido)
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
