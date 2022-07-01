import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:login_ui/DummyPage.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late final AnimationController _loadingController;
  late final Animation<double> animation;
  late final AnimationController _loginController;
  bool isLoading = true;
  bool loaded = false;
  bool showText = false;
  bool textAnimated = false;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String? pwd;
  String? email;
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<User?> registerWithEmailAndPassword(String email, String pwd) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      User? u = user.user;
      if (u != null) {
        print("success");
        return u;
      } else {
        print("Login Failed");
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: isLoading ? 0 : 1,
            child: Container(
              padding: EdgeInsets.only(top: height * 0.1),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/bg.png'),
                    fit: BoxFit.cover,
                    opacity: _loadingController.value),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Stack(
              children: [
                AnimatedOpacity(
                  duration: Duration(seconds: 1),
                  opacity: isLoading ? 0 : 1,
                  child: Container(
                    padding: EdgeInsets.only(top: height * 0.1),
                    child: Center(
                      child: GlassmorphicContainer(
                        width: width * 0.8,
                        height: height * 0.85,
                        borderRadius: 20,
                        blur: 3,
                        alignment: Alignment.bottomCenter,
                        border: 2,
                        linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFffffff).withOpacity(0.1),
                              Color(0xFFFFFFFF).withOpacity(0.05),
                            ],
                            stops: [
                              0.1,
                              1,
                            ]),
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFffffff).withOpacity(0.5),
                            Colors.transparent
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 800),
                    padding: EdgeInsets.only(top: isLoading ? height * 0.1 : 0),
                    child: Lottie.asset('assets/animations/hello_alt.json',
                        controller: _loadingController,
                        onLoaded: (composition) {
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
                if (loaded)
                  Positioned(
                    top: height * 0.40,
                    left: width * 0.3,
                    right: 0,
                    child: AnimatedTextKit(
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TyperAnimatedText("Registration",
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontFamily: "GoogleSans"))
                      ],
                      onFinished: () {
                        setState(() {
                          textAnimated = true;
                        });
                      },
                    ),
                  ),
                Positioned(
                  top: height * 0.46,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedContainer(
                      curve: Curves.easeInOutCubicEmphasized,
                      duration: Duration(milliseconds: 3000),
                      width: textAnimated ? width * 0.6 : 0,
                      child: textAnimated
                          ? Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.03,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "GoogleSans"),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (val) =>
                                          val!.isEmpty ? "Enter Email!" : null,
                                      onChanged: (String val) {
                                        email = val;
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          fillColor:
                                              Colors.grey.withOpacity(0.2),
                                          filled: true,
                                          label: const Padding(
                                            padding: EdgeInsets.only(left: 40),
                                            child: Text("User Name",
                                                style: TextStyle(
                                                    color: Colors.white38,
                                                    fontFamily: "GoogleSans")),
                                          ),
                                          prefixIcon: SizedBox(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Icon(Icons.mail)),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.03,
                                  ),
                                  Container(
                                    height: 45,
                                    child: TextFormField(
                                      obscureText: true,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "GoogleSans"),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      cursorHeight: 15,
                                      //obscureText: true,
                                      validator: (val) => val!.isEmpty
                                          ? "Enter Password!"
                                          : null,
                                      onChanged: (val) {
                                        pwd = val;
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          fillColor:
                                              Colors.grey.withOpacity(0.2),
                                          filled: true,
                                          label: const Padding(
                                            padding: EdgeInsets.only(left: 40),
                                            child: Text("Password",
                                                style: TextStyle(
                                                    color: Colors.white38,
                                                    fontFamily: "GoogleSans")),
                                          ),
                                          prefixIcon: SizedBox(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Icon(Icons.lock)),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.03,
                                  ),
                                  SizedBox(
                                    height: 45,
                                    child: TextFormField(
                                      obscureText: true,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "GoogleSans"),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (val) => val == null
                                          ? "Both Passwords should match!"
                                          : null,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          fillColor:
                                              Colors.grey.withOpacity(0.2),
                                          filled: true,
                                          label: const Padding(
                                            padding: EdgeInsets.only(left: 22),
                                            child: Text("Retype Password",
                                                style: TextStyle(
                                                    color: Colors.white38,
                                                    fontFamily: "GoogleSans")),
                                          ),
                                          prefixIcon: SizedBox(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Icon(Icons
                                                    .check_circle_outline)),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Container(
                                    width: 170,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.greenAccent.withOpacity(0.5),
                                          Colors.yellow.withOpacity(0.5),
                                          Colors.orange.withOpacity(0.5),
                                          Colors.pink.withOpacity(0.5),
                                          Colors.blue.withOpacity(0.5)
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all<double>(
                                                  0),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ))),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          print(email);
                                          print(pwd);
                                          User? auth =
                                              await registerWithEmailAndPassword(
                                                  email!, pwd!);
                                          final pos =
                                              await _determinePosition();
                                          if (auth != null && pos != null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Home(
                                                        long: pos.longitude
                                                            .toString(),
                                                        lat: pos.latitude
                                                            .toString())));
                                          } else {
                                            print("Could not register");
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: 170,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Expanded(
                                              child: Text(
                                                "Register",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontFamily: "GoogleSans"),
                                              ),
                                            ),
                                            Expanded(child: Icon(Icons.login))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
