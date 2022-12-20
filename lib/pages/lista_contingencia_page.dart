import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:autogestion_tecnico/global/globals.dart';

class ListContingenciaPage extends StatefulWidget {
  const ListContingenciaPage({super.key});

  @override
  State<ListContingenciaPage> createState() => _ListContingenciaPageState();
}

class _ListContingenciaPageState extends State<ListContingenciaPage> {

  @override
  Widget build(BuildContext context) {

    final mq = MediaQuery.of(context).size;

    final uiProvider = Provider.of<UiProvider>(context);
    final contingenciasService = Provider.of<ContingenciaService>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: contingenciasService.isLoading ?
        SizedBox(
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
                  uiProvider.selectedMenuOpt = 1;
                  uiProvider.selectedMenuName = 'Contingencias';
                }, 
                icon: const Icon(Icons.arrow_back_ios_rounded)
              ),
            ),

            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: mq.height * 0.01, bottom: 0, left: mq.width * 0.10, right: mq.width * 0.10),
                  child: Text(
                    'Estado de contingencias',
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

                CustomDivider(mq: mq, colors: [whiteColor,blueColor,whiteColor,]),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
                  child: SizedBox(
                    width: mq.width,
                    height: mq.height * 0.75,
                    child:contingenciasService.contingencias.isEmpty 
                    ? const Center(
                      child: Text('Sin gestiones para listar'),
                    )
                    : ListView.separated(
                      itemCount: contingenciasService.contingencias.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: mq.height * 0.03,);
                      },
                      itemBuilder: (BuildContext context, int index) {
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
                                spreadRadius: -6
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                            ),
                            tileColor: whiteColor,
                            onTap: () {
                              _showModalBottomSheet(context, contingenciasService.contingencias[index]);
                            },
                            leading: Icon(
                              (contingenciasService.contingencias[index].engestion == '0' && contingenciasService.contingencias[index].finalizado == null) ? null :
                              (contingenciasService.contingencias[index].engestion == '1' && contingenciasService.contingencias[index].finalizado == null) ? Icons.manage_accounts_outlined : 
                              (contingenciasService.contingencias[index].engestion == '1' && contingenciasService.contingencias[index].finalizado != null && contingenciasService.contingencias[index].acepta == 'Acepta') ? Icons.check_circle_outline_rounded : 
                              Icons.cancel_outlined,
                              
                              size: mq.width*0.10,
                              color: (contingenciasService.contingencias[index].engestion == '0' && contingenciasService.contingencias[index].finalizado == null) ? null :
                              (contingenciasService.contingencias[index].engestion == '1' && contingenciasService.contingencias[index].finalizado == null) ? blueColor : 
                              (contingenciasService.contingencias[index].engestion == '1' && contingenciasService.contingencias[index].finalizado != null && contingenciasService.contingencias[index].acepta == 'Acepta') ? greenColor : 
                              redColor,
                              /* shadows: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 3,
                                  offset: Offset(3, 3),
                                ),
                              ], */
                            ),
                            title: Text(
                              contingenciasService.contingencias[index].pedido,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: mq.width * 0.05
                              ),
                            ),
                            subtitle: Text(
                              DateFormat('yyyy-MM-dd HH:mm:ss').format(contingenciasService.contingencias[index].horagestion),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: mq.width * 0.035
                              ),
                            ),
                            isThreeLine: true,
                            trailing: Container(
                              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.02),
                              /* decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 3,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                                color: contingenciasService.contingencias[index].finalizado == null ? greyColor : blueColor,
                                borderRadius: BorderRadius.circular(30)
                              ), */
                              child: Text(
                                contingenciasService.contingencias[index].finalizado == null ? 'Pendiente' : 'Atendido',
                                style: TextStyle(
                                  color: contingenciasService.contingencias[index].finalizado == null ? greyColor : blueColor,
                                  fontSize: mq.width * 0.03
                                ),
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

          authService.getMenuApp();
          
          final resp = await contingenciasService.getContingenciasByUser();

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

  void _showModalBottomSheet(BuildContext context, Contingencia data) {
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
                    const Text('Acción:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.accion)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pedido:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.pedido)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Producto:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.producto)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tipificación:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text((data.tipificacion == null) ? '' : (data.tipificacion == 'Ok') ? 'Finalizado' : 'Rechazado')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Fecha Solicitud:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(data.horagestion))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Fecha Respuesta:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text((data.horacontingencia == '') ? '' : DateFormat('yyyy-MM-dd HH:mm:ss').format(data.horacontingencia))
                  ],
                ),

                SizedBox(height: mq.height * 0.03,),
          
                const Text('Observación Terreno:', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(data.observacion, textAlign: TextAlign.justify),

                SizedBox(height: mq.height * 0.03,),
          
                const Text('Observación Despacho:', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(data.observContingencia ?? '', textAlign: TextAlign.justify),
              ],
            ),
          ),
        );
      },
    );
  }
}