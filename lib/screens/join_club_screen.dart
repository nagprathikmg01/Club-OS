import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../providers/data_provider.dart';
import 'club/create_club_screen.dart';
import '../../services/seed_service.dart';

class JoinClubScreen extends StatefulWidget {
  const JoinClubScreen({super.key});

  @override
  State<JoinClubScreen> createState() => _JoinClubScreenState();
}

class _JoinClubScreenState extends State<JoinClubScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitCode() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await context.read<DataProvider>().joinClub(code);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CLEARENCE REQUEST SENT'), backgroundColor: ClubOsTheme.primaryCommand),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If pending, show waiting UI instead of text field
    final user = context.watch<DataProvider>().currentUser;
    final isPending = user?.status == 'pending';

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: isPending 
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_outlined, size: 64, color: ClubOsTheme.primaryCommand),
                  const SizedBox(height: 32),
                  Text(
                    'SECURITY CLEARANCE PENDING',
                    style: TextStyle(
                      color: ClubOsTheme.primaryCommand,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your verification request is currently being reviewed by organizational leads. Access will be granted upon clearance.',
                    style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 13, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  CircularProgressIndicator(strokeWidth: 2, color: ClubOsTheme.primaryCommand.withOpacity(0.3)),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INITIALIZE LINK',
                    style: TextStyle(
                      color: ClubOsTheme.primaryCommand,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'INPUT ARCHIVE ACCESS KEY (6-DIGIT)',
                    style: TextStyle(
                      color: ClubOsTheme.onSurfaceVariant,
                      letterSpacing: 1,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 48),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PROTOCOL_KEY',
                        style: TextStyle(
                          color: ClubOsTheme.onSurfaceVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _codeController,
                        style: TextStyle(color: ClubOsTheme.onSurfaceMain, letterSpacing: 8, fontWeight: FontWeight.bold, fontSize: 18),
                        textCapitalization: TextCapitalization.characters,
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
                            borderSide: BorderSide(color: ClubOsTheme.primaryCommand, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitCode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: ClubOsTheme.primaryCommand,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('TRANSMIT CODE', style: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateClubScreen()));
                      },
                      child: Text(
                        'INITIALIZE NEW NETWORK',
                        style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ClubOsTheme.tertiaryAnalytical.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ClubOsTheme.tertiaryAnalytical.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'DEMO MODE: INITIALIZE NMIT DATA',
                          style: TextStyle(
                            color: ClubOsTheme.tertiaryAnalytical,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Populate NMIT Bangalore clubs, members, and events for your presentation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54, fontSize: 11),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await SeedService.seedData();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('NMIT SYSTEM DATA INITIALIZED')));
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('INITIALIZATION ERROR: $e')));
                              }
                            }
                          },
                          icon: const Icon(Icons.auto_awesome, size: 18),
                          label: const Text('SEED NMIT SYSTEM DATA'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ClubOsTheme.tertiaryAnalytical,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
