import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true); // spinner start
    try {
      // Sign up user and ensure Firestore write succeeds
      await AuthService().signUp(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      // Only show success if both Auth and Firestore succeeded
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );

      // Navigate to Login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      // Show meaningful error (Auth + Firestore)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mapAuthError(e))));
    } finally {
      setState(() => loading = false); // spinner end
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.indigo, Colors.blueGrey],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("assets/collage/logo.png"),
                ),
                const SizedBox(height: 20),
                Text(
                  "Create Account",
                  style: GoogleFonts.orbitron(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      formField(
                        nameController,
                        "Full Name",
                        Icons.person,
                        validator: (v) => v!.isEmpty ? "Enter name" : null,
                      ),
                      const SizedBox(height: 15),
                      formField(
                        emailController,
                        "Email",
                        Icons.email,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Enter email";
                          if (!v.contains("@")) return "Invalid email";
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.info_outline,
                              color: Colors.cyanAccent,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Use a valid email! Verification & password reset links will be sent here.",
                                style: TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      formField(
                        passwordController,
                        "Password",
                        Icons.lock,
                        obscure: true,
                        validator: (v) {
                          if (v == null || v.length < 6) {
                            return "Password min 6 chars";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: button,
                        onPressed: signup,
                        child:
                            loading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text("Sign Up"),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Alredy Signed Up? ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          GestureDetector(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPage(),
                                  ),
                                ),
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                color: Colors.cyanAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
