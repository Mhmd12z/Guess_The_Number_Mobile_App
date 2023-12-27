import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'dart:convert' as convert;
import "home.dart";
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import "./login.dart";

const String _baseURL = 'https://mhmd12z.000webhostapp.com';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final EncryptedSharedPreferences _encryptedData =
      EncryptedSharedPreferences(); // used to store the key later
  bool _loading = false;

  @override
  void dispose() {
    _controllerUserName.dispose();
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPass.dispose();
    final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences(); // used to store the key later
    super.dispose();
  }

  // this function opens the Add Category page, if we managed to save key successfully
  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text,style: TextStyle(color: Colors.deepPurple),),showCloseIcon: true,backgroundColor: Colors.white70,));
    setState(() {
      _loading = false;
    });
  }

  Future<void> saveUserInfo(String username, String email) async {
    _encryptedData.setString('username', username);
    _encryptedData.setString('email', email);
  }

  void signUp(
    Function(String text) update,
    String username,
    String name,
    String email,
    String password,
  ) async {
    try {
      // Send a JSON object using http post
      final response = await http
          .post(
            Uri.parse('$_baseURL/saveUser.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: convert.jsonEncode(<String, String>{
              'username': username,
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        await saveUserInfo(username, password);
        // If successful, call the update function with the response body
        update(response.body);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
      } else if(response.statusCode==409){
        update("The user is already registered");
      }
      else {
        // Handle other status codes (e.g., display specific error messages)
        update("Server error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle various exceptions (timeout, connection issues, etc.)
      update("Connection error: $e");
    }
  }

  // opens the Add Category page, if the key exists. It is called when
  // the application starts
  // void checkSavedData() async {
  //   _encryptedData.getString('username').then((String myKey) {
  //     if (myKey.isNotEmpty) {
  //       Navigator.of(context)
  //           .push(MaterialPageRoute(builder: (context) => const HomePage()));
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bgc.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Sign Up!",
                  style: TextStyle(
                      backgroundColor: Colors.deepPurple,
                      fontSize: 30,
                      color: Colors.white),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(200)),
                      color: Colors.white70,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _controllerUserName,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                                hintText: "Username",
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _controllerName,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                                hintText: "Name", border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _controllerEmail,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                                hintText: "Email",
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: _controllerPass,
                            autocorrect: false,
                            enableSuggestions: false,
                            obscureText: true,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                                hintText: "Password",
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          height: 35,
                          child: ElevatedButton(
                              onPressed: _loading ? null : (){
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  signUp(update, _controllerUserName.text.toString(), _controllerName.text.toString(),_controllerEmail.text.toString(),_controllerPass.text.toString());
                                }
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.login), Text("Sign Up!")],
                              )),
                        ),
                        TextButton(
                            onPressed: (){
                                Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=>Login())
                                );
                            },
                            child: const Text(
                              "Login Here!",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
