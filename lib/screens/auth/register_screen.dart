import 'dart:ui';
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

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _bgCtrl;
  late AnimationController _animCtrl;
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;

  @override
  void initState() {
    super.initState();
    // Ambient glowing background animation
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // Staggered entry animations for form fields
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnims = List.generate(6, (i) {
      double start = i * 0.08;
      double end = (start + 0.4).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _animCtrl,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    _slideAnims = List.generate(6, (i) {
      double start = i * 0.08;
      double end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animCtrl,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ));
    });

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bgCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showError('PLEASE COMPLETE ALL INPUT CRITERIA');
      return;
    }
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
      
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showError(e.toString().toUpperCase());
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5)),
        backgroundColor: ClubOsTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgCtrl,
        builder: (context, child) {
          return Stack(
            children: [
              // ── Animated Ambient Light Orbs ──
              Container(color: ClubOsTheme.solarBase),
              Positioned(
                top: -100 + (_bgCtrl.value * 80),
                left: -100 + (_bgCtrl.value * 50),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ClubOsTheme.primaryCommand.withOpacity(0.08),
                        blurRadius: 140,
                        spreadRadius: 80,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -100 + (_bgCtrl.value * 60),
                right: -100 + (_bgCtrl.value * 80),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: ClubOsTheme.secondaryIntelligence.withOpacity(0.08),
                        blurRadius: 140,
                        spreadRadius: 80,
                      ),
                    ],
                  ),
                ),
              ),

              // Back Navigation Button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: ClubOsTheme.onSurfaceMain, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // ── Foreground Layout ──
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(28, 48, 28, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isSmallScreen ? double.infinity : 400,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: ClubOsTheme.solarSurfaceLowest.withOpacity(ClubOsTheme.isDark ? 0.35 : 0.65),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: ClubOsTheme.outlineVariant.withOpacity(ClubOsTheme.isDark ? 0.35 : 0.6),
                                width: 1.5,
                              ),
                              boxShadow: ClubOsTheme.cardShadow,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Logo and Brand
                                _buildAnimatedItem(
                                  index: 0,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [ClubOsTheme.primaryCommand, ClubOsTheme.secondaryIntelligence],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ClubOsTheme.primaryCommand.withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(Icons.hub_rounded, color: Colors.white, size: 22),
                                      ),
                                      const SizedBox(width: 14),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ClubOS',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: ClubOsTheme.onSurfaceMain,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          Text(
                                            'SYSTEM REGISTER',
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w800,
                                              color: ClubOsTheme.primaryCommand,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Name Input
                                _buildAnimatedItem(
                                  index: 1,
                                  child: _buildTextField(
                                    label: 'FULL NAME',
                                    controller: _nameController,
                                    obscure: false,
                                    icon: Icons.person_outline_rounded,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Email Input
                                _buildAnimatedItem(
                                  index: 2,
                                  child: _buildTextField(
                                    label: 'EMAIL ADDRESS',
                                    controller: _emailController,
                                    obscure: false,
                                    icon: Icons.alternate_email_rounded,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Password Input
                                _buildAnimatedItem(
                                  index: 3,
                                  child: _buildTextField(
                                    label: 'PASSWORD',
                                    controller: _passwordController,
                                    obscure: true,
                                    icon: Icons.lock_outline_rounded,
                                  ),
                                ),
                                const SizedBox(height: 36),

                                // Register Button
                                _buildAnimatedItem(
                                  index: 4,
                                  child: _buildPrimaryButton(
                                    text: 'CREATE ACCOUNT',
                                    onPressed: _register,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Back to Login Redirect
                                _buildAnimatedItem(
                                  index: 5,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.5,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "ALREADY REGISTERED? ",
                                              style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                                            ),
                                            TextSpan(
                                              text: "SIGN IN",
                                              style: TextStyle(color: ClubOsTheme.primaryCommand, fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
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
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedItem({required int index, required Widget child}) {
    return FadeTransition(
      opacity: _fadeAnims[index],
      child: SlideTransition(
        position: _slideAnims[index],
        child: child,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ClubOsTheme.onSurfaceVariant,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(color: ClubOsTheme.onSurfaceMain, fontSize: 14, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: ClubOsTheme.onSurfaceVariant.withOpacity(0.6), size: 18),
            filled: true,
            fillColor: ClubOsTheme.solarSurfaceLow.withOpacity(ClubOsTheme.isDark ? 0.3 : 0.5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: ClubOsTheme.outlineVariant.withOpacity(ClubOsTheme.isDark ? 0.3 : 0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: ClubOsTheme.primaryCommand, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({required String text, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ClubOsTheme.primaryCommand, ClubOsTheme.secondaryIntelligence],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: ClubOsTheme.primaryCommand.withOpacity(0.24),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                text,
                style: const TextStyle(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
      ),
    );
  }
}
