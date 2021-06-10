import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:psinsx/models/user_model.dart';
import 'package:psinsx/pages/home_page.dart';
import 'package:psinsx/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //Field
  String user, password;

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      //resizeToAvoidBottomPadding: false,

      body: SafeArea(
        child: GestureDetector(onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //SizedBox(height: 30),
                  _showLogo(),
                  _showNameApp(),
                  SizedBox(height: 20),
                  _userForm(),
                  SizedBox(height: 20),
                  _passwordForm(),
                  SizedBox(height: 20),
                  _loginButton(),
                  SizedBox(height: 300),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton() => Container(
        width: 250,
        child: MaterialButton(
          color: Colors.red[900],
          onPressed: () {
            if (user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, 'กรุณากรอก User & Password');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );

  Future<Null> checkAuthen() async {
    String url =
        'https://pea23.com/apipsinsx/getUserWhereUserSinghto.php?isAdd=true&username=$user';
    try {
      Response response = await Dio().get(url);
      print('res ===== $response');

      var result = json.decode(response.data);

      //print('result $result');

      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          routeTuService(HomePage(), userModel);
        } else {
          normalDialog(context, 'Password ผิดครับ');
        }
      }
    } catch (e) {}
  }

  Future<Null> routeTuService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', userModel.userId);
    preferences.setString('staffname', userModel.staffname);
    preferences.setString('user_email', userModel.userEmail);
    preferences.setString('user_img', userModel.userImg);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget _userForm() => Container(
        width: 250,
        child: TextFormField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: Colors.red,
            ),
            labelStyle: TextStyle(),
            labelText: 'User',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[900])),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      );

  Widget _passwordForm() => Container(
        width: 250,
        child: TextFormField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.red,
            ),
            labelStyle: TextStyle(),
            labelText: 'Password',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[900])),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
      );

  Text _showNameApp() => Text(
        'PSINSx',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.red[900],
          letterSpacing: 3,
        ),
      );

  Container _showLogo() {
    return Container(
        child: Image.asset(
      'assets/images/logo.png',
      height: 100,
    ));
  }
}
