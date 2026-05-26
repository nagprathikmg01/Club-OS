import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../theme.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../services/certificate_service.dart';

class EliteIdScreen extends StatelessWidget {
  const EliteIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = context.watch<DataProvider>();
    final user = dataProvider.currentUser!;

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('DIGITAL IDENTITY', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900, fontSize: 14)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlassmorphicContainer(
              width: 350,
              height: 500,
              borderRadius: 30,
              blur: 20,
              alignment: Alignment.bottomCenter,
              border: 2,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ClubOsTheme.primaryCommand.withOpacity(0.1),
                  ClubOsTheme.primaryCommand.withOpacity(0.05),
                ],
              ),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ClubOsTheme.primaryCommand.withOpacity(0.5),
                  Colors.white.withOpacity(0.5),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ClubOsTheme.primaryCommand, width: 3),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=1000&auto=format&fit=crop'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      user.name.toUpperCase(),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                    ),
                    Text(
                      user.role.toUpperCase().replaceAll('_', ' '),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ClubOsTheme.primaryCommand, letterSpacing: 4),
                    ),
                    const SizedBox(height: 40),
                    _buildStatRow('DOMAIN', user.domain?.toUpperCase() ?? 'UNASSIGNED'),
                    const Divider(color: Colors.black12, height: 32),
                    _buildStatRow('LEVEL', user.level.toString()),
                    const SizedBox(height: 12),
                    _buildStatRow('EXP', '${user.xp} / ${(user.level) * 1000}'),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'SYSTEM AUTHENTICATED',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => CertificateService.generateAndPrint(user, dataProvider.activeClub.name),
              icon: const Icon(Icons.download_rounded),
              label: const Text('EXPORT IDENTITY'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ClubOsTheme.primaryCommand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
      ],
    );
  }
}
