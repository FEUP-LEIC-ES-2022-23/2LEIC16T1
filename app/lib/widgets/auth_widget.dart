import 'package:flutter/material.dart';
import 'package:sportspotter/widgets/login_widget.dart';
import 'package:sportspotter/widgets/register_widget.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickRegister: toggle)
      : RegisterWidget(onClickLogIn: toggle);
  void toggle() => setState(() => isLogin = !isLogin);
}
