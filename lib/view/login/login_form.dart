import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  void login(Authentication auth, context) {
    setState(() {
      loader = true;
    });

    if (_formKey.currentState!.validate()) {
      print("login");
      auth.login(_emailController.text, _passwordController.text).then((value) {
        if (value) {
          setState(() {
            loader = false;
            Navigator.pushReplacementNamed(context, "/home");
          });
        } else {
          Fluttertoast.showToast(
              webBgColor: "linear-gradient(to right, #E21010, #ED9393)",
              msg: "Invalid Account",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              fontSize: 16.0);
          setState(() {
            loader = false;
          });
          print("Login fail");
        }
      });
    } else {
      setState(() {
        loader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.of(context).size.width;
    final double heightSize = MediaQuery.of(context).size.height;
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
                              color: Colors.black))),
                  RawKeyboardListener(
                    focusNode: _emailFocus,
                    child: TextFormField(
                        autofocus: true,
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
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: Colors.black,
                          border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Palette.drawerColorLight, width: 2)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Palette.drawerColor, width: 2)),
                          labelStyle: TextStyle(color: Colors.black),
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: widthSize * widget.errorFormMessage),
                          prefixIcon: Icon(
                            Icons.person,
                            size: widthSize * widget.iconFormSize,
                            color: Colors.black,
                          ),
                        ),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: widget.fontSizeTextFormField)),
                  ),
                  SizedBox(height: heightSize * widget.spaceBetweenFields),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Mot de passe',
                          style: TextStyle(
                              fontSize: widthSize * widget.fontSizeTextField,
                              fontFamily: 'Poppins',
                              color: Colors.black))),
                  TextFormField(
                      focusNode: _passwordFocus,
                      onFieldSubmitted: (value) {
                        print("login");
                        login(auth, context);
                      },
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Mot de passe Required!';
                        }
                      },
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                          fillColor: Colors.black,
                          border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Palette.drawerColorLight, width: 2)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Palette.drawerColor, width: 2)),
                          labelStyle: TextStyle(color: Colors.black),
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: widthSize * widget.errorFormMessage),
                          prefixIcon: Icon(
                            Icons.lock,
                            size: widthSize * widget.iconFormSize,
                            color: Colors.black,
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
                              color: Colors.black,
                            ),
                          )),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
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
                        print("login");
                        login(auth, context);
                      },
                      child: Text('Login',
                          style: TextStyle(
                              fontSize: widthSize * widget.fontSizeButton,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Palette.drawerColor))),
                  SizedBox(height: heightSize * 0.01),
                ])));
  }
}
