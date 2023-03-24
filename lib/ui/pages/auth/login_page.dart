import 'package:mobi_kg/bloc/authBloc/auth_bloc.dart';
import 'package:mobi_kg/bloc/authBloc/auth_event.dart';
import 'package:mobi_kg/bloc/authBloc/auth_state.dart';
import 'package:mobi_kg/const/app_routs_name.dart';
import 'package:mobi_kg/ui/widget/app_gradient_general.dart';
import 'package:mobi_kg/ui/widget/auth_text_field.dart';
import 'package:mobi_kg/util/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  String? _errorEmail;
  String? _errorPassword;
  bool showProgress = false;

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
        } else if (state is AuthErrorState) {
          setState(() {
            showProgress = false;
          });
          snackBar(context,msg: state.msgError);
        } else {
          snackBar(context,msg: 'error'.tr);
        }
      },
      child: LoginScreenWidget(
        errorEmail: _errorEmail,
        errorPassword: _errorPassword,
        emailController: _emailController,
        passwordController: _passController,
        showProgress: showProgress, onPressed: () {
          if(!_emailController.text.isEmail){
            _errorEmail = 'invalidEmail'.tr;
            setState(() {

            });
            return;
          }
          bloc.add(AuthSignInEvent(
          email: _emailController.text,
          password: _passController.text)); },
      ),
    ));
  }
}

class LoginScreenWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool showProgress;
  final Function() onPressed;
  final String? errorEmail;
  final String? errorPassword;

  const LoginScreenWidget(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.showProgress, required this.onPressed, this.errorEmail, this.errorPassword});
  Widget buildForgotPassBtn(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context,AppRoutsName.resetPasswordPage);
        },
        // style: ButtonStyle(padding: EdgeInsets.only(right: 0)),
        child:  Text(
          'forgotPassword'.tr,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildSignUpBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context,AppRoutsName.registerPage);
      },
      child:Shimmer.fromColors(baseColor: Colors.white,
      highlightColor: Colors.red,
      child: Text('register'.tr.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,))
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: [
              AppGradientGeneral(
                child: showProgress == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 120),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                              "signIn".tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            AuthTextField(
                              controller: emailController,
                              hintText: "email".tr,
                              icon: const Icon(
                                Icons.email,
                                color: Color(0xff5ac18e),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              marginTop: 50,
                              errorText: errorEmail,
                            ),
                            AuthTextField(
                                controller: passwordController,
                                hintText: "password".tr,
                                icon: const Icon(
                                  Icons.lock,
                                  color: Color(0xff5ac18e),
                                ),
                              errorText: errorPassword ,
                              obscureText: true,
                            ),
                            buildForgotPassBtn(context),
                            const SizedBox(
                              height: 20,
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
                                child:  Text(
                                  "signIn".tr,
                                  style: const TextStyle(
                                      color: Color(0xff5ac18e),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            buildSignUpBtn(context)
                          ],
                        ),
                      ),
              )
            ],
          ),
        ));
  }
}
