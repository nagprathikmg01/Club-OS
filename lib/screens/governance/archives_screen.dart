import 'package:flutter/material.dart';
import '../../theme.dart';

class ArchivesScreen extends StatelessWidget {
  const ArchivesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(ClubOsTheme.gutterLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text('REPOSITORY V4.2', style: ClubOsTheme.lightTheme.textTheme.labelSmall),
            const SizedBox(height: 8),
            Text('ARCHIVES', style: ClubOsTheme.lightTheme.textTheme.displayLarge?.copyWith(fontSize: 48)),
            const SizedBox(height: 12),
            const Text(
              'Centralized knowledge base for organization governance, historical documentation, and legal frameworks.',
              style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 48),

            // Bylaws Section (High-Density)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildBentoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.gavel, color: ClubOsTheme.secondaryIntelligence, size: 28),
                            const SizedBox(width: 12),
                            Text('ORGANIZATION BYLAWS', style: ClubOsTheme.lightTheme.textTheme.headlineSmall?.copyWith(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildArchiveItem('Main Charter 2024.v2', 'Core governance framework and founding principles.', 'PDF • 4.2 MB', true),
                        const SizedBox(height: 16),
                        _buildArchiveItem('Member Conduct Policy', 'Updated ethics and community standards guide.', 'DOCX • 1.8 MB', false),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Quick Access
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ClubOsTheme.secondaryIntelligence,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('QUICK ACCESS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 11)),
                        const SizedBox(height: 24),
                        _buildQuickLink('Member Onboarding Kit'),
                        _buildQuickLink('Annual Financial Report'),
                        _buildQuickLink('Emergency Protocols'),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('REQUEST NEW FILE'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // Meeting Minutes List
            Text('MEETING MINUTES', style: ClubOsTheme.lightTheme.textTheme.headlineSmall?.copyWith(fontSize: 14)),
            const SizedBox(height: 16),
            _buildBentoCard(
              child: Column(
                children: [
                  _buildMinuteRow('Board Meeting - July 2024', 'July 14, 2024', '1.2 MB'),
                  const Divider(height: 32),
                  _buildMinuteRow('General Assembly - Q2', 'June 22, 2024', '2.5 MB'),
                  const Divider(height: 32),
                  _buildMinuteRow('Emergency Bylaw Session', 'May 10, 2024', '890 KB'),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Archive Health
            _buildBentoCard(
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ARCHIVE HEALTH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1, color: ClubOsTheme.onSurfaceVariant)),
                        SizedBox(height: 12),
                        Text('98%', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('AUTOMATIC BACKUPS ACTIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClubOsTheme.primaryCommand)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'All documents are cryptographically signed and immutable via the Blockchain verification layer.',
                      style: TextStyle(fontSize: 12, color: ClubOsTheme.onSurfaceVariant.withOpacity(0.7)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ClubOsTheme.solarSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _buildArchiveItem(String title, String desc, String meta, bool isNew) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ClubOsTheme.solarSurfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isNew ? ClubOsTheme.primaryCommand.withOpacity(0.3) : Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
              if (isNew) Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: ClubOsTheme.primaryCommand, borderRadius: BorderRadius.circular(4)),
                child: const Text('LATEST', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 12, color: ClubOsTheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(meta, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceVariant)),
              const Icon(Icons.download, size: 16, color: ClubOsTheme.primaryCommand),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLink(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.white54, size: 14),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildMinuteRow(String title, String date, String size) {
    return Row(
      children: [
        const Icon(Icons.article, color: ClubOsTheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(date, style: const TextStyle(fontSize: 11, color: ClubOsTheme.onSurfaceVariant)),
            ],
          ),
        ),
        Text(size, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceVariant)),
        const SizedBox(width: 16),
        const Icon(Icons.chevron_right, size: 18),
      ],
    );
  }
}
