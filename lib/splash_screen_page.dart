import 'package:flutter/material.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/global/palette.dart';
import 'package:sakayna/services/data_cacher.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final DataCacher _cacher = DataCacher.instance;
  void checkLoginStatus() async {
    print("ASD");
    String? token = _cacher.getToken();
    print("TOKEN : $token");
    setState(() {
      accessToken = token;
    });
    await Future.delayed(
      const Duration(
        milliseconds: 500,
      ),
    );
    if (token == null) {
      Navigator.pushReplacementNamed(context, "/login_page");
    } else {
      Navigator.pushReplacementNamed(context, "/landing_page");
    }
  }

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            "assets/images/icon.png",
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation<Color>(Palette.kToDark),
        ),
      ],
    ));
  }
}
