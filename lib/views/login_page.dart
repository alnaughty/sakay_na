import 'package:flutter/material.dart';
import 'package:sakayna/global/widget.dart';
import 'package:sakayna/services/API/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  final AuthAPI _auth = AuthAPI.instance;
  bool isLoading = false;
  bool obscureText = true;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  void login() async {
    setState(() {
      isLoading = true;
    });
    await _auth
        .login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/landing_page");
      }
    }).whenComplete(() => setState(
              () => isLoading = false,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.grey.shade200,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return Form(
                    key: _kForm,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: constraint.maxHeight * .04),
                              TextFormField(
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please fill this field";
                                  }
                                  return null;
                                },
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                obscureText: obscureText,
                                controller: _passwordController,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please fill this field";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obscureText = !obscureText;
                                      });
                                    },
                                    child: Icon(
                                      obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: "Password",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text("No account yet ?"),
                                  TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, "/register_page"),
                                    child: const Text("Register"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: constraint.maxWidth,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_kForm.currentState!.validate()) {
                                      login();
                                    }
                                    // model.login(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          isLoading ? loadingWidget : Container(),
        ],
      ),
    );
  }
}
