import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late final AnimationController _loadingController;
  late final AnimationController _textFieldController;
  late final Animation<double> animation;

  bool isLoading = true;
  bool loaded = false;
  bool showText = false;

  bool textAnimated = false;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(vsync: this);
    _loadingController.addListener(() {
      if (_loadingController.value > 0.5) {
        _loadingController.stop();
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       if (!loaded)
      //         setState(() {
      //           loaded = true;
      //         });
      //       else {
      //         setState(() {
      //           loaded = false;
      //         });
      //       }
      //     }),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              padding: EdgeInsets.only(top: isLoading ? height * 0.17 : 0),
              child: Lottie.asset('assets/hello_alt.json',
                  controller: _loadingController, onLoaded: (composition) {
                _loadingController.duration = composition.duration;
                _loadingController.forward();
              }),
              onEnd: () {
                setState(() {
                  loaded = true;
                });
              },
            ),
          ),
          Positioned(
            top: height * 0.5,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedContainer(
                curve: Curves.easeInOutCubicEmphasized,
                duration: Duration(milliseconds: 1500),
                width: loaded ? width * 0.7 : 0,
                onEnd: () {
                  setState(() {
                    textAnimated = true;
                  });
                },
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        fillColor: Colors.grey.withOpacity(0.2),
                        filled: true,
                        labelText: "User Name",
                        labelStyle: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.07,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          fillColor: Colors.grey.withOpacity(0.2),
                          filled: true,
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.white70,
                          )),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          fillColor: Colors.grey.withOpacity(0.2),
                          filled: true,
                          labelText: "Retype Password",
                          labelStyle: TextStyle(color: Colors.white70)),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
