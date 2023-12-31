import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import 'dart:convert' as convert;
import "home.dart";
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

  bool _loading = false;

  @override
  void dispose() {
    _controllerUserName.dispose();
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPass.dispose();
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text,style: const TextStyle(color: Colors.deepPurple),),backgroundColor: Colors.white70,showCloseIcon: true,closeIconColor: Colors.black45,));
    setState(() {
      _loading = false;
    });
  }

  Future<void> saveUserInfo(String username, String email,String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('email', email);
    prefs.setString('uid', userId);
  }

  void signUp(
    Function(String text) update,
    String username,
    String name,
    String email,
    String password,
  ) async {
    try {
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
        String userId = convert.jsonDecode(response.body);
        await saveUserInfo(username, password,userId);
        update(response.body);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
      } else if(response.statusCode==409){
        update("The user is already registered");
      }
      else {
        update("Server error: ${response.statusCode}");
      }
    } catch (e) {
      update("Connection error: $e");
    }
  }

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
                                return 'Please enter your name';
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
                                return 'Please enter your email';
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
                          width: 200,
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
                                MaterialPageRoute(builder: (context)=>const Login())
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
