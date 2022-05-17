import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sakayna/global/app.dart';
import 'package:sakayna/global/palette.dart';
import 'package:sakayna/global/widget.dart';
import 'package:sakayna/services/API/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  final GlobalKey<FormState> _kFormEmail = GlobalKey<FormState>();
  final BehaviorSubject<String> _emailChecker = BehaviorSubject<String>();
  final AuthAPI _auth = AuthAPI.instance;
  bool isLoading = false;
  bool obscureText = true;
  int accountType = 0;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneNumberController;
  @override
  void initState() {
    _emailController = TextEditingController();
    _emailChecker.debounceTime(const Duration(seconds: 1)).listen((text) {
      _kFormEmail.currentState!.validate();
    });
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void register() async {
    setState(() {
      isLoading = true;
    });
    Map body = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "mobile_number": _phoneNumberController.text,
      "birth_date": DateTime.now().toString(),
      "address": "DEFAULT",
      'account_type': accountType.toString(),
    };
    if (_middleNameController.text.isNotEmpty) {
      body.addAll({
        "middle_name": _middleNameController.text,
      });
    }
    if (accountType == 0) {
      body.addAll({
        "driver": "1",
      });
    }
    print(body);
    await _auth
        .register(
      body: body,
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
                builder: (_, constraint) => Form(
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
                        // physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 55,
                              width: double.maxFinite,
                              child: AppBar(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                title: const Text("Register"),
                                titleTextStyle: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                centerTitle: true,
                              ),
                            ),
                            SizedBox(
                              width: double.maxFinite,
                              // height: 4,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: 0,
                                          groupValue: accountType,
                                          activeColor: Palette.kToDark,
                                          onChanged: (int? val) => setState(
                                              () => accountType = val!),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Driver',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: accountType,
                                          activeColor: Palette.kToDark,
                                          onChanged: (int? val) => setState(
                                              () => accountType = val!),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Passenger',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(color: Colors.black),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Form(
                              key: _kFormEmail,
                              child: TextFormField(
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return "Please fill this field";
                                  }
                                  if (!emailRegExp.hasMatch(text)) {
                                    return "Invalid email format";
                                  }
                                  return null;
                                },
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (text) {
                                  _emailChecker.add(text);
                                },
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Please fill this field";
                                }
                                return null;
                              },
                              controller: _firstNameController,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: "First Name",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _middleNameController,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: "Middle Name",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Please fill this field";
                                }
                                return null;
                              },
                              controller: _lastNameController,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: "Last Name",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Please fill this field";
                                }
                                if (!phoneRegExp.hasMatch(text)) {
                                  return "Invalid mobile number";
                                }
                                return null;
                              },
                              controller: _phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "Mobile Number",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              obscureText: obscureText,
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
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
                            const SizedBox(height: 10),
                            SizedBox(
                              width: constraint.maxWidth,
                              child: ElevatedButton(
                                onPressed: () async {
                                  bool isValid =
                                      _kForm.currentState!.validate();
                                  bool isEmailValid =
                                      _kFormEmail.currentState!.validate();
                                  if (isValid && isEmailValid) {
                                    register();
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
                                  "Register",
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
                ),
              ),
            ),
          ),
          isLoading ? loadingWidget : Container()
        ],
      ),
    );
  }
}
