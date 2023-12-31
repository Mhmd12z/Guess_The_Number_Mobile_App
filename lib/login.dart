import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import 'dart:convert' as convert;
import "home.dart";
import "package:shared_preferences/shared_preferences.dart";
import "./signup.dart";

const String _baseURL = 'https://mhmd12z.000webhostapp.com';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  @override
  void dispose() {
    _controllerUserName.dispose();
    _controllerPass.dispose();
    super.dispose();
  }
  void goToHome() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("username")!=null){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=> const HomePage())
      );
    }
  }
  @override
  void initState(){
    goToHome();
    super.initState();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text,style: const TextStyle(color: Colors.deepPurple),),backgroundColor: Colors.white70,showCloseIcon: true,closeIconColor: Colors.black45,));
    setState(() {
      _loading = false;
    });
  }
  Future<void> saveUserInfo(String user,String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', user);
    prefs.setString('uid', userId);
  }

  void login(
      Function (String text) update,
      String username,
      String password
      ) async {
    try{
      final response = await http
          .post(
        Uri.parse('$_baseURL/getUser.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      )
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        var userId = convert.jsonDecode(response.body);
        await saveUserInfo(username,userId);
        update(response.body);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
      } else if(response.statusCode==404){
        update("The user is not registered");
      }else if(response.statusCode==401){
        update("The password is not correct");
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
                  "Login!",
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
                              onPressed: _loading? null : () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _loading = true;
                                  });
                                login(update, _controllerUserName.text.toString(),_controllerPass.text.toString());
                                }
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Icon(Icons.login), Text("Login!")],
                              )),
                        ),
                        ElevatedButton(onPressed: () async{
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.remove('username');
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomePage()));
                        }, child: const Text("Play as Guest!")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=> const SignUp())
                              );
                            },
                            child: const Text(
                              "Create an account?",
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
