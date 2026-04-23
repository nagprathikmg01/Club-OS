import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme.dart';
import '../../models/app_user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() { _isLoading = true; });
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      final uid = credential.user!.uid;
      String newRole = 'member';
      String newStatus = 'pending';

      if (_emailController.text.trim().toLowerCase() == 'prathik32p@gmail.com') {
         newRole = 'owner';
         newStatus = 'active'; // Owner does not need approval
      }
      
      final appUser = AppUser(
        uid: uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: newRole,
        status: newStatus,
      );
      
      await FirebaseFirestore.instance.collection('users').doc(uid).set(appUser.toMap());
      
      if (mounted) Navigator.pop(context); // Go back to login or auto redirect handles it
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ClubOsTheme.primaryCommand, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ClubOS by Nag Prathik',
                  style: TextStyle(
                    color: ClubOsTheme.primaryCommand,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'INITIALIZE NEW USER CREDENTIALS',
                  style: TextStyle(
                    color: ClubOsTheme.onSurfaceVariant,
                    letterSpacing: 1,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),
                _buildTextField('FULL NAME', _nameController, false),
                const SizedBox(height: 24),
                _buildTextField('EMAIL ADDRESS', _emailController, false),
                const SizedBox(height: 24),
                _buildTextField('PASSWORD', _passwordController, true),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: ClubOsTheme.primaryCommand,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('REGISTER ACCOUNT', style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool obscure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: ClubOsTheme.onSurfaceVariant,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: ClubOsTheme.onSurfaceMain),
          decoration: InputDecoration(
            filled: true,
            fillColor: ClubOsTheme.solarSurfaceLowest,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ClubOsTheme.primaryCommand, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
