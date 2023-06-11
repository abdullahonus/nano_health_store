// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:nano_health_store/screens/products/product_screen.dart';
import 'package:nano_health_store/services/auth_services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'mor_2314');
  final _passwordController = TextEditingController(text: '83r5^_');
  final _authService = AuthService();
  bool isApproved = false;
  bool isPasswordVisible = false;

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      await _authService.loginUser(username, password);
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ProductsScreen(),
        ),
      );
      // Navigate to the products screen
    } catch (e) {
      // Handle error
      const snackBar = SnackBar(
        content: Text('Wrong Password or Email'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print(e);
    }
  }

  void asyncInit() {
    if (_usernameController.text.length >= 5 || _usernameController.text == 'mor_2314') {
      setState(() {
        isApproved = true;
      });
    } else {
      setState(() {
        isApproved = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          const Image(
              image: AssetImage(
                "assets/images/login_background/bg.png",
              ),
              fit: BoxFit.fill),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) {
                asyncInit();
              },
              controller: _usernameController,
              decoration: InputDecoration(
                suffixIcon: isApproved
                    ? const Icon(
                        Icons.done,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.do_disturb_rounded,
                        color: Colors.red,
                      ),
                labelText: 'Username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility))),
              obscureText: isPasswordVisible,
            ),
          ),
          ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                MediaQuery.of(context).size.width / 1.2,
                MediaQuery.of(context).size.height / 12,
              ),
              shape: const StadiumBorder(),
              backgroundColor: const Color(0xff2AB3C6),
            ),
            child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(onPressed: () {}, child: const Text("NEED HELP?", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16)))
        ],
      ),
    );
  }
}
