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

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  bool showProgress = false;
  String? errorEmail;

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
          Navigator.pushNamed(context, AppRoutsName.loginPage);
        } else if (state is AuthErrorState) {
          setState(() {
            showProgress = false;
          });
          snackBar(context, msg: state.msgError);
        } else {
          snackBar(context, msg: 'error'.tr);
        }
      },
      child: LoginScreenWidget(
        errorEmail: errorEmail,
        emailController: _emailController,
        showProgress: showProgress,
        onPressed: () {
          if(!_emailController.text.trim().isEmail){
            setState(() {
              errorEmail = 'invalidEmail'.tr;
            });
            return;
          }
          bloc.add(AuthResetPasswordEvent(email: _emailController.text.trim()));
        },
      ),
    ));
  }
}

class LoginScreenWidget extends StatelessWidget {
  final TextEditingController emailController;
  final bool showProgress;
  final String? errorEmail;
  final Function() onPressed;

  const LoginScreenWidget(
      {super.key,
      required this.emailController,
      required this.showProgress,
      this.errorEmail,
      required this.onPressed});

  Widget buildLoadingBtn() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 30),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          padding: const EdgeInsets.all(15),
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onPressed,
        child: Text(
          "resetPassword".tr,
          style: const TextStyle(
              color: Color(0xff5ac18e),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

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
                      Color(0x665ac18e),
                      Color(0x995ac18e),
                      Color(0xcc5ac18e),
                      Color(0xff5ac18e),
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
                              margin: const EdgeInsets.only(bottom: 40),
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
                              "resetPassword".tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            AuthTextField(
                              errorText: errorEmail,
                              controller: emailController,
                              hintText: "email".tr,
                              icon: const Icon(
                                Icons.email,
                                color: Color(0xff5ac18e),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              marginTop: 50,
                            ),
                            buildLoadingBtn(),
                            Text(
                              "checkInEmail".tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
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
