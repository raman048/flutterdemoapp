import 'package:flutter/material.dart';
import 'package:flutter_app/core/models/users.dart';
import 'package:flutter_app/core/utils/database_helper.dart';
import 'package:flutter_app/views/signup.dart';
import 'package:flutter_app/views/userprofile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  DataBaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DataBaseHelper();
  }

  @override
  void dispose() {
    _emailIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_emailIdController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty) {
          final emailId = _emailIdController.text;
          final password = _passwordController.text;
          Users user = await dbHelper.getLogin(emailId, password);
          print('--fff--' + user.id.toString());
          if (user != null) {

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => UserProfile(),
                    settings: RouteSettings(arguments: user)),
                (r) => false);
          } else {
            showToast("Email id and password is incorrect");
          }
        } else {
          showToast("Please Enter Detail.");
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffE84D1C), Color(0xfff7892b)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Color(0xfff7892b),
        fontSize: 16.0);
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Nano',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffE84D1C),
          ),
          children: [
            TextSpan(
              text: ' Health ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Suite',
              style: TextStyle(color: Color(0xffE84D1C), fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(0),
        color: Colors.white10,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -MediaQuery.of(context).size.height * .3,
            right: -MediaQuery.of(context).size.width * .4,
            child: BezierContainer(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(
                    height: 80,
                  ),
                  TextFormField(
                    controller: _emailIdController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email id',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 12.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 12.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  _submitButton(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password ?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(height: height * .1),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
