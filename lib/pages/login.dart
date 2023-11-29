import 'package:autogestion_tecnico/providers/ui_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    final uiProvider = Provider.of<UiProvider>(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: mq.width * 0.02),
                        width: mq.width * 0.20,
                        height: mq.width * 0.20,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/img/logo.png")))),
                    IconButton(
                        padding: const EdgeInsets.all(2),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Próximamente en funcionamiento.')));
                        },
                        icon: const Icon(Icons.help_rounded))
                  ],
                ),
                SizedBox(
                  width: mq.width * 1,
                  height: mq.height * 0.9,
                  child: Padding(
                    padding: EdgeInsets.all(mq.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: mq.width * 0.50,
                            height: mq.width * 0.50,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/img/img-login.png")))),
                        CustomField(
                            controller: usernameController,
                            hintText: 'Nombre de usuario',
                            icon: Icons.account_circle_rounded),
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        CustomField(
                          controller: passwordController,
                          hintText: 'Contraseña',
                          icon: Icons.key,
                          obscureText: true,
                          isObscureText: true,
                        ),
                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        CustomButton(
                            mq: mq,
                            color: blueColor,
                            colorText: whiteColor,
                            function: () async {
                              FocusScope.of(context).unfocus();

                              final authService = Provider.of<AuthService>(
                                  context,
                                  listen: false);

                              if (usernameController.text == '' ||
                                  passwordController.text == '') {
                                CustomShowDialog.alert(
                                    context: context,
                                    title: 'Error',
                                    message:
                                        'Debes de diligenciar los campos obligatorios.');
                                return false;
                              }

                              final Map? resp = await authService.login(
                                  usuario: usernameController.text,
                                  password: passwordController.text);

                              if (resp!['type'] == 'error') {
                                CustomShowDialog.alert(
                                    context: context,
                                    title: 'Error',
                                    message: resp['message']);
                                return false;
                              } else {
                                Navigator.pushReplacementNamed(context, 'home');
                              }
                            },
                            text: 'Ingresar'),
                        (uiProvider.connectionStatusProvider ==
                                ConnectivityResult.wifi)
                            ? Icon(
                                Icons.wifi,
                                color: uiProvider.isDeviceConnectedProvider
                                    ? greenColor
                                    : redColor,
                              )
                            : (uiProvider.connectionStatusProvider ==
                                    ConnectivityResult.mobile)
                                ? Icon(
                                    Icons.cell_tower,
                                    color: uiProvider.isDeviceConnectedProvider
                                        ? greenColor
                                        : redColor,
                                  )
                                : const Icon(Icons.public_off)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
