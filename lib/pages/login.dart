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
  TextEditingController loginController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              mq: mq * 0.7,
                              color: blueColor,
                              colorText: whiteColor,
                              function: () async {
                                FocusScope.of(context).unfocus();

                                final authService = Provider.of<AuthService>(
                                  context,
                                  listen: false,
                                );

                                if (usernameController.text == '' ||
                                    passwordController.text == '') {
                                  CustomShowDialog.alert(
                                    context: context,
                                    title: 'Error',
                                    message:
                                        'Debes diligenciar los campos obligatorios.',
                                  );
                                  return false;
                                }

                                final Map? resp = await authService.login(
                                  usuario: usernameController.text,
                                  password: passwordController.text,
                                );

                                if (resp!['type'] == 'error') {
                                  CustomShowDialog.alert(
                                    context: context,
                                    title: 'Error',
                                    message: resp['message'],
                                  );
                                  return false;
                                } else {
                                  Navigator.pushReplacementNamed(
                                      context, 'home');
                                }
                              },
                              text: 'Ingresar',
                            ),
                            Column(
                              children: [
                                CustomButton(
                                  mq: mq * 0.7,
                                  color: blueColor,
                                  colorText: whiteColor,
                                  function: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Recuperar contraseña'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CustomField(
                                                    controller: loginController,
                                                    hintText: 'Login usuario*',
                                                    icon: Icons
                                                        .account_circle_rounded),
                                                SizedBox(
                                                  height: mq.height * 0.03,
                                                ),
                                                CustomField(
                                                    controller:
                                                        cedulaController,
                                                    hintText: 'Cédula usuario*',
                                                    icon: Icons.assignment),
                                                SizedBox(
                                                  height: mq.height * 0.03,
                                                ),
                                                CustomField(
                                                    controller:
                                                        celularController,
                                                    hintText: 'Celular*',
                                                    icon: Icons.device_unknown),
                                                SizedBox(
                                                  height: mq.height * 0.03,
                                                )
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                                final authService =
                                                    Provider.of<AuthService>(
                                                  context,
                                                  listen: false,
                                                );

                                                if (loginController.text ==
                                                        '' ||
                                                    cedulaController.text ==
                                                        '' ||
                                                    celularController.text ==
                                                        '') {
                                                  CustomShowDialog.alert(
                                                    context: context,
                                                    title: 'Error',
                                                    message:
                                                        'Debes diligenciar los campos obligatorios.',
                                                  );
                                                  return;
                                                }

                                                final Map? resp =
                                                    await authService
                                                        .recoverPass(
                                                  login: loginController.text,
                                                  cedula: cedulaController.text,
                                                  celular:
                                                      celularController.text,
                                                );

                                                if (resp != null) {
                                                  if (resp['type'] == 'error') {
                                                    CustomShowDialog.alert(
                                                      context: context,
                                                      title: 'Error',
                                                      message: resp['message'],
                                                    );
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              resp['message']),
                                                          content:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Text(
                                                                  'Si desea actualizar su contraseña, diligencie el siguiente formulario:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      mq.height *
                                                                          0.03,
                                                                ),
                                                                CustomField(
                                                                  controller:
                                                                      passController,
                                                                  hintText:
                                                                      'Nueva contraseña*',
                                                                  icon: Icons
                                                                      .password,
                                                                  obscureText:
                                                                      true,
                                                                  isObscureText:
                                                                      true,
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      mq.height *
                                                                          0.03,
                                                                ),
                                                                CustomField(
                                                                  controller:
                                                                      confirmPassController,
                                                                  hintText:
                                                                      'Confirmar contraseña*',
                                                                  icon: Icons
                                                                      .password,
                                                                  obscureText:
                                                                      true,
                                                                  isObscureText:
                                                                      true,
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      mq.height *
                                                                          0.03,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                final authService =
                                                                    Provider.of<
                                                                        AuthService>(
                                                                  context,
                                                                  listen: false,
                                                                );

                                                                if (passController
                                                                            .text ==
                                                                        '' ||
                                                                    confirmPassController
                                                                            .text ==
                                                                        '') {
                                                                  CustomShowDialog.alert(
                                                                      context:
                                                                          context,
                                                                      title:
                                                                          'Error',
                                                                      message:
                                                                          'Debes diligenciar los campos obligatorios.');
                                                                  return;
                                                                }

                                                                if (passController
                                                                        .text !=
                                                                    confirmPassController
                                                                        .text) {
                                                                  CustomShowDialog.alert(
                                                                      context:
                                                                          context,
                                                                      title:
                                                                          'Error',
                                                                      message:
                                                                          'El campo Nueva contraseña y Confirmar contraseña no son iguales');
                                                                  return;
                                                                }

                                                                if (passController
                                                                            .text
                                                                            .length <
                                                                        6 ||
                                                                    !RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{6,}$')
                                                                        .hasMatch(
                                                                            passController.text)) {
                                                                  CustomShowDialog
                                                                      .alert(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'Error',
                                                                    message:
                                                                        'La nueva contraseña debe tener al menos 6 caracteres y contener al menos una letra mayúscula y una letra minúscula.',
                                                                  );
                                                                  return;
                                                                }

                                                                final Map? resp = await authService.updatePass(
                                                                    pass: passController
                                                                        .text,
                                                                    confirmPass:
                                                                        confirmPassController
                                                                            .text,
                                                                    cedula:
                                                                        cedulaController
                                                                            .text);

                                                                print(
                                                                    'respuesta ${resp!['message']}');

                                                                if (resp[
                                                                        'type'] ==
                                                                    'error') {
                                                                  CustomShowDialog
                                                                      .alert(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'error',
                                                                    message: resp[
                                                                        'message'],
                                                                  );
                                                                  return;
                                                                }

                                                                if (resp[
                                                                        'type'] ==
                                                                    'success') {
                                                                  Navigator.canPop(
                                                                      context);

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();

                                                                  loginController
                                                                      .text = '';
                                                                  cedulaController
                                                                      .text = '';
                                                                  celularController
                                                                      .text = '';
                                                                  passController
                                                                      .text = '';
                                                                  confirmPassController
                                                                      .text = '';
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  CustomShowDialog
                                                                      .alert(
                                                                    context:
                                                                        context,
                                                                    title:
                                                                        'Bien',
                                                                    message: resp[
                                                                        'message'],
                                                                  );
                                                                }
                                                              },
                                                              child: Text(
                                                                  'Actualizar Contraseña'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                  'Cancelar'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                } else {
                                                  CustomShowDialog.alert(
                                                    context: context,
                                                    title: 'Error',
                                                    message:
                                                        'Hubo un problema al recuperar la contraseña. Inténtalo nuevamente.',
                                                  );
                                                }
                                              },
                                              child:
                                                  Text('Recuperar contraseña'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                loginController.text = '';
                                                cedulaController.text = '';
                                                celularController.text = '';
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cerrar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  text: 'Olvido su contraseña?',
                                ),
                              ],
                            ),
                          ],
                        )
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
