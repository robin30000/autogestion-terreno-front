import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListSoporteEtpPage extends StatefulWidget {
  const ListSoporteEtpPage({super.key});

  @override
  State<ListSoporteEtpPage> createState() => _ListSoporteEtpPageState();
}

class _ListSoporteEtpPageState extends State<ListSoporteEtpPage> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    final uiProvider = Provider.of<UiProvider>(context);
    final soporteEtpService = Provider.of<SoporteEtpService>(context);

    final authServices = Provider.of<AuthService>(context, listen: false);
    authServices.getMenuApp();

    return Scaffold(
      body: SingleChildScrollView(
        child: soporteEtpService.isLoading
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
                          uiProvider.selectedMenuOpt = 13;
                          uiProvider.selectedMenuName = 'Soporte ETP';
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
                          'Estado de soporte ETP',
                          style: TextStyle(
                            color: blueColor,
                            fontWeight: FontWeight.w500,
                            fontSize: mq.width * 0.06,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      /* Padding(
                  padding: EdgeInsets.only(left: mq.width * 0.05, right: mq.width * 0.05, top: mq.height * 0.02),
                  child: CustomButton(
                    text: 'Fecha: ${uiProvider.dateButton}',
                    mq: mq,
                    height: 0.04,
                    fontSize: 0.02,
                    function: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2017),
                        lastDate: DateTime(2222),
                      ).then((date) {
                        uiProvider.dateButton = DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
                      });
                    }, 
                    color: greyColor, 
                    colorText: whiteColor, 
                  ),
                ), */

                      CustomDivider(mq: mq, colors: [
                        whiteColor,
                        blueColor,
                        whiteColor,
                      ]),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: mq.width * 0.05),
                        child: SizedBox(
                          width: mq.width,
                          height: mq.height * 0.75,
                          child: soporteEtpService.soporteetp.isEmpty
                              ? const Center(
                                  child: Text('Sin gestiones para listar'),
                                )
                              : ListView.separated(
                                  itemCount:
                                      soporteEtpService.soporteetp.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: mq.height * 0.03,
                                    );
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
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
                                              soporteEtpService
                                                  .soporteetp[index]);
                                        },
                                        leading: Icon(
                                          /* (soporteEtpService.soporteetp[index]
                                                      .statusSoporte ==
                                                  null)
                                              ? null
                                              : (soporteEtpService
                                                              .soporteetp[index]
                                                              .statusSoporte ==
                                                          'Finalizado' &&
                                                      soporteEtpService
                                                              .soporteetp[index]
                                                              .respuestaSoporte ==
                                                          'Finalizado')
                                                  ? Icons
                                                      .check_circle_outline_rounded
                                                  : Icons.cancel_outlined, */
                                          (soporteEtpService.soporteetp[index]
                                                          .statusSoporte ==
                                                      'Finalizado' &&
                                                  soporteEtpService
                                                          .soporteetp[index]
                                                          .respuestaSoporte ==
                                                      'Finalizado')
                                              ? Icons
                                                  .check_circle_outline_rounded
                                              : (soporteEtpService
                                                              .soporteetp[index]
                                                              .statusSoporte ==
                                                          'Finalizado' &&
                                                      soporteEtpService
                                                              .soporteetp[index]
                                                              .respuestaSoporte !=
                                                          'Finalizado')
                                                  ? Icons
                                                      .check_circle_outline_rounded
                                                  : (soporteEtpService
                                                              .soporteetp[index]
                                                              .statusSoporte ==
                                                          'Sin gestion')
                                                      ? Icons.cancel_outlined
                                                      : Icons
                                                          .check_circle_outline_rounded,
                                          size: mq.width * 0.10,
                                          color: (soporteEtpService
                                                          .soporteetp[index]
                                                          .statusSoporte ==
                                                      'Finalizado' &&
                                                  soporteEtpService
                                                          .soporteetp[index]
                                                          .respuestaSoporte ==
                                                      'Finalizado')
                                              ? greenColor
                                              : redColor,
                                          /* color: (soporteEtpService
                                                          .soporteetp[index]
                                                          .statusSoporte ==
                                                      'Finalizado' &&
                                                  soporteEtpService
                                                          .soporteetp[index]
                                                          .respuestaSoporte !=
                                                      'Finalizado')
                                              ? greenColor
                                              : redColor, */
                                          /* shadows: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 3,
                                  offset: Offset(3, 3),
                                ),
                              ], */
                                        ),
                                        title: Text(
                                          soporteEtpService
                                              .soporteetp[index].tarea,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: mq.width * 0.05),
                                        ),
                                        subtitle: Text(
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(soporteEtpService
                                                  .soporteetp[index]
                                                  .fechaSolicitudFirebase),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: mq.width * 0.035),
                                        ),
                                        isThreeLine: true,
                                        trailing: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: mq.width * 0.02),
                                          /* decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 3,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                                color: soportegponService.soportegpon[index].finalizado == null ? greyColor : blueColor,
                                borderRadius: BorderRadius.circular(30)
                              ), */
                                          child: Text(
                                            soporteEtpService.soporteetp[index]
                                                        .statusSoporte ==
                                                    'Finalizado'
                                                ? 'Finalizado'
                                                : 'Sin Gestión',
                                            style: TextStyle(
                                                color: soporteEtpService
                                                            .soporteetp[index]
                                                            .statusSoporte ==
                                                        'En gestion'
                                                    ? greyColor
                                                    : blueColor,
                                                fontSize: mq.width * 0.03),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () async {
          final authService = Provider.of<AuthService>(context, listen: false);

          final resp = await soporteEtpService.getsoporteetpbyuser();

          if (resp!.isNotEmpty) {
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

  void _showModalBottomSheet(BuildContext context, SoporteEtp data) {
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
                    const Text('Tarea:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.tarea)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pedido:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.unepedido)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Categoría:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.tasktypecategory)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tipificación:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text((data.statusSoporte == null) ? '' : data.statusSoporte)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Fecha Solicitud:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(data.fechaSolicitudFirebase))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Fecha Respuesta:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text((data.fechaRespuesta == '')
                        ? ''
                        : DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(data.fechaRespuesta))
                  ],
                ),
                SizedBox(
                  height: mq.height * 0.03,
                ),
                const Text('Observación Terreno:',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(data.observacionTerreno, textAlign: TextAlign.justify),
                SizedBox(
                  height: mq.height * 0.03,
                ),
                const Text('Observación Despacho:',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(data.observacion ?? '', textAlign: TextAlign.justify),
              ],
            ),
          ),
        );
      },
    );
  }
}
