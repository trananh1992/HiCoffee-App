import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hicoffee/screens/home_screen.dart';
import 'package:hicoffee/sqlite/database_helper.dart';
import 'package:hicoffee/widgets/custom_drawer.dart';
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//  Color kPrimaryColor = Color(0xFF6F35A5);
  Color kPrimaryColor = Color(0xFF66c2ff);
//  Color kPrimaryLightColor = Color(0xFFF1E6FF);
//  Color kPrimaryLightColor = Colors.lightBlue[50];
  Color kPrimaryLightColor = Colors.white;
  String username;
  String password;

  void login() async{
    Widget child = HomeScreen();
    child = CustomDrawer(child: child);
    String token;
    var reqBody = Map<String, dynamic>();
    reqBody['username'] = username;
    reqBody['password'] = password;
    if(username == null)
      return;
    if(password == null)
      return;
    String jsonBody = jsonEncode(reqBody);
    print(jsonBody);
    Map<String, String> reqHeader = {"Content-type": "application/json", "Accept": "application/json"};
    Response response = await post("http://al1.best:85/api/login/", body:jsonBody, headers: reqHeader);
    dynamic data = await jsonDecode(utf8.decode(response.bodyBytes));
    token = data["token"];
    print("Login statusCode: ${response.statusCode}");
    if(response.statusCode == 200){
      // Update the local db
      var result = await DatabaseHelper().insertToken(token);
      print("insert Token to db: $result");
      // Go to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => child),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                width: size.width * 0.35,
              ),
            ),
            Positioned(
              top: 40,
              child: Text(
                "LOGIN",
                style: TextStyle(
                    fontSize: 20.0,
//                      fontFamily: "Milton",
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                "assets/images/login_bottom.png",
                width: size.width * 0.4,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.03),
                  Align(
                    alignment: Alignment(0.65,0),
                    child: Image.asset(
                      "assets/images/login_logo.png",
                      height: size.height * 0.30,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      onChanged: (value) => setState(() => username = value),
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: kPrimaryColor,
                        ),
                        hintText: "Username",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: TextField(
                    obscureText: true,
                    onChanged: (value) => setState(() => password = value),
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      hintText: "Password",
                      icon: Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                      suffixIcon: Icon(
                        Icons.visibility,
                        color: kPrimaryColor,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      color: kPrimaryColor,
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}