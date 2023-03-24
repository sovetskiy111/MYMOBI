import 'package:mobi_kg/bloc/authBloc/auth_bloc.dart';
import 'package:mobi_kg/bloc/authBloc/auth_event.dart';
import 'package:mobi_kg/bloc/authBloc/auth_state.dart';
import 'package:mobi_kg/const/app_routs_name.dart';
import 'package:mobi_kg/ui/widget/auth_text_field.dart';
import 'package:mobi_kg/util/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _Register();
}

class _Register extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? errorName;
  String? errorEmail;
  String? errorPassword;
  String? errorConfirmPass;
  bool showProgress = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoadingState) {
                setState(() {
                  showProgress = true;
                });
              } else if (state is AuthLoadedState) {
                Navigator.pushNamed(context, AppRoutsName.homePage);
                setState(() {
                  showProgress = false;
                });
              } else if (state is AuthErrorState) {
                setState(() {
                  showProgress = false;
                });
                snackBar(context, msg: state.msgError);
              }
            },
            child: BuildRegister(
              nameController: _nameController,
              emailController: _emailController,
              passwordController: _passController,
              confirmPasswordController: _confirmPasswordController,
              showProgress: showProgress,
              errorName: errorName,
              errorEmail: errorEmail,
              errorPassword: errorPassword,
              errorConfirmPass: errorConfirmPass,
              onPressed: () {
                if(_nameController.text.trim().isEmpty){
                  setState(() {
                  errorName = 'cannotBeEmpty'.tr;
                  });
                  return;
                }else if(!_emailController.text.trim().isEmail){
                  setState(() {
                  errorEmail = 'invalidEmail'.tr;
                  });
                  return;
                }else if(_passController.text.length<6){
                  setState(() {
                    errorPassword = 'weakPassword'.tr;
                  });
                  return;
                }else if(_passController.text.trim()!=_confirmPasswordController.text.trim()){
                  setState(() {
                    errorConfirmPass = 'doNotMatch'.tr;
                  });
                  return;
                }
                bloc.add(AuthCreateEvent(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passController.text));
              },
            )));
  }
}

class BuildRegister extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? errorName;
  final String? errorEmail;
  final String? errorPassword;
  final String? errorConfirmPass;
  final bool showProgress;
  final Function() onPressed;

  const BuildRegister(
      {super.key,
      required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController,
      required this.showProgress,
      required this.errorName,
      required this.errorEmail,
      required this.errorPassword,
      required this.errorConfirmPass,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x904d90ad),
                          Color(0x969fd3e8),
                          Color(0xbe4d90ad),
                          Color(0xff3f91b4),
                    ])),
                child: showProgress == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              width: double.infinity,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              "register".tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            AuthTextField(
                              errorText: errorName,
                              controller: nameController,
                              hintText: "name".tr,
                              icon: const Icon(
                                Icons.person,
                                color: Color(0xffef2258),
                              ),
                              marginTop: 30,
                            ),
                            AuthTextField(
                              errorText: errorEmail,
                              controller: emailController,
                              hintText: "email".tr,
                              icon: const Icon(
                                Icons.email,
                                color: Color(0xffef2258),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            AuthTextField(
                              errorText: errorPassword,
                              controller: passwordController,
                              hintText: "password".tr,
                              icon: const Icon(
                                Icons.lock,
                                color: Color(0xffef2258),
                              ),
                            ),
                            AuthTextField(
                              errorText: errorConfirmPass,
                              controller: confirmPasswordController,
                              hintText: "confirmPassword".tr,
                              icon: const Icon(
                                Icons.lock,
                                color: Color(0xffef2258),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "agree".tr,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                onPressed: onPressed,
                                child: Text(
                                  "register".tr,
                                  style: const TextStyle(
                                      color: Color(0xffef2258),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              )
            ],
          ),
        ));
  }
}
