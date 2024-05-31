import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
// TextEditingController Controller=TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width / 2,
            ),
            padding: EdgeInsets.only(top: 45, left: 20, right: 20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                ),
                borderRadius:
                    BorderRadius.vertical(top: Radius.elliptical(100, 50))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null) {
                        return "Please eneter username";
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter the user name",
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter username";
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter the Password",
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  // margin: EdgeInsets.symmetric(horizontal: 30),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Log In",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );


    
  }
}
