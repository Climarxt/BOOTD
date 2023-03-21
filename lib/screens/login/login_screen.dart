import 'package:app_6/config/config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '/repositories/repositories.dart';
import 'cubit/login_cubit.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
              create: (_) =>
                  LoginCubit(authRepository: context.read<AuthRepository>()),
              child: LoginScreen(),
            ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle defaultStyle = const TextStyle(color: grey, fontSize: 12.0);
  TextStyle linkStyle = const TextStyle(color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 24),
                              SvgPicture.asset(
                                'assets/logo.svg',
                                height: 44,
                              ),
                              const SizedBox(width: 14),
                              SvgPicture.asset(
                                'assets/ic_instagram.svg',
                                height: 42,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 320.0),
                            child: SafeArea(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                width: double.infinity,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      MyButton(
                                          onTap: () => Navigator.of(context)
                                              .pushNamed(
                                                  LoginMailScreen.routeName),
                                          icon: 'assets/icons/email.svg',
                                          texte: "Connexion par mail"),
                                      const SizedBox(height: 18),
                                      MyButton(
                                          onTap: () => Navigator.of(context)
                                              .pushNamed(
                                                  LoginHelpScreen.routeName),
                                          icon: 'assets/icons/cell-phone.svg',
                                          texte: "Connexion par téléphone"),
                                      const SizedBox(height: 18),
                                      MyButton(
                                          onTap: () => Navigator.of(context)
                                              .pushNamed(
                                                  LoginHelpScreen.routeName),
                                          icon: 'assets/icons/google.svg',
                                          texte: "Connexion via Google"),
                                      const SizedBox(height: 18),
                                      MyButton(
                                          onTap: () => Navigator.of(context)
                                              .pushNamed(
                                                  LoginHelpScreen.routeName),
                                          icon: 'assets/icons/apple.svg',
                                          texte: "Connexion via Apple"),
                                      const SizedBox(height: 18),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            child: const Text(
                                                "Informations de connexion oubliées ?"),
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .pushNamed(
                                                    LoginHelpScreen.routeName),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child: const Text(
                                                " Obtenez de l'aide",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: defaultStyle,
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          'En vous inscrivant, vous acceptez nos '),
                                  TextSpan(
                                    text:
                                        "Conditions Générales d'Utilisation. ",
                                    style: linkStyle,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context)
                                          .pushNamed(
                                              ConditionsGenScreen.routeName),
                                  ),
                                  TextSpan(
                                      text:
                                          'Découvrez comment on utilise vos données en lisant notre '),
                                  TextSpan(
                                    text: 'Politique de Confidentialité.',
                                    style: linkStyle,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context)
                                          .pushNamed(
                                              PolitiqueConfScreen.routeName),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCredentials();
    }
  }
}
