import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/autentication.dart';

class LoginForm extends StatefulWidget {
  final paddingTopForm,
      fontSizeTextField,
      fontSizeTextFormField,
      spaceBetweenFields,
      iconFormSize;
  final spaceBetweenFieldAndButton,
      widthButton,
      fontSizeButton,
      fontSizeForgotPassword,
      fontSizeSnackBar,
      errorFormMessage;

  LoginForm(
      this.paddingTopForm,
      this.fontSizeTextField,
      this.fontSizeTextFormField,
      this.spaceBetweenFields,
      this.iconFormSize,
      this.spaceBetweenFieldAndButton,
      this.widthButton,
      this.fontSizeButton,
      this.fontSizeForgotPassword,
      this.fontSizeSnackBar,
      this.errorFormMessage);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _emailFocus = FocusNode();

  bool _passwordVisible = true;
  bool loader = false;

  void login(auth, context) {
    setState(() {
      loader = true;
    });

    if (_formKey.currentState!.validate()) {
      auth.login(_emailController.text, _passwordController.text).then((value) {
        if (value) {
          setState(() {
            loader = false;
            Navigator.pushReplacementNamed(context, "/home");
          });
        } else {
          setState(() {
            loader = false;
          });
          print("Login fail");
        }
      });
    }

    Timer(Duration(seconds: 2), () {
      setState(() {
        loader = false;
        Navigator.pushReplacementNamed(context, "/home");
      });
    });
  }

  @override
  void initState() {
    _emailController.text = "super@admin.com";
    _passwordController.text = "super_password";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.of(context).size.width;
    final double heightSize = MediaQuery.of(context).size.height;
    var auth = Provider.of<Authentication>(context, listen: false);

    return loader
        ? Expanded(
            child: Container(
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Palette.loaderColor,
              )),
            ),
          )
        : Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.only(
                    left: widthSize * 0.05,
                    right: widthSize * 0.05,
                    top: heightSize * widget.paddingTopForm),
                child: Column(children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Email',
                          style: TextStyle(
                              fontSize: widthSize * widget.fontSizeTextField,
                              fontFamily: 'Poppins',
                              color: Colors.white))),
                  TextFormField(
                      autofocus: true,
                      focusNode: _emailFocus,
                      onFieldSubmitted: (value) {
                        _passwordFocus.requestFocus();
                      },
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email Required!';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Invalid Email!';
                        }
                      },
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        // hintText: "Email",
                        fillColor: Colors.white,
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white30, width: 2)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                        labelStyle: TextStyle(color: Colors.white),
                        errorStyle: TextStyle(
                            color: Colors.white,
                            fontSize: widthSize * widget.errorFormMessage),
                        prefixIcon: Icon(
                          Icons.person,
                          size: widthSize * widget.iconFormSize,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.fontSizeTextFormField)),
                  SizedBox(height: heightSize * widget.spaceBetweenFields),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Mot de passe',
                          style: TextStyle(
                              fontSize: widthSize * widget.fontSizeTextField,
                              fontFamily: 'Poppins',
                              color: Colors.white))),
                  TextFormField(
                      focusNode: _passwordFocus,
                      onFieldSubmitted: (value) {
                        login(auth, context);
                      },
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Mot de passe Required!';
                        }
                      },
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.text,
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white30, width: 2)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                          labelStyle: TextStyle(color: Colors.white),
                          errorStyle: TextStyle(
                              color: Colors.white,
                              fontSize: widthSize * widget.errorFormMessage),
                          prefixIcon: Icon(
                            Icons.lock,
                            size: widthSize * widget.iconFormSize,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: widthSize * widget.iconFormSize,
                              color: Colors.white,
                            ),
                          )),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.fontSizeTextFormField)),
                  SizedBox(
                      height: heightSize * widget.spaceBetweenFieldAndButton),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.fromLTRB(
                          widget.widthButton, 15, widget.widthButton, 15),
                      color: Colors.white,
                      onPressed: () {
                        login(auth, context);
                      },
                      child: Text('Login',
                          style: TextStyle(
                              fontSize: widthSize * widget.fontSizeButton,
                              fontFamily: 'Poppins',
                              color: Color.fromRGBO(41, 187, 255, 1)))),
                  SizedBox(height: heightSize * 0.01),
                ])));
  }
}
