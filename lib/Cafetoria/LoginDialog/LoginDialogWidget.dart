import 'package:flutter/material.dart';
import 'LoginDialogView.dart';
import '../../Network.dart';

class LoginDialog extends StatefulWidget {
  final Function onFinished;
  
  LoginDialog({Key key, this.onFinished}) : super(key: key);
  
  @override
  LoginDialogView createState() => LoginDialogView();
}

abstract class LoginDialogState extends State<LoginDialog> {
  int online = 1;
  
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prepareLogin();
    });
  }

  void prepareLogin() {
    checkOnline.then((online) {
      setState(() {
        this.online = online;
      });
    });
  }  
}
