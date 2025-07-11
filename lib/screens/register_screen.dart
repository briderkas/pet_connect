import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _username = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  Future<void> _signUpEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (mounted) Navigator.pushReplacementNamed(context, '/welcome');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? 'Error')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signUpFacebook() async {
    setState(() => _loading = true);
    try {
      final fbResult = await FacebookAuth.instance.login();
      if (fbResult.status == LoginStatus.success) {
        final fbAuth = fbResult.accessToken!;
        final cred = FacebookAuthProvider.credential(fbAuth.tokenString);
        await FirebaseAuth.instance.signInWithCredential(cred);
        if (mounted) Navigator.pushReplacementNamed(context, '/welcome');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/register.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.45)),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('PetConnect',
                        style: GoogleFonts.pacifico(
                            fontSize: 34, color: Colors.white)),
                    const SizedBox(height: 32),

                    /// Glassmorphism register form
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Username field
                                TextFormField(
                                  controller: _username,
                                  decoration: InputDecoration(
                                    hintText: 'Username',
                                    hintStyle:
                                    const TextStyle(color: Colors.white70),
                                    prefixIcon: const Icon(Icons.person,
                                        color: Colors.white70),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                      const BorderSide(color: Colors.white70),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  validator: (v) => v!.isEmpty ? 'Required' : null,
                                ),
                                const SizedBox(height: 12),

                                // Email field
                                TextFormField(
                                  controller: _email,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle:
                                    const TextStyle(color: Colors.white70),
                                    prefixIcon: const Icon(Icons.email,
                                        color: Colors.white70),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                      const BorderSide(color: Colors.white70),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  validator: (v) =>
                                  v!.contains('@') ? null : 'Enter valid email',
                                ),
                                const SizedBox(height: 12),

                                // Password field
                                TextFormField(
                                  controller: _password,
                                  obscureText: _obscure,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle:
                                    const TextStyle(color: Colors.white70),
                                    prefixIcon: const Icon(Icons.lock,
                                        color: Colors.white70),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () => setState(
                                              () => _obscure = !_obscure),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                      const BorderSide(color: Colors.white70),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  validator: (v) =>
                                  v!.length < 6 ? 'Min 6 chars' : null,
                                ),
                                const SizedBox(height: 12),

                                // Confirm password field
                                TextFormField(
                                  controller: _confirm,
                                  obscureText: _obscure,
                                  decoration: InputDecoration(
                                    hintText: 'Confirm password',
                                    hintStyle:
                                    const TextStyle(color: Colors.white70),
                                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                                        color: Colors.white70),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                      const BorderSide(color: Colors.white70),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                  validator: (v) =>
                                  v != _password.text ? 'Does not match' : null,
                                ),
                                const SizedBox(height: 24),

                                // Sign-up button
                                _loading
                                    ? const CircularProgressIndicator()
                                    : Column(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: _signUpEmail,
                                      icon: const Icon(Icons.pets),
                                      label: const Text('Sign Up'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFD4A373),
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(double.infinity, 48),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Facebook sign-up button
                                    ElevatedButton.icon(
                                      onPressed: _signUpFacebook,
                                      icon: Image.asset(
                                        'assets/icons/facebook.png',
                                        height: 22,
                                      ),
                                      label: const Text('Sign Up with Facebook'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1877F2),
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(double.infinity, 46),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('By continuing you agree to our User Agreement and acknowledge the Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Already have an account? Log in',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}